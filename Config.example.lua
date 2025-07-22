-- Example configuration for Flight Locations addon
-- This file shows how to customize the addon's behavior

-- To use this configuration, copy the desired settings to your character's 
-- saved variables or modify them through the in-game configuration panel

local exampleConfig = {
    -- Display Options
    showDiscovered = true,          -- Show flight points you've discovered
    showUndiscovered = true,        -- Show flight points you haven't found yet
    showTooltips = true,           -- Show informational tooltips
    filterByFaction = true,        -- Only show flight points for your faction
    
    -- Map Integration
    enableWorldMap = true,         -- Show icons on the world map
    enableMinimap = false,         -- Show icons on the minimap (not recommended)
    
    -- Visual Settings
    iconSize = 16,                 -- Size of flight point icons (8-32)
    iconAlpha = 0.8,              -- Transparency of icons (0.1-1.0)
    
    -- Advanced Options
    debugMode = false,             -- Enable debug messages
    
    -- Per-character discovered flight points (automatically managed)
    discoveredFlightPoints = {
        -- Format: ["PlayerName-RealmName"] = {
        --     { name = "Flight Master", zone = "Zone Name", discoveredTime = timestamp },
        --     ...
        -- }
    }
}

-- Color scheme examples for different icon types
local iconColors = {
    alliance = {r = 0.3, g = 0.5, b = 1.0},      -- Blue
    horde = {r = 1.0, g = 0.2, b = 0.2},         -- Red  
    neutral = {r = 1.0, g = 1.0, b = 0.5},       -- Yellow
    undiscovered = {r = 0.5, g = 0.5, b = 0.5}   -- Gray
}

-- Example of adding custom Turtle WoW flight points
local customFlightPoints = {
    -- Add custom flight points specific to Turtle WoW here
    -- These would be discovered through gameplay or community research
    
    -- Example format:
    -- {
    --     name = "Custom Flight Master",
    --     zone = "Custom Zone",
    --     continent = 1, -- 1 for Kalimdor, 2 for Eastern Kingdoms
    --     x = 50.0,      -- X coordinate (0-100)
    --     y = 50.0,      -- Y coordinate (0-100)
    --     faction = "Neutral", -- "Alliance", "Horde", or "Neutral"
    --     npcId = 12345  -- NPC ID if known
    -- }
}

-- Keybinding examples (these would need to be set through the game's key binding interface)
local keyBindings = {
    -- BINDING_HEADER_FLIGHTLOCATIONS = "Flight Locations"
    -- BINDING_NAME_TOGGLE_WORLDMAP_ICONS = "Toggle World Map Icons"
    -- BINDING_NAME_TOGGLE_DISCOVERED = "Toggle Discovered Flight Points"
    -- BINDING_NAME_OPEN_CONFIG = "Open Configuration"
}
