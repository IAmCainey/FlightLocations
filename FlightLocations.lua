-- FlightLocations Main Addon File
-- Compatible with World of Warcraft 1.12.1 (Vanilla) and Turtle WoW

-- Addon namespace
FlightLocations = {}

-- Version information
FlightLocations.version = GetAddOnMetadata("FlightLocations", "Version") or "1.0.0"
FlightLocations.name = "FlightLocations"
FlightLocations.author = GetAddOnMetadata("FlightLocations", "Author") or "Unknown"
FlightLocations.interface = GetAddOnMetadata("FlightLocations", "Interface") or "11200"

-- Addon information
FlightLocations.addonInfo = {
    name = FlightLocations.name,
    version = FlightLocations.version,
    author = FlightLocations.author,
    interface = FlightLocations.interface,
    buildDate = "2025-07-22", -- Update this for each release
    buildNumber = 1
}

-- Default settings
local defaults = {
    profile = {
        showUndiscovered = true,
        showDiscovered = true,
        iconSize = 16,
        showTooltips = true,
        enableMinimap = true,
        debugMode = false
    }
}

-- Initialize the addon
function FlightLocations:OnInitialize()
    -- Initialize saved variables
    if not FlightLocationsDB then
        FlightLocationsDB = {}
    end
    
    -- Initialize version tracking
    if not FlightLocationsDB.version then
        FlightLocationsDB.version = self.version
        FlightLocationsDB.firstInstall = time()
    end
    
    -- Handle version upgrades
    if FlightLocationsDB.version ~= self.version then
        if FlightLocations.VersionManager then
            FlightLocations.VersionManager:HandleUpgrade(FlightLocationsDB.version, self.version)
        else
            self:HandleVersionUpgrade(FlightLocationsDB.version, self.version)
        end
        FlightLocationsDB.version = self.version
        FlightLocationsDB.lastUpgrade = time()
    end
    
    -- Merge defaults with saved variables
    for key, value in pairs(defaults.profile) do
        if FlightLocationsDB[key] == nil then
            FlightLocationsDB[key] = value
        end
    end
    
    -- Set up convenience reference
    FlightLocations.db = FlightLocationsDB
    
    -- Initialize components
    if FlightLocations.Core then
        FlightLocations.Core:Initialize()
    end
    
    if FlightLocations.Database then
        FlightLocations.Database:Initialize()
    end
    
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:Initialize()
    end
    
    if FlightLocations.UI and FlightLocations.UI.MapOverlay then
        FlightLocations.UI.MapOverlay:Initialize()
    end
    
    self:Print("Flight Locations v" .. self.version .. " loaded successfully!")
end

-- Handle version upgrades
function FlightLocations:HandleVersionUpgrade(oldVersion, newVersion)
    self:Print("Upgrading from version " .. (oldVersion or "unknown") .. " to " .. newVersion)
    
    -- Version-specific upgrade logic
    if not oldVersion then
        -- First time installation
        self:Print("Welcome to Flight Locations! Use /fl config to customize settings.")
    elseif oldVersion == "1.0.0" and newVersion ~= "1.0.0" then
        -- Future version upgrades would go here
        -- Example: migrate old settings format to new format
    end
    
    -- Clear any cached data that might be outdated
    if FlightLocationsDB.cache then
        FlightLocationsDB.cache = nil
    end
end

-- Version checking utility
function FlightLocations:IsVersionNewer(version1, version2)
    if not version1 or not version2 then
        return false
    end
    
    local v1parts = {}
    local v2parts = {}
    
    for part in string.gmatch(version1, "[^%.]+") do
        table.insert(v1parts, tonumber(part) or 0)
    end
    
    for part in string.gmatch(version2, "[^%.]+") do
        table.insert(v2parts, tonumber(part) or 0)
    end
    
    -- Pad shorter version with zeros
    while table.getn(v1parts) < table.getn(v2parts) do
        table.insert(v1parts, 0)
    end
    while table.getn(v2parts) < table.getn(v1parts) do
        table.insert(v2parts, 0)
    end
    
    for i = 1, table.getn(v1parts) do
        if v1parts[i] < v2parts[i] then
            return true
        elseif v1parts[i] > v2parts[i] then
            return false
        end
    end
    
    return false
end

-- Event handling
function FlightLocations:OnEnable()
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("TAXIMAP_OPENED")
    self:RegisterEvent("TAXIMAP_CLOSED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

function FlightLocations:OnEvent(event, ...)
    if event == "ADDON_LOADED" and arg1 == self.name then
        self:OnInitialize()
    elseif event == "TAXIMAP_OPENED" then
        self:OnTaxiMapOpened()
    elseif event == "TAXIMAP_CLOSED" then
        self:OnTaxiMapClosed()
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:OnPlayerEnteringWorld()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        self:OnZoneChanged()
    end
end

function FlightLocations:OnTaxiMapOpened()
    -- Update discovered flight points when taxi map is opened
    if FlightLocations.Database then
        FlightLocations.Database:UpdateDiscoveredFlightPoints()
    end
end

function FlightLocations:OnTaxiMapClosed()
    -- Handle taxi map closed if needed
end

function FlightLocations:OnPlayerEnteringWorld()
    -- Initialize map overlay when player enters world
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end
end

function FlightLocations:OnZoneChanged()
    -- Update map overlay when zone changes
    if FlightLocations.MapIntegration then
        FlightLocations.MapIntegration:UpdateMapOverlay()
    end
end

-- Utility functions
function FlightLocations:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Flight Locations]|r " .. msg)
end

