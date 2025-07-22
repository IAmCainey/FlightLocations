-- Map Overlay UI for Flight Locations
-- Handles the visual representation of flight points on maps

FlightLocations.UI = FlightLocations.UI or {}
FlightLocations.UI.MapOverlay = {}

-- Icon pool for efficient memory management
local iconPool = {}
local activeIcons = {}

function FlightLocations.UI.MapOverlay:Initialize()
    self:SetupIconPool()
    self:HookMapEvents()
end

function FlightLocations.UI.MapOverlay:SetupIconPool()
    -- Pre-create some icons for performance
    for i = 1, 20 do
        local icon = self:CreatePooledIcon()
        table.insert(iconPool, icon)
    end
end

function FlightLocations.UI.MapOverlay:CreatePooledIcon()
    local icon = CreateFrame("Button", nil, WorldMapDetailFrame)
    icon:SetWidth(16)
    icon:SetHeight(16)
    icon:Hide()
    
    -- Set up highlight texture
    icon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    return icon
end

function FlightLocations.UI.MapOverlay:GetIconFromPool()
    if table.getn(iconPool) > 0 then
        local icon = iconPool[1]
        table.remove(iconPool, 1)
        return icon
    else
        return self:CreatePooledIcon()
    end
end

function FlightLocations.UI.MapOverlay:ReturnIconToPool(icon)
    if icon then
        icon:Hide()
        icon:ClearAllPoints()
        icon:SetScript("OnEnter", nil)
        icon:SetScript("OnLeave", nil)
        icon:SetScript("OnClick", nil)
        table.insert(iconPool, icon)
    end
end

function FlightLocations.UI.MapOverlay:HookMapEvents()
    -- Hook into map frame events for automatic updates
    if WorldMapFrame then
        WorldMapFrame:HookScript("OnShow", function()
            FlightLocations.UI.MapOverlay:UpdateOverlay()
        end)
        
        WorldMapFrame:HookScript("OnHide", function()
            FlightLocations.UI.MapOverlay:ClearOverlay()
        end)
    end
end

function FlightLocations.UI.MapOverlay:UpdateOverlay()
    -- Clear existing overlay
    self:ClearOverlay()
    
    -- Check if overlay is enabled
    if not FlightLocationsDB or not FlightLocationsDB.enableWorldMap then
        return
    end
    
    -- Get current map information
    local continent, zone = GetCurrentMapContinent(), GetCurrentMapZone()
    if not continent or continent == 0 then
        return
    end
    
    -- Get flight points for current map view
    local flightPoints = self:GetRelevantFlightPoints(continent, zone)
    
    -- Create icons for each flight point
    for i, point in ipairs(flightPoints) do
        self:CreateFlightPointIcon(point)
    end
end

function FlightLocations.UI.MapOverlay:GetRelevantFlightPoints(continent, zone)
    if not FlightLocations.Database then
        return {}
    end
    
    local points = {}
    
    if zone and zone > 0 then
        -- Zone-specific view
        local zoneName = GetMapZones(continent)[zone]
        if zoneName then
            points = FlightLocations.Database:GetFlightPointsForZone(zoneName)
        end
    else
        -- Continent view
        points = FlightLocations.Database:GetFlightPointsForContinent(continent)
    end
    
    -- Filter points based on user settings
    return self:FilterFlightPoints(points)
end

function FlightLocations.UI.MapOverlay:FilterFlightPoints(points)
    local filtered = {}
    
    for i, point in ipairs(points) do
        local include = true
        
        -- Check discovery status filtering
        local isDiscovered = FlightLocations.Database:IsFlightPointDiscovered(point)
        if isDiscovered and not FlightLocationsDB.showDiscovered then
            include = false
        elseif not isDiscovered and not FlightLocationsDB.showUndiscovered then
            include = false
        end
        
        -- Check faction filtering
        if include and FlightLocationsDB.filterByFaction then
            local canUse = FlightLocations.Database:CanUseFlightPoint(point)
            if not canUse then
                include = false
            end
        end
        
        if include then
            table.insert(filtered, point)
        end
    end
    
    return filtered
end

function FlightLocations.UI.MapOverlay:CreateFlightPointIcon(point)
    local icon = self:GetIconFromPool()
    if not icon then
        return
    end
    
    -- Configure icon appearance
    self:ConfigureIcon(icon, point)
    
    -- Position icon on map
    self:PositionIcon(icon, point)
    
    -- Set up interaction
    self:SetupIconInteraction(icon, point)
    
    -- Show the icon
    icon:Show()
    
    -- Add to active icons list
    table.insert(activeIcons, icon)
    
    return icon
end

function FlightLocations.UI.MapOverlay:ConfigureIcon(icon, point)
    local isDiscovered = FlightLocations.Database:IsFlightPointDiscovered(point)
    local texture = self:GetIconTexture(point, isDiscovered)
    
    icon:SetNormalTexture(texture)
    
    -- Set size and alpha
    local size = FlightLocationsDB.iconSize or 16
    icon:SetWidth(size)
    icon:SetHeight(size)
    icon:SetAlpha(FlightLocationsDB.iconAlpha or 0.8)
    
    -- Store point data for interaction
    icon.flightPoint = point
end

