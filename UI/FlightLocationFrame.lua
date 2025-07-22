-- Flight Location Frame UI
-- Provides a configuration interface for the addon

FlightLocations.UI = FlightLocations.UI or {}

local FRAME_WIDTH = 400
local FRAME_HEIGHT = 300

function FlightLocations.UI:CreateConfigFrame()
    if self.configFrame then
        return self.configFrame
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "FlightLocationsConfigFrame", UIParent)
    frame:SetWidth(FRAME_WIDTH)
    frame:SetHeight(FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("Flight Locations Configuration")
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeButton:SetScript("OnClick", function() frame:Hide() end)
    
    -- Content area
    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 20)
    
    local yOffset = 0
    
    -- Show discovered flight points checkbox
    local discoveredCheck = CreateFrame("CheckButton", "FlightLocationsDiscoveredCheck", content, "UICheckButtonTemplate")
    discoveredCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    getglobal(discoveredCheck:GetName() .. "Text"):SetText("Show discovered flight points")
    discoveredCheck:SetChecked(FlightLocationsDB.showDiscovered)
    discoveredCheck:SetScript("OnClick", function()
        FlightLocationsDB.showDiscovered = discoveredCheck:GetChecked()
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 30
    
    -- Show undiscovered flight points checkbox
    local undiscoveredCheck = CreateFrame("CheckButton", "FlightLocationsUndiscoveredCheck", content, "UICheckButtonTemplate")
    undiscoveredCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    getglobal(undiscoveredCheck:GetName() .. "Text"):SetText("Show undiscovered flight points")
    undiscoveredCheck:SetChecked(FlightLocationsDB.showUndiscovered)
    undiscoveredCheck:SetScript("OnClick", function()
        FlightLocationsDB.showUndiscovered = undiscoveredCheck:GetChecked()
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 30
    
    -- Show tooltips checkbox
    local tooltipsCheck = CreateFrame("CheckButton", "FlightLocationsTooltipsCheck", content, "UICheckButtonTemplate")
    tooltipsCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    getglobal(tooltipsCheck:GetName() .. "Text"):SetText("Show tooltips")
    tooltipsCheck:SetChecked(FlightLocationsDB.showTooltips)
    tooltipsCheck:SetScript("OnClick", function()
        FlightLocationsDB.showTooltips = tooltipsCheck:GetChecked()
    end)
    yOffset = yOffset - 30
    
    -- Filter by faction checkbox
    local factionCheck = CreateFrame("CheckButton", "FlightLocationsFactionCheck", content, "UICheckButtonTemplate")
    factionCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    getglobal(factionCheck:GetName() .. "Text"):SetText("Filter by faction")
    factionCheck:SetChecked(FlightLocationsDB.filterByFaction)
    factionCheck:SetScript("OnClick", function()
        FlightLocationsDB.filterByFaction = factionCheck:GetChecked()
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 30
    
    -- Enable world map checkbox
    local worldMapCheck = CreateFrame("CheckButton", "FlightLocationsWorldMapCheck", content, "UICheckButtonTemplate")
    worldMapCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    getglobal(worldMapCheck:GetName() .. "Text"):SetText("Show on world map")
    worldMapCheck:SetChecked(FlightLocationsDB.enableWorldMap)
    worldMapCheck:SetScript("OnClick", function()
        FlightLocationsDB.enableWorldMap = worldMapCheck:GetChecked()
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 30
    
    -- Icon size slider
    local iconSizeLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconSizeLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    iconSizeLabel:SetText("Icon Size: " .. (FlightLocationsDB.iconSize or 16))
    yOffset = yOffset - 20
    
    local iconSizeSlider = CreateFrame("Slider", "FlightLocationsIconSizeSlider", content, "OptionsSliderTemplate")
    iconSizeSlider:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    iconSizeSlider:SetMinMaxValues(8, 32)
    iconSizeSlider:SetValue(FlightLocationsDB.iconSize or 16)
    iconSizeSlider:SetValueStep(2)
    getglobal(iconSizeSlider:GetName() .. "Low"):SetText("8")
    getglobal(iconSizeSlider:GetName() .. "High"):SetText("32")
    iconSizeSlider:SetScript("OnValueChanged", function()
        local value = iconSizeSlider:GetValue()
        FlightLocationsDB.iconSize = value
        iconSizeLabel:SetText("Icon Size: " .. value)
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 40
    
    -- Icon alpha slider
    local iconAlphaLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconAlphaLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    iconAlphaLabel:SetText("Icon Transparency: " .. string.format("%.1f", FlightLocationsDB.iconAlpha or 0.8))
    yOffset = yOffset - 20
    
    local iconAlphaSlider = CreateFrame("Slider", "FlightLocationsIconAlphaSlider", content, "OptionsSliderTemplate")
    iconAlphaSlider:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    iconAlphaSlider:SetMinMaxValues(0.1, 1.0)
    iconAlphaSlider:SetValue(FlightLocationsDB.iconAlpha or 0.8)
    iconAlphaSlider:SetValueStep(0.1)
    getglobal(iconAlphaSlider:GetName() .. "Low"):SetText("0.1")
    getglobal(iconAlphaSlider:GetName() .. "High"):SetText("1.0")
    iconAlphaSlider:SetScript("OnValueChanged", function()
        local value = iconAlphaSlider:GetValue()
        FlightLocationsDB.iconAlpha = value
        iconAlphaLabel:SetText("Icon Transparency: " .. string.format("%.1f", value))
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end)
    yOffset = yOffset - 40
    
    self.configFrame = frame
    return frame
end

function FlightLocations.UI:ShowConfigFrame()
    if not self.configFrame then
        self:CreateConfigFrame()
    end
    
    self.configFrame:Show()
end

function FlightLocations.UI:HideConfigFrame()
    if self.configFrame then
        self.configFrame:Hide()
    end
end

function FlightLocations.UI:ToggleConfigFrame()
    if not self.configFrame then
        self:CreateConfigFrame()
    end
    
    if self.configFrame:IsVisible() then
        self.configFrame:Hide()
    else
        self.configFrame:Show()
    end
end

-- Create a simple stats frame
function FlightLocations.UI:CreateStatsFrame()
    if self.statsFrame then
        return self.statsFrame
    end
    
    local frame = CreateFrame("Frame", "FlightLocationsStatsFrame", UIParent)
    frame:SetWidth(300)
    frame:SetHeight(200)
    frame:SetPoint("CENTER", 100, 0)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("Flight Point Statistics")
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeButton:SetScript("OnClick", function() frame:Hide() end)
    
    -- Stats content
    local content = CreateFrame("ScrollFrame", nil, frame)
    content:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 20)
    
    local text = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    
    frame.text = text
    frame.UpdateStats = function()
        FlightLocations.UI:UpdateStatsDisplay(text)
    end
    
    self.statsFrame = frame
    return frame
end

function FlightLocations.UI:UpdateStatsDisplay(textFrame)
    if not FlightLocations.Database then
        textFrame:SetText("Database not loaded")
        return
    end
    
    local allPoints = FlightLocations.Database:GetAllFlightPoints()
    local discovered = 0
    local undiscovered = 0
    local alliance = 0
    local horde = 0
    local neutral = 0
    
    for i, point in ipairs(allPoints) do
        if FlightLocations.Database:IsFlightPointDiscovered(point) then
            discovered = discovered + 1
        else
            undiscovered = undiscovered + 1
        end
        
        if point.faction == "Alliance" then
            alliance = alliance + 1
        elseif point.faction == "Horde" then
            horde = horde + 1
        else
            neutral = neutral + 1
        end
    end
    
    local statsText = string.format(
        "Total Flight Points: %d\n\n" ..
        "Discovered: %d\n" ..
        "Undiscovered: %d\n\n" ..
        "By Faction:\n" ..
        "Alliance: %d\n" ..
        "Horde: %d\n" ..
        "Neutral: %d\n\n" ..
        "Discovery Rate: %.1f%%",
        table.getn(allPoints),
        discovered,
        undiscovered,
        alliance,
        horde,
        neutral,
        (discovered / table.getn(allPoints)) * 100
    )
    
    textFrame:SetText(statsText)
end

function FlightLocations.UI:ShowStatsFrame()
    if not self.statsFrame then
        self:CreateStatsFrame()
    end
    
    self.statsFrame.UpdateStats()
    self.statsFrame:Show()
end
