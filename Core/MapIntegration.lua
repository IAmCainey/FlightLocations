-- Map Integration for Flight Locations
-- Handles world map and minimap integration

FlightLocations.MapIntegration = {}

-- Map icon textures
local ICON_DISCOVERED = "Interface\\TaxiFrame\\UI-Taxi-Icon-Green"
local ICON_UNDISCOVERED = "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray"
local ICON_ALLIANCE = "Interface\\TaxiFrame\\UI-Taxi-Icon-Blue"
local ICON_HORDE = "Interface\\TaxiFrame\\UI-Taxi-Icon-Red"
local ICON_NEUTRAL = "Interface\\TaxiFrame\\UI-Taxi-Icon-Yellow"

-- Storage for map icons
local mapIcons = {}
local minimapIcons = {}

function FlightLocations.MapIntegration:Initialize()
    self:SetupWorldMapHooks()
    FlightLocations:Debug("Map integration initialized")
end

function FlightLocations.MapIntegration:SetupWorldMapHooks()
    -- Hook into world map updates
    if WorldMapFrame then
        local originalShow = WorldMapFrame.Show
        WorldMapFrame.Show = function()
            originalShow()
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
        
        -- Hook zone changes on world map
        local originalSetMapZoom = SetMapZoom
        SetMapZoom = function(...)
            originalSetMapZoom(unpack(arg))
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end
end

function FlightLocations.MapIntegration:UpdateMapOverlay()
    if not FlightLocationsDB.enableWorldMap then
        self:ClearMapIcons()
        return
    end
    
    -- Use the UI MapOverlay if available, otherwise fall back to our implementation
    if FlightLocations.UI and FlightLocations.UI.MapOverlay then
        FlightLocations.UI.MapOverlay:UpdateOverlay()
    else
        -- Fallback implementation
        self:UpdateMapOverlayDirect()
    end
end

function FlightLocations.MapIntegration:UpdateMapOverlayDirect()
    -- Clear existing icons
    self:ClearMapIcons()
    
    -- Get current map info
    local currentContinent, currentZone = GetCurrentMapContinent(), GetCurrentMapZone()
    if not currentContinent or currentContinent == 0 then
        return
    end
    
    -- Get flight points for current map
    local flightPoints = self:GetFlightPointsForCurrentMap()
    if not flightPoints or table.getn(flightPoints) == 0 then
        return
    end
    
    -- Filter flight points based on settings
    if FlightLocations.Core then
        flightPoints = FlightLocations.Core:FilterFlightPointsBySettings(flightPoints)
    end
    
    -- Create icons for each flight point
    for i, point in ipairs(flightPoints) do
        self:CreateMapIcon(point)
    end
    
    FlightLocations:Debug("Updated map overlay with " .. table.getn(flightPoints) .. " flight points")
end

function FlightLocations.MapIntegration:GetFlightPointsForCurrentMap()
    if not FlightLocations.Database then
        return {}
    end
    
    local currentContinent, currentZone = GetCurrentMapContinent(), GetCurrentMapZone()
    local zoneName = GetMapZones(currentContinent)[currentZone]
    
    if not zoneName then
        -- If we're viewing a continent map, get all points for that continent
        return FlightLocations.Database:GetFlightPointsForContinent(currentContinent)
    else
        -- If we're viewing a zone map, get points for that zone
        return FlightLocations.Database:GetFlightPointsForZone(zoneName)
    end
end

function FlightLocations.MapIntegration:CreateMapIcon(point)
    local iconFrame = CreateFrame("Button", "FlightLocationIcon" .. table.getn(mapIcons) + 1, WorldMapDetailFrame)
    
    -- Set icon texture based on discovery status and faction
    local texture = self:GetIconTexture(point)
    iconFrame:SetNormalTexture(texture)
    
    -- Set icon size
    local iconSize = FlightLocationsDB.iconSize or 16
    iconFrame:SetWidth(iconSize)
    iconFrame:SetHeight(iconSize)
    
    -- Set icon position
    local x, y = self:ConvertCoordinates(point.x, point.y)
    iconFrame:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y)
    
    -- Set icon alpha
    iconFrame:SetAlpha(FlightLocationsDB.iconAlpha or 0.8)
    
    -- Setup tooltip
    if FlightLocationsDB.showTooltips then
        self:SetupIconTooltip(iconFrame, point)
    end
    
    -- Setup click handling
    iconFrame:SetScript("OnClick", function()
        self:OnIconClick(point)
    end)
    
    iconFrame:Show()
    table.insert(mapIcons, iconFrame)
    
    return iconFrame
end

function FlightLocations.MapIntegration:GetIconTexture(point)
    local isDiscovered = FlightLocations.Database and FlightLocations.Database:IsFlightPointDiscovered(point)
    
    if isDiscovered then
        -- Use faction-specific icons for discovered points
        if point.faction == "Alliance" then
            return ICON_ALLIANCE
        elseif point.faction == "Horde" then
            return ICON_HORDE
        else
            return ICON_NEUTRAL
        end
    else
        -- Use gray icon for undiscovered points
        return ICON_UNDISCOVERED
    end