function FlightLocations:Debug(msg)
    if FlightLocationsDB and FlightLocationsDB.debugMode then
        self:Print("|cffff0000[DEBUG]|r " .. msg)
    end
end

-- Slash command handling
SLASH_FLIGHTLOCATIONS1 = "/flightlocations"
SLASH_FLIGHTLOCATIONS2 = "/fl"

function SlashCmdList.FLIGHTLOCATIONS(msg)
    -- Safety check to ensure addon is initialized
    if not FlightLocationsDB then
        FlightLocations:Print("Addon not yet initialized. Please wait...")
        return
    end
    
    local command = string.lower(msg or "")
    
    if command == "toggle" then
        FlightLocationsDB.enableMinimap = not FlightLocationsDB.enableMinimap
        FlightLocations:Print("Minimap icons " .. (FlightLocationsDB.enableMinimap and "enabled" or "disabled"))
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    elseif command == "undiscovered" then
        FlightLocationsDB.showUndiscovered = not FlightLocationsDB.showUndiscovered
        FlightLocations:Print("Undiscovered flight points " .. (FlightLocationsDB.showUndiscovered and "shown" or "hidden"))
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    elseif command == "discovered" then
        FlightLocationsDB.showDiscovered = not FlightLocationsDB.showDiscovered
        FlightLocations:Print("Discovered flight points " .. (FlightLocationsDB.showDiscovered and "shown" or "hidden"))
        if FlightLocations.MapIntegration then
            FlightLocations.MapIntegration:UpdateMapOverlay()
        end
    elseif command == "debug" then
        FlightLocationsDB.debugMode = not FlightLocationsDB.debugMode
        FlightLocations:Print("Debug mode " .. (FlightLocationsDB.debugMode and "enabled" or "disabled"))
    elseif command == "config" then
        if FlightLocations.UI and FlightLocations.UI.ToggleConfigFrame then
            FlightLocations.UI:ToggleConfigFrame()
        else
            FlightLocations:Print("Configuration UI not available")
        end
    elseif command == "stats" then
        if FlightLocations.UI and FlightLocations.UI.ShowStatsFrame then
            FlightLocations.UI:ShowStatsFrame()
        else
            FlightLocations:Print("Statistics UI not available")
        end
    elseif command == "version" or command == "ver" then
        FlightLocations:Print("Flight Locations v" .. FlightLocations.version)
        FlightLocations:Print("Author: " .. FlightLocations.author)
        FlightLocations:Print("Interface: " .. FlightLocations.interface)
        if FlightLocationsDB.firstInstall then
            FlightLocations:Print("Installed: " .. date("%Y-%m-%d", FlightLocationsDB.firstInstall))
        end
    elseif command == "changelog" then
        if FlightLocations.VersionManager then
            FlightLocations.VersionManager:ShowChangelog(FlightLocations.version)
        else
            FlightLocations:Print("Changelog not available")
        end
    elseif command == "test" then
        -- Test command to verify map integration
        FlightLocations:Print("Testing map integration...")
        if FlightLocations.MapIntegration then
            FlightLocations:Print("MapIntegration module: Available")
            FlightLocations.MapIntegration:UpdateMapOverlay()
        else
            FlightLocations:Print("MapIntegration module: Missing")
        end
        if FlightLocations.UI and FlightLocations.UI.MapOverlay then
            FlightLocations:Print("UI.MapOverlay module: Available")
        else
            FlightLocations:Print("UI.MapOverlay module: Missing")
        end
        if FlightLocations.Database then
            local allPoints = FlightLocations.Database:GetAllFlightPoints()
            FlightLocations:Print("Database: " .. table.getn(allPoints) .. " flight points loaded")
        else
            FlightLocations:Print("Database module: Missing")
        end
    else
        FlightLocations:Print("Flight Locations v" .. FlightLocations.version .. " - Available commands:")
        FlightLocations:Print("/fl toggle - Toggle minimap icons")
        FlightLocations:Print("/fl undiscovered - Toggle undiscovered flight points")
        FlightLocations:Print("/fl discovered - Toggle discovered flight points")
        FlightLocations:Print("/fl config - Open configuration window")
        FlightLocations:Print("/fl stats - Show statistics")
        FlightLocations:Print("/fl version - Show version information")
        FlightLocations:Print("/fl changelog - Show current version changelog")
        FlightLocations:Print("/fl test - Test addon components")
        FlightLocations:Print("/fl debug - Toggle debug mode")
    end
end

-- Register events
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function()
    FlightLocations:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
end)

-- Register the events we need
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("TAXIMAP_OPENED")
frame:RegisterEvent("TAXIMAP_CLOSED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

-- Enable the addon
FlightLocations:OnEnable()
