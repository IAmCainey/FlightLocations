-- Core FlightLocations functionality
-- Handles the main addon logic and coordination

FlightLocations.Core = FlightLocations.Core or {}

-- Event handlers and core functionality
function FlightLocations.Core:Initialize()
    self:RegisterEvents()
    self:InitializeSettings()
    FlightLocations:Debug("Core module initialized")
end

function FlightLocations.Core:RegisterEvents()
    -- Register for relevant WoW events
    local events = {
        "ADDON_LOADED",
        "PLAYER_ENTERING_WORLD",
        "ZONE_CHANGED_NEW_AREA",
        "TAXIMAP_OPENED",
        "TAXIMAP_CLOSED",
        "WORLD_MAP_UPDATE"
    }
    
    for _, event in ipairs(events) do
        self:RegisterEvent(event)
    end
end

function FlightLocations.Core:InitializeSettings()
    -- Initialize default settings if they don't exist
    local defaults = {
        showUndiscovered = true,
        showDiscovered = true,
        iconSize = 16,
        showTooltips = true,
        enableWorldMap = true,
        enableMinimap = false, -- Disabled by default to avoid clutter
        iconAlpha = 0.8,
        filterByFaction = true
    }
    
    for key, value in pairs(defaults) do
        if FlightLocationsDB[key] == nil then
            FlightLocationsDB[key] = value
        end
    end
end

function FlightLocations.Core:OnEvent(event, ...)
    if event == "ADDON_LOADED" and arg1 == "FlightLocations" then
        self:OnAddonLoaded()
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:OnPlayerEnteringWorld()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        self:OnZoneChanged()
    elseif event == "TAXIMAP_OPENED" then
        self:OnTaxiMapOpened()
    elseif event == "TAXIMAP_CLOSED" then
        self:OnTaxiMapClosed()
    elseif event == "WORLD_MAP_UPDATE" then
        self:OnWorldMapUpdate()
    end
end

function FlightLocations.Core:OnAddonLoaded()
    FlightLocations:Print("Flight Locations addon loaded successfully!")
    
    -- Initialize database
    if FlightLocations.Database then
        FlightLocations.Database:Initialize()
    end
    
    -- Initialize map integration
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:Initialize()
    end
end

function FlightLocations.Core:OnPlayerEnteringWorld()
    -- Delay the map update to ensure everything is loaded
    self:ScheduleTimer("UpdateMapDisplay", 2)
end

function FlightLocations.Core:OnZoneChanged()
    self:UpdateMapDisplay()
end

function FlightLocations.Core:OnTaxiMapOpened()
    -- When taxi map opens, we can detect which flight points are available
    self:UpdateDiscoveredFlightPoints()
end

function FlightLocations.Core:OnTaxiMapClosed()
    -- Update our display after taxi map closes
    self:ScheduleTimer("UpdateMapDisplay", 0.5)
end

function FlightLocations.Core:OnWorldMapUpdate()
    if WorldMapFrame:IsVisible() then
        self:UpdateMapDisplay()
    end
end

function FlightLocations.Core:UpdateMapDisplay()
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end
end

function FlightLocations.Core:UpdateDiscoveredFlightPoints()
    -- This would scan the currently open taxi map to detect available flight points
    -- For Vanilla WoW, this requires checking TaxiNodeName() function
    
    if not TaxiFrame or not TaxiFrame:IsVisible() then
        return
    end
    
    -- Scan taxi nodes (Vanilla WoW method)
    for i = 1, NumTaxiNodes() do
        local nodeType = TaxiNodeGetType(i)
        if nodeType == "CURRENT" or nodeType == "REACHABLE" then
            local nodeName = TaxiNodeName(i)
            local x, y = TaxiNodePosition(i)
            
            if nodeName and x and y then
                -- Find matching flight point in database
                local currentZone = GetRealZoneText()
                local flightPoints = FlightLocations.Database:GetFlightPointsForZone(currentZone)
                
                for j, point in ipairs(flightPoints) do
                    -- Simple name matching (could be improved)
                    if string.find(string.lower(point.name), string.lower(nodeName)) or 
                       string.find(string.lower(nodeName), string.lower(point.name)) then
                        FlightLocations.Database:MarkFlightPointDiscovered(point)
                        break
                    end
                end
            end
        end
    end
end

function FlightLocations.Core:ScheduleTimer(func, delay)
    -- Simple timer implementation for Vanilla WoW
    local frame = CreateFrame("Frame")
    frame.timeLeft = delay
    frame.func = func
    frame:SetScript("OnUpdate", function()
        frame.timeLeft = frame.timeLeft - arg1
        if frame.timeLeft <= 0 then
            FlightLocations.Core[frame.func](FlightLocations.Core)
            frame:SetScript("OnUpdate", nil)
        end
    end)
end

-- Utility functions
function FlightLocations.Core:GetCurrentZone()
    return GetRealZoneText() or GetZoneText() or "Unknown"
end

function FlightLocations.Core:GetCurrentContinent()
    -- Determine continent based on zone
    -- This is a simplified method - a more robust solution would use coordinates
    local zone = self:GetCurrentZone()
    
    -- Eastern Kingdoms zones (partial list)
    local easternKingdoms = {
        "Stormwind City", "Ironforge", "Undercity", "Elwynn Forest", "Dun Morogh",
        "Tirisfal Glades", "Westfall", "Loch Modan", "Silverpine Forest", 
        "Redridge Mountains", "Wetlands", "Duskwood", "Hillsbrad Foothills",
        "Arathi Highlands", "Stranglethorn Vale", "Badlands", "Searing Gorge",
        "Burning Steppes", "Un'Goro Crater", "Western Plaguelands", "Eastern Plaguelands"
    }
    
    for i, ekZone in ipairs(easternKingdoms) do
        if zone == ekZone then
            return 2 -- Eastern Kingdoms
        end
    end
    
    return 1 -- Default to Kalimdor
end

function FlightLocations.Core:FilterFlightPointsBySettings(flightPoints)
    local filtered = {}
    local playerFaction = FlightLocations.Database:GetPlayerFaction()
    
    for i, point in ipairs(flightPoints) do
        local include = true
        
        -- Filter by discovery status
        local isDiscovered = FlightLocations.Database:IsFlightPointDiscovered(point)
        if isDiscovered and not FlightLocationsDB.showDiscovered then
            include = false
        elseif not isDiscovered and not FlightLocationsDB.showUndiscovered then
            include = false
        end
        
        -- Filter by faction
        if include and FlightLocationsDB.filterByFaction then
            if not FlightLocations.Database:CanUseFlightPoint(point) then
                include = false
            end
        end
        
        if include then
            table.insert(filtered, point)
        end
    end
    
    return filtered
end