function FlightLocations.UI.MapOverlay:GetIconTexture(point, isDiscovered)
    if isDiscovered then
        -- Use faction-specific textures for discovered points
        if point.faction == "Alliance" then
            return "Interface\\TaxiFrame\\UI-Taxi-Icon-Blue"
        elseif point.faction == "Horde" then
            return "Interface\\TaxiFrame\\UI-Taxi-Icon-Red"
        else
            return "Interface\\TaxiFrame\\UI-Taxi-Icon-Yellow"
        end
    else
        -- Gray texture for undiscovered points
        return "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray"
    end
end

function FlightLocations.UI.MapOverlay:PositionIcon(icon, point)
    -- Convert world coordinates to map pixel coordinates
    local x, y = self:WorldToMapCoords(point.x, point.y)
    
    if x and y then
        icon:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", x, -y)
    end
end

function FlightLocations.UI.MapOverlay:WorldToMapCoords(worldX, worldY)
    -- Convert percentage-based coordinates to pixel coordinates
    local mapWidth = WorldMapDetailFrame:GetWidth()
    local mapHeight = WorldMapDetailFrame:GetHeight()
    
    if mapWidth and mapHeight and mapWidth > 0 and mapHeight > 0 then
        local pixelX = (worldX / 100) * mapWidth
        local pixelY = (worldY / 100) * mapHeight
        return pixelX, pixelY
    end
    
    return nil, nil
end

function FlightLocations.UI.MapOverlay:SetupIconInteraction(icon, point)
    -- Tooltip on hover
    if FlightLocationsDB.showTooltips then
        icon:SetScript("OnEnter", function()
            self:ShowFlightPointTooltip(icon, point)
        end)
        
        icon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
    
    -- Click handling
    icon:SetScript("OnClick", function()
        self:OnFlightPointClick(point)
    end)
    
    -- Enable mouse interaction
    icon:EnableMouse(true)
end

function FlightLocations.UI.MapOverlay:ShowFlightPointTooltip(icon, point)
    GameTooltip:SetOwner(icon, "ANCHOR_RIGHT")
    
    local isDiscovered = FlightLocations.Database:IsFlightPointDiscovered(point)
    local title = point.name
    
    if isDiscovered then
        GameTooltip:SetText(title, 0, 1, 0) -- Green for discovered
    else
        GameTooltip:SetText(title .. " (Undiscovered)", 1, 0.5, 0) -- Orange for undiscovered
    end
    
    -- Add zone information
    GameTooltip:AddLine("Zone: " .. point.zone, 1, 1, 1)
    
    -- Add faction information with color
    local factionR, factionG, factionB = 1, 1, 1
    if point.faction == "Alliance" then
        factionR, factionG, factionB = 0.3, 0.5, 1
    elseif point.faction == "Horde" then
        factionR, factionG, factionB = 1, 0.2, 0.2
    elseif point.faction == "Neutral" then
        factionR, factionG, factionB = 1, 1, 0.5
    end
    GameTooltip:AddLine("Faction: " .. point.faction, factionR, factionG, factionB)
    
    -- Add coordinates
    GameTooltip:AddLine(string.format("Location: %.1f, %.1f", point.x, point.y), 0.7, 0.7, 0.7)
    
    -- Add usage hints
    if isDiscovered then
        GameTooltip:AddLine(" ", 1, 1, 1) -- Blank line
        GameTooltip:AddLine("Click: Show info", 0.5, 1, 0.5)
        GameTooltip:AddLine("Shift+Click: Link in chat", 0.5, 1, 0.5)
    else
        GameTooltip:AddLine(" ", 1, 1, 1) -- Blank line
        GameTooltip:AddLine("Visit this location to discover", 1, 0.8, 0.5)
    end
    
    GameTooltip:Show()
end

function FlightLocations.UI.MapOverlay:OnFlightPointClick(point)
    if IsShiftKeyDown() then
        -- Shift+click to link in chat
        local chatType = "SAY"
        if GetNumRaidMembers() > 0 then
            chatType = "RAID"
        elseif GetNumPartyMembers() > 0 then
            chatType = "PARTY"
        end
        
        local message = string.format("Flight Point: %s in %s (%.1f, %.1f)", 
                                    point.name, point.zone, point.x, point.y)
        SendChatMessage(message, chatType)
    else
        -- Normal click - show information
        local isDiscovered = FlightLocations.Database:IsFlightPointDiscovered(point)
        local status = isDiscovered and "Discovered" or "Undiscovered"
        FlightLocations:Print(string.format("%s - %s (%s)", point.name, point.zone, status))
    end
end

function FlightLocations.UI.MapOverlay:ClearOverlay()
    -- Return all active icons to the pool
    for i, icon in ipairs(activeIcons) do
        self:ReturnIconToPool(icon)
    end
    activeIcons = {}
end

-- Public interface
function FlightLocations.UI.MapOverlay:Refresh()
    if WorldMapFrame and WorldMapFrame:IsVisible() then
        self:UpdateOverlay()
    end
end

function FlightLocations.UI.MapOverlay:SetIconSize(size)
    FlightLocationsDB.iconSize = size
    self:Refresh()
end

function FlightLocations.UI.MapOverlay:SetIconAlpha(alpha)
    FlightLocationsDB.iconAlpha = alpha
    self:Refresh()
end
