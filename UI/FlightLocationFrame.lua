-- Flight Location Frame UI
-- Provides a comprehensive configuration interface for the addon

FlightLocations.UI = FlightLocations.UI or {}

local FRAME_WIDTH = 500
local FRAME_HEIGHT = 450

function FlightLocations.UI:CreateConfigFrame()
    if self.configFrame then
        return self.configFrame
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "FlightLocationsConfigFrame", UIParent)
    frame:SetWidth(FRAME_WIDTH)
    frame:SetHeight(FRAME_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.95)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:SetScript("OnShow", function() PlaySound("INTERFACESOUND_CHARWINDOWOPEN") end)
    frame:SetScript("OnHide", function() PlaySound("INTERFACESOUND_CHARWINDOWCLOSE") end)
    frame:Hide()
    
    -- Title bar
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 11, -12)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -11, -12)
    titleBar:SetHeight(25)
    titleBar:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    titleBar:SetBackdropColor(0.2, 0.5, 0.8, 0.8)
    
    -- Title text
    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("CENTER", titleBar, "CENTER")
    title:SetText("Flight Locations Configuration")
    title:SetTextColor(1, 1, 1)
    
    -- Version info
    local version = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    version:SetPoint("RIGHT", titleBar, "RIGHT", -10, 0)
    version:SetText("v" .. (FlightLocations.version or "1.0.0"))
    version:SetTextColor(0.8, 0.8, 0.8)
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeButton:SetScript("OnClick", function() frame:Hide() end)
    
    -- Tab system
    local tabs = {}
    local tabContent = {}
    
    -- Create tab buttons
    local function CreateTab(name, text, index)
        local tab = CreateFrame("Button", "FlightLocationsTab" .. index, frame)
        tab:SetSize(100, 25)
        tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 20 + (index - 1) * 105, -45)
        tab:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        
        local tabText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tabText:SetPoint("CENTER")
        tabText:SetText(text)
        
        tab.name = name
        tab.text = tabText
        tab.index = index
        
        tab:SetScript("OnClick", function()
            self:ShowTab(frame, name)
        end)
        
        tab:SetScript("OnEnter", function()
            if tab.name ~= frame.activeTab then
                tab:SetBackdropColor(0.3, 0.3, 0.3, 0.8)
            end
        end)
        
        tab:SetScript("OnLeave", function()
            if tab.name ~= frame.activeTab then
                tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
            end
        end)
        
        tabs[name] = tab
        return tab
    end
    
    -- Create tabs
    CreateTab("display", "Display", 1)
    CreateTab("filtering", "Filtering", 2)
    CreateTab("advanced", "Advanced", 3)
    CreateTab("about", "About", 4)
    
    -- Content area
    local contentFrame = CreateFrame("ScrollFrame", "FlightLocationsConfigContent", frame, "UIPanelScrollFrameTemplate")
    contentFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -80)
    contentFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -40, 50)
    
    local scrollChild = CreateFrame("Frame", nil, contentFrame)
    scrollChild:SetSize(contentFrame:GetWidth(), 1000)
    contentFrame:SetScrollChild(scrollChild)
    
    frame.contentFrame = contentFrame
    frame.scrollChild = scrollChild
    frame.tabs = tabs
    frame.tabContent = tabContent
    
    -- Create tab content
    self:CreateDisplayTab(frame)
    self:CreateFilteringTab(frame)
    self:CreateAdvancedTab(frame)
    self:CreateAboutTab(frame)
    
    -- Bottom buttons
    local buttonFrame = CreateFrame("Frame", nil, frame)
    buttonFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 15)
    buttonFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 15)
    buttonFrame:SetHeight(30)
    
    -- Reset button
    local resetButton = CreateFrame("Button", "FlightLocationsResetButton", buttonFrame, "UIPanelButtonTemplate")
    resetButton:SetSize(80, 25)
    resetButton:SetPoint("LEFT", buttonFrame, "LEFT")
    resetButton:SetText("Reset")
    resetButton:SetScript("OnClick", function()
        self:ResetSettings()
        self:RefreshConfigFrame()
        FlightLocations:Print("Settings reset to defaults")
    end)
    
    -- Apply button
    local applyButton = CreateFrame("Button", "FlightLocationsApplyButton", buttonFrame, "UIPanelButtonTemplate")
    applyButton:SetSize(80, 25)
    applyButton:SetPoint("RIGHT", buttonFrame, "RIGHT", -90, 0)
    applyButton:SetText("Apply")
    applyButton:SetScript("OnClick", function()
        self:ApplySettings()
        FlightLocations:Print("Settings applied")
    end)
    
    -- Close button
    local closeButtonBottom = CreateFrame("Button", "FlightLocationsCloseButton", buttonFrame, "UIPanelButtonTemplate")
    closeButtonBottom:SetSize(80, 25)
    closeButtonBottom:SetPoint("RIGHT", buttonFrame, "RIGHT")
    closeButtonBottom:SetText("Close")
    closeButtonBottom:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    -- Initialize with first tab
    self:ShowTab(frame, "display")
    
    self.configFrame = frame
    return frame