end

function FlightLocations.MapIntegration:ConvertCoordinates(x, y)
    -- Convert game coordinates (0-100) to pixel coordinates on the map
    local mapWidth = WorldMapDetailFrame:GetWidth()
    local mapHeight = WorldMapDetailFrame:GetHeight()
    
    local pixelX = (x / 100) * mapWidth
    local pixelY = (y / 100) * mapHeight
    
    return pixelX, pixelY
end

function FlightLocations.MapIntegration:SetupIconTooltip(iconFrame, point)
    iconFrame:SetScript("OnEnter", function()
        GameTooltip:SetOwner(iconFrame, "ANCHOR_RIGHT")
        
        -- Set tooltip title
        local isDiscovered = FlightLocations.Database and FlightLocations.Database:IsFlightPointDiscovered(point)
        local title = point.name
        if not isDiscovered then
            title = title .. " |cffff0000(Undiscovered)|r"
        end
        
        GameTooltip:SetText(title, 1, 1, 1)
        
        -- Add zone information
        GameTooltip:AddLine("Zone: " .. point.zone, 0.8, 0.8, 0.8)
        
        -- Add faction information
        local factionColor = {r = 1, g = 1, b = 1}
        if point.faction == "Alliance" then
            factionColor = {r = 0, g = 0.4, b = 0.8}
        elseif point.faction == "Horde" then
            factionColor = {r = 0.8, g = 0, b = 0}
        elseif point.faction == "Neutral" then
            factionColor = {r = 1, g = 0.8, b = 0}
        end
        
        GameTooltip:AddLine("Faction: " .. point.faction, factionColor.r, factionColor.g, factionColor.b)
        
        -- Add coordinates
        GameTooltip:AddLine("Coordinates: " .. string.format("%.1f, %.1f", point.x, point.y), 0.6, 0.6, 0.6)
        
        if isDiscovered then
            GameTooltip:AddLine("|cff00ff00Right-click for more options|r", 0, 1, 0)
        else
            GameTooltip:AddLine("|cffff8000Visit this location to discover|r", 1, 0.5, 0)
        end
        
        GameTooltip:Show()
    end)
    
    iconFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function FlightLocations.MapIntegration:OnIconClick(point)
    local isDiscovered = FlightLocations.Database and FlightLocations.Database:IsFlightPointDiscovered(point)
    
    if IsShiftKeyDown() then
        -- Shift+click to announce in chat
        local message = "Flight Point: " .. point.name .. " in " .. point.zone .. " (" .. point.x .. ", " .. point.y .. ")"
        SendChatMessage(message, "SAY")
    elseif IsControlKeyDown() then
        -- Ctrl+click to copy coordinates to chat
        local coords = string.format("%.1f, %.1f", point.x, point.y)
        DEFAULT_CHAT_FRAME:AddMessage("Flight point coordinates: " .. coords)
    else
        -- Normal click - show information
        FlightLocations:Print("Flight Point: " .. point.name .. " (" .. (isDiscovered and "Discovered" or "Undiscovered") .. ")")
    end
end

function FlightLocations.MapIntegration:ClearMapIcons()
    for i, icon in ipairs(mapIcons) do
        if icon then
            icon:Hide()
            icon:SetParent(nil)
        end
    end
    mapIcons = {}
end

function FlightLocations.MapIntegration:ClearMinimapIcons()
    for i, icon in ipairs(minimapIcons) do
        if icon then
            icon:Hide()
            icon:SetParent(nil)
        end
    end
    minimapIcons = {}
end

-- Minimap integration (optional, can be enabled/disabled)
function FlightLocations.MapIntegration:UpdateMinimapIcons()
    if not FlightLocationsDB.enableMinimap then
        self:ClearMinimapIcons()
        return
    end
    
    -- This would require more complex coordinate conversion for minimap
    -- and is typically more intrusive, so it's disabled by default
end

-- Public interface
function FlightLocations.MapIntegration:ToggleWorldMapIcons()
    FlightLocationsDB.enableWorldMap = not FlightLocationsDB.enableWorldMap
    self:UpdateMapOverlay()
    return FlightLocationsDB.enableWorldMap
end

function FlightLocations.MapIntegration:ToggleMinimapIcons()
    FlightLocationsDB.enableMinimap = not FlightLocationsDB.enableMinimap
    self:UpdateMinimapIcons()
    return FlightLocationsDB.enableMinimap
end

function FlightLocations.MapIntegration:SetIconSize(size)
    FlightLocationsDB.iconSize = math.max(8, math.min(32, size))
    self:UpdateMapOverlay()
end

function FlightLocations.MapIntegration:SetIconAlpha(alpha)
    FlightLocationsDB.iconAlpha = math.max(0.1, math.min(1.0, alpha))
    self:UpdateMapOverlay()
end