end
-- Tab system functions
function FlightLocations.UI:ShowTab(frame, tabName)
    -- Hide all tab content
    for name, content in pairs(frame.tabContent) do
        content:Hide()
    end
    
    -- Reset all tab appearances
    for name, tab in pairs(frame.tabs) do
        if name == tabName then
            tab:SetBackdropColor(0.2, 0.5, 0.8, 0.8)
            tab.text:SetTextColor(1, 1, 1)
        else
            tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
            tab.text:SetTextColor(0.7, 0.7, 0.7)
        end
    end
    
    -- Show selected tab content
    if frame.tabContent[tabName] then
        frame.tabContent[tabName]:Show()
    end
    
    frame.activeTab = tabName
end

-- Create Display tab content
function FlightLocations.UI:CreateDisplayTab(frame)
    local content = CreateFrame("Frame", nil, frame.scrollChild)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content:SetHeight(300)
    content:Hide()
    
    local yOffset = 0
    
    -- Section: Visibility Options
    local visibilityHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    visibilityHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    visibilityHeader:SetText("Visibility Options")
    visibilityHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Show discovered checkbox
    local discoveredCheck = CreateFrame("CheckButton", "FlightLocationsDiscoveredCheck", content, "UICheckButtonTemplate")
    discoveredCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(discoveredCheck:GetName() .. "Text"):SetText("Show discovered flight points")
    discoveredCheck:SetChecked(FlightLocationsDB.showDiscovered)
    discoveredCheck:SetScript("OnClick", function()
        FlightLocationsDB.showDiscovered = discoveredCheck:GetChecked()
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    yOffset = yOffset - 25
    
    -- Show undiscovered checkbox
    local undiscoveredCheck = CreateFrame("CheckButton", "FlightLocationsUndiscoveredCheck", content, "UICheckButtonTemplate")
    undiscoveredCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(undiscoveredCheck:GetName() .. "Text"):SetText("Show undiscovered flight points")
    undiscoveredCheck:SetChecked(FlightLocationsDB.showUndiscovered)
    undiscoveredCheck:SetScript("OnClick", function()
        FlightLocationsDB.showUndiscovered = undiscoveredCheck:GetChecked()
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    yOffset = yOffset - 25
    
    -- Show tooltips checkbox
    local tooltipsCheck = CreateFrame("CheckButton", "FlightLocationsTooltipsCheck", content, "UICheckButtonTemplate")
    tooltipsCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(tooltipsCheck:GetName() .. "Text"):SetText("Show detailed tooltips")
    tooltipsCheck:SetChecked(FlightLocationsDB.showTooltips)
    tooltipsCheck:SetScript("OnClick", function()
        FlightLocationsDB.showTooltips = tooltipsCheck:GetChecked()
    end)
    yOffset = yOffset - 35
    
    -- Section: Map Integration
    local mapHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    mapHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    mapHeader:SetText("Map Integration")
    mapHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- World map checkbox
    local worldMapCheck = CreateFrame("CheckButton", "FlightLocationsWorldMapCheck", content, "UICheckButtonTemplate")
    worldMapCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(worldMapCheck:GetName() .. "Text"):SetText("Show icons on world map")
    worldMapCheck:SetChecked(FlightLocationsDB.enableWorldMap)
    worldMapCheck:SetScript("OnClick", function()
        FlightLocationsDB.enableWorldMap = worldMapCheck:GetChecked()
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    yOffset = yOffset - 35
    
    -- Section: Icon Appearance
    local iconHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    iconHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    iconHeader:SetText("Icon Appearance")
    iconHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Icon size slider
    local iconSizeLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconSizeLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    iconSizeLabel:SetText("Icon Size: " .. (FlightLocationsDB.iconSize or 16))
    yOffset = yOffset - 20
    
    local iconSizeSlider = CreateFrame("Slider", "FlightLocationsIconSizeSlider", content, "OptionsSliderTemplate")
    iconSizeSlider:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    iconSizeSlider:SetWidth(200)
    iconSizeSlider:SetMinMaxValues(8, 32)
    iconSizeSlider:SetValue(FlightLocationsDB.iconSize or 16)
    iconSizeSlider:SetValueStep(2)
    getglobal(iconSizeSlider:GetName() .. "Low"):SetText("8")
    getglobal(iconSizeSlider:GetName() .. "High"):SetText("32")
    iconSizeSlider:SetScript("OnValueChanged", function()
        local value = iconSizeSlider:GetValue()
        FlightLocationsDB.iconSize = value
        iconSizeLabel:SetText("Icon Size: " .. value)
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    yOffset = yOffset - 40
    
    -- Icon alpha slider
    local iconAlphaLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    iconAlphaLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    iconAlphaLabel:SetText("Icon Opacity: " .. string.format("%.0f%%", (FlightLocationsDB.iconAlpha or 0.8) * 100))
    yOffset = yOffset - 20
    
    local iconAlphaSlider = CreateFrame("Slider", "FlightLocationsIconAlphaSlider", content, "OptionsSliderTemplate")
    iconAlphaSlider:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    iconAlphaSlider:SetWidth(200)
    iconAlphaSlider:SetMinMaxValues(0.1, 1.0)
    iconAlphaSlider:SetValue(FlightLocationsDB.iconAlpha or 0.8)
    iconAlphaSlider:SetValueStep(0.1)
    getglobal(iconAlphaSlider:GetName() .. "Low"):SetText("10%")
    getglobal(iconAlphaSlider:GetName() .. "High"):SetText("100%")
    iconAlphaSlider:SetScript("OnValueChanged", function()
        local value = iconAlphaSlider:GetValue()
        FlightLocationsDB.iconAlpha = value
        iconAlphaLabel:SetText("Icon Opacity: " .. string.format("%.0f%%", value * 100))
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    
    frame.tabContent["display"] = content
end

-- Create Filtering tab content
function FlightLocations.UI:CreateFilteringTab(frame)
    local content = CreateFrame("Frame", nil, frame.scrollChild)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content:SetHeight(300)
    content:Hide()
    
    local yOffset = 0
    
    -- Section: Faction Filtering
    local factionHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    factionHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    factionHeader:SetText("Faction Filtering")
    factionHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Filter by faction checkbox
    local factionCheck = CreateFrame("CheckButton", "FlightLocationsFactionCheck", content, "UICheckButtonTemplate")
    factionCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(factionCheck:GetName() .. "Text"):SetText("Only show flight points for my faction")
    factionCheck:SetChecked(FlightLocationsDB.filterByFaction)
    factionCheck:SetScript("OnClick", function()
        FlightLocationsDB.filterByFaction = factionCheck:GetChecked()
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    end)
    yOffset = yOffset - 30
    
    -- Faction info
    local factionInfo = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    factionInfo:SetPoint("TOPLEFT", content, "TOPLEFT", 40, yOffset)
    factionInfo:SetWidth(300)
    factionInfo:SetJustifyH("LEFT")
    factionInfo:SetText("When enabled, only flight points usable by your faction will be displayed. Neutral flight points are always shown.")
    factionInfo:SetTextColor(0.8, 0.8, 0.8)
    yOffset = yOffset - 50
    
    -- Section: Discovery Status
    local discoveryHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    discoveryHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    discoveryHeader:SetText("Discovery Status")
    discoveryHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Discovery filter info
    local discoveryInfo = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    discoveryInfo:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    discoveryInfo:SetWidth(350)
    discoveryInfo:SetJustifyH("LEFT")
    discoveryInfo:SetText("Flight points are automatically marked as discovered when you visit a flight master and open the taxi map.")
    discoveryInfo:SetTextColor(0.9, 0.9, 0.9)
    yOffset = yOffset - 40
    
    -- Clear discovered data button
    local clearButton = CreateFrame("Button", "FlightLocationsClearButton", content, "UIPanelButtonTemplate")
    clearButton:SetSize(150, 25)
    clearButton:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    clearButton:SetText("Clear Discovery Data")
    clearButton:SetScript("OnClick", function()
        self:ShowConfirmDialog("This will clear all discovered flight point data. Are you sure?", function()
            if FlightLocationsDB.discoveredFlightPoints then
                FlightLocationsDB.discoveredFlightPoints = {}
                if FlightLocations.MapIntegration then
                    FlightLocations.MapIntegration:UpdateMapOverlay()
                end
                FlightLocations:Print("Discovery data cleared")
            end
        end)
    end)
    
    frame.tabContent["filtering"] = content
end

-- Create Advanced tab content
function FlightLocations.UI:CreateAdvancedTab(frame)
    local content = CreateFrame("Frame", nil, frame.scrollChild)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content:SetHeight(300)
    content:Hide()
    
    local yOffset = 0
    
    -- Section: Debug Options
    local debugHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    debugHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    debugHeader:SetText("Debug Options")
    debugHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Debug mode checkbox
    local debugCheck = CreateFrame("CheckButton", "FlightLocationsDebugCheck", content, "UICheckButtonTemplate")
    debugCheck:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    getglobal(debugCheck:GetName() .. "Text"):SetText("Enable debug mode")
    debugCheck:SetChecked(FlightLocationsDB.debugMode)
    debugCheck:SetScript("OnClick", function()
        FlightLocationsDB.debugMode = debugCheck:GetChecked()
        FlightLocations:Print("Debug mode " .. (FlightLocationsDB.debugMode and "enabled" or "disabled"))
    end)
    yOffset = yOffset - 30
    
    -- Debug info
    local debugInfo = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    debugInfo:SetPoint("TOPLEFT", content, "TOPLEFT", 40, yOffset)
    debugInfo:SetWidth(300)
    debugInfo:SetJustifyH("LEFT")
    debugInfo:SetText("Shows additional information in chat about addon operations.")
    debugInfo:SetTextColor(0.8, 0.8, 0.8)
    yOffset = yOffset - 40
    
    -- Section: Performance
    local perfHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    perfHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    perfHeader:SetText("Performance")
    perfHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Refresh rate info
    local refreshInfo = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    refreshInfo:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    refreshInfo:SetWidth(350)
    refreshInfo:SetJustifyH("LEFT")
    refreshInfo:SetText("The addon automatically updates when you change zones or open the world map. Manual refresh is rarely needed.")
    refreshInfo:SetTextColor(0.9, 0.9, 0.9)
    yOffset = yOffset - 40
    
    -- Manual refresh button
    local refreshButton = CreateFrame("Button", "FlightLocationsRefreshButton", content, "UIPanelButtonTemplate")
    refreshButton:SetSize(120, 25)
    refreshButton:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    refreshButton:SetText("Refresh Map")
    refreshButton:SetScript("OnClick", function()
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
            FlightLocations:Print("Map refreshed")
        end
    end)
    yOffset = yOffset - 35
    
    -- Section: Data Management
    local dataHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    dataHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    dataHeader:SetText("Data Management")
    dataHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 30
    
    -- Export settings button (placeholder for future feature)
    local exportButton = CreateFrame("Button", "FlightLocationsExportButton", content, "UIPanelButtonTemplate")
    exportButton:SetSize(120, 25)
    exportButton:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
    exportButton:SetText("Export Settings")
    exportButton:SetScript("OnClick", function()
        FlightLocations:Print("Feature coming soon!")
    end)
    exportButton:Disable()
    
    frame.tabContent["advanced"] = content
end

-- Create About tab content
function FlightLocations.UI:CreateAboutTab(frame)
    local content = CreateFrame("Frame", nil, frame.scrollChild)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content:SetHeight(300)
    content:Hide()
    
    local yOffset = 0
    
    -- Addon info
    local addonName = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    addonName:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    addonName:SetText("Flight Locations")
    addonName:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 25
    
    local versionText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    versionText:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    versionText:SetText("Version: " .. (FlightLocations.version or "1.0.0"))
    versionText:SetTextColor(0.9, 0.9, 0.9)
    yOffset = yOffset - 20
    
    local authorText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    authorText:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    authorText:SetText("Author: " .. (FlightLocations.author or "IAmCainey"))
    authorText:SetTextColor(0.9, 0.9, 0.9)
    yOffset = yOffset - 30
    
    -- Description
    local description = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    description:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    description:SetWidth(400)
    description:SetJustifyH("LEFT")
    description:SetText("Shows all flight locations on the world map, both discovered and undiscovered. Specifically designed for Turtle WoW with complete Vanilla flight point database.")
    description:SetTextColor(0.9, 0.9, 0.9)
    yOffset = yOffset - 60
    
    -- Features
    local featuresHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    featuresHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    featuresHeader:SetText("Features")
    featuresHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 25
    
    local features = {
        "• Complete database of all Vanilla WoW flight points",
        "• Automatic discovery tracking",
        "• Faction-specific filtering",
        "• Customizable icon appearance",
        "• Detailed tooltips with coordinates",
        "• Chat integration for sharing locations"
    }
    
    for i, feature in ipairs(features) do
        local featureText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        featureText:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
        featureText:SetText(feature)
        featureText:SetTextColor(0.8, 0.8, 0.8)
        yOffset = yOffset - 15
    end
    
    yOffset = yOffset - 10
    
    -- Commands
    local commandsHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    commandsHeader:SetPoint("TOPLEFT", content, "TOPLEFT", 0, yOffset)
    commandsHeader:SetText("Slash Commands")
    commandsHeader:SetTextColor(0.2, 0.8, 1)
    yOffset = yOffset - 25
    
    local commands = {
        "/fl config - Open this configuration window",
        "/fl stats - Show discovery statistics", 
        "/fl version - Show version information",
        "/fl test - Test addon components"
    }
    
    for i, command in ipairs(commands) do
        local commandText = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        commandText:SetPoint("TOPLEFT", content, "TOPLEFT", 20, yOffset)
        commandText:SetText(command)
        commandText:SetTextColor(0.8, 0.8, 0.8)
        commandText:SetFont("Fonts\\ARIALN.TTF", 11, "MONOCHROME")
        yOffset = yOffset - 15
    end
    
    frame.tabContent["about"] = content
end

-- Utility functions for the configuration UI
function FlightLocations.UI:ResetSettings()
    -- Reset to default values
    local defaults = {
        showUndiscovered = true,
        showDiscovered = true,
        iconSize = 16,
        showTooltips = true,
        enableWorldMap = true,
        enableMinimap = false,
        iconAlpha = 0.8,
        filterByFaction = true,
        debugMode = false
    }
    
    for key, value in pairs(defaults) do
        FlightLocationsDB[key] = value
    end
    
    -- Update map display
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end
end

function FlightLocations.UI:ApplySettings()
    -- Refresh map overlay with current settings
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end
end

function FlightLocations.UI:RefreshConfigFrame()
    if not self.configFrame then return end
    
    local frame = self.configFrame
    
    -- Refresh all checkboxes and sliders to current values
    local discoveredCheck = getglobal("FlightLocationsDiscoveredCheck")
    if discoveredCheck then
        discoveredCheck:SetChecked(FlightLocationsDB.showDiscovered)
    end
    
    local undiscoveredCheck = getglobal("FlightLocationsUndiscoveredCheck")
    if undiscoveredCheck then
        undiscoveredCheck:SetChecked(FlightLocationsDB.showUndiscovered)
    end
    
    local tooltipsCheck = getglobal("FlightLocationsTooltipsCheck")
    if tooltipsCheck then
        tooltipsCheck:SetChecked(FlightLocationsDB.showTooltips)
    end
    
    local worldMapCheck = getglobal("FlightLocationsWorldMapCheck")
    if worldMapCheck then
        worldMapCheck:SetChecked(FlightLocationsDB.enableWorldMap)
    end
    
    local factionCheck = getglobal("FlightLocationsFactionCheck")
    if factionCheck then
        factionCheck:SetChecked(FlightLocationsDB.filterByFaction)
    end
    
    local debugCheck = getglobal("FlightLocationsDebugCheck")
    if debugCheck then
        debugCheck:SetChecked(FlightLocationsDB.debugMode)
    end
    
    local iconSizeSlider = getglobal("FlightLocationsIconSizeSlider")
    if iconSizeSlider then
        iconSizeSlider:SetValue(FlightLocationsDB.iconSize or 16)
    end
    
    local iconAlphaSlider = getglobal("FlightLocationsIconAlphaSlider")
    if iconAlphaSlider then
        iconAlphaSlider:SetValue(FlightLocationsDB.iconAlpha or 0.8)
    end
end

function FlightLocations.UI:ShowConfirmDialog(message, confirmCallback)
    -- Create a simple confirmation dialog
    local dialog = CreateFrame("Frame", "FlightLocationsConfirmDialog", UIParent)
    dialog:SetSize(300, 120)
    dialog:SetPoint("CENTER")
    dialog:SetFrameStrata("FULLSCREEN_DIALOG")
    dialog:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    dialog:SetBackdropColor(0, 0, 0, 1)
    dialog:EnableMouse(true)
    
    -- Message text
    local text = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOP", dialog, "TOP", 0, -20)
    text:SetWidth(250)
    text:SetJustifyH("CENTER")
    text:SetText(message)
    
    -- Yes button
    local yesButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
    yesButton:SetSize(60, 25)
    yesButton:SetPoint("BOTTOMLEFT", dialog, "BOTTOMLEFT", 60, 15)
    yesButton:SetText("Yes")
    yesButton:SetScript("OnClick", function()
        dialog:Hide()
        if confirmCallback then
            confirmCallback()
        end
    end)
    
    -- No button
    local noButton = CreateFrame("Button", nil, dialog, "UIPanelButtonTemplate")
    noButton:SetSize(60, 25)
    noButton:SetPoint("BOTTOMRIGHT", dialog, "BOTTOMRIGHT", -60, 15)
    noButton:SetText("No")
    noButton:SetScript("OnClick", function()
        dialog:Hide()
    end)
    
    dialog:Show()
end

-- Initialize the UI system
function FlightLocations.UI:Initialize()
    -- This will be called from the main addon file
    self.initialized = true
end

-- Show/Hide configuration frame
function FlightLocations.UI:ToggleConfigFrame()
    if not self.configFrame then
        self:CreateConfigFrame()
    end
    
    if self.configFrame:IsShown() then
        self.configFrame:Hide()
    else
        self:RefreshConfigFrame()
        self.configFrame:Show()
    end
end
    
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
