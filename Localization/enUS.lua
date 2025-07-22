-- English (US) Localization for Flight Locations
-- Default language file

local L = {}

-- Addon Information
L["ADDON_NAME"] = "Flight Locations"
L["ADDON_DESCRIPTION"] = "Shows all flight locations on the map, both discovered and undiscovered"

-- Configuration Interface
L["CONFIG_TITLE"] = "Flight Locations Configuration"
L["CONFIG_SHOW_DISCOVERED"] = "Show discovered flight points"
L["CONFIG_SHOW_UNDISCOVERED"] = "Show undiscovered flight points"
L["CONFIG_SHOW_TOOLTIPS"] = "Show tooltips"
L["CONFIG_FILTER_FACTION"] = "Filter by faction"
L["CONFIG_ENABLE_WORLDMAP"] = "Show on world map"
L["CONFIG_ENABLE_MINIMAP"] = "Show on minimap"
L["CONFIG_ICON_SIZE"] = "Icon Size"
L["CONFIG_ICON_ALPHA"] = "Icon Transparency"

-- Status Messages
L["ADDON_LOADED"] = "Flight Locations v%s loaded successfully!"
L["FLIGHT_POINT_DISCOVERED"] = "Discovered flight point: %s in %s"
L["MINIMAP_TOGGLED"] = "Minimap icons %s"
L["WORLDMAP_TOGGLED"] = "World map icons %s"
L["UNDISCOVERED_TOGGLED"] = "Undiscovered flight points %s"
L["DISCOVERED_TOGGLED"] = "Discovered flight points %s"
L["DEBUG_TOGGLED"] = "Debug mode %s"
L["ENABLED"] = "enabled"
L["DISABLED"] = "disabled"
L["SHOWN"] = "shown"
L["HIDDEN"] = "hidden"

-- Tooltip Text
L["TOOLTIP_DISCOVERED"] = "Discovered"
L["TOOLTIP_UNDISCOVERED"] = "Undiscovered"
L["TOOLTIP_ZONE"] = "Zone: %s"
L["TOOLTIP_FACTION"] = "Faction: %s"
L["TOOLTIP_COORDINATES"] = "Location: %.1f, %.1f"
L["TOOLTIP_CLICK_INFO"] = "Click: Show info"
L["TOOLTIP_SHIFT_CLICK"] = "Shift+Click: Link in chat"
L["TOOLTIP_VISIT_TO_DISCOVER"] = "Visit this location to discover"
L["TOOLTIP_RIGHT_CLICK"] = "Right-click for more options"

-- Chat Messages
L["CHAT_FLIGHT_POINT_INFO"] = "%s - %s (%s)"
L["CHAT_FLIGHT_POINT_LINK"] = "Flight Point: %s in %s (%.1f, %.1f)"

-- Command Help
L["COMMAND_HELP_HEADER"] = "Available commands:"
L["COMMAND_TOGGLE"] = "/fl toggle - Toggle minimap icons"
L["COMMAND_UNDISCOVERED"] = "/fl undiscovered - Toggle undiscovered flight points"
L["COMMAND_DISCOVERED"] = "/fl discovered - Toggle discovered flight points"
L["COMMAND_DEBUG"] = "/fl debug - Toggle debug mode"
L["COMMAND_CONFIG"] = "/fl config - Open configuration window"
L["COMMAND_STATS"] = "/fl stats - Show flight point statistics"

-- Statistics
L["STATS_TITLE"] = "Flight Point Statistics"
L["STATS_TOTAL"] = "Total Flight Points: %d"
L["STATS_DISCOVERED"] = "Discovered: %d"
L["STATS_UNDISCOVERED"] = "Undiscovered: %d"
L["STATS_BY_FACTION"] = "By Faction:"
L["STATS_ALLIANCE"] = "Alliance: %d"
L["STATS_HORDE"] = "Horde: %d"
L["STATS_NEUTRAL"] = "Neutral: %d"
L["STATS_DISCOVERY_RATE"] = "Discovery Rate: %.1f%%"

-- Faction Names
L["FACTION_ALLIANCE"] = "Alliance"
L["FACTION_HORDE"] = "Horde"
L["FACTION_NEUTRAL"] = "Neutral"

-- Error Messages
L["ERROR_DATABASE_NOT_LOADED"] = "Database not loaded"
L["ERROR_NO_FLIGHT_POINTS"] = "No flight points found for current area"
L["ERROR_MAP_NOT_AVAILABLE"] = "Map information not available"

-- Debug Messages
L["DEBUG_DATABASE_INITIALIZED"] = "Database initialized with %d flight points"
L["DEBUG_MAP_OVERLAY_UPDATED"] = "Updated map overlay with %d flight points"
L["DEBUG_DISCOVERED_FLIGHT_POINTS"] = "Updating discovered flight points..."
L["DEBUG_TAXI_MAP_OPENED"] = "Taxi map opened, scanning for flight points"

-- Zone Names (for consistency with localized zone names)
-- Eastern Kingdoms
L["ZONE_STORMWIND_CITY"] = "Stormwind City"
L["ZONE_IRONFORGE"] = "Ironforge"
L["ZONE_UNDERCITY"] = "Undercity"
L["ZONE_ELWYNN_FOREST"] = "Elwynn Forest"
L["ZONE_DUN_MOROGH"] = "Dun Morogh"
L["ZONE_TIRISFAL_GLADES"] = "Tirisfal Glades"
L["ZONE_WESTFALL"] = "Westfall"
L["ZONE_LOCH_MODAN"] = "Loch Modan"
L["ZONE_SILVERPINE_FOREST"] = "Silverpine Forest"
L["ZONE_REDRIDGE_MOUNTAINS"] = "Redridge Mountains"
L["ZONE_WETLANDS"] = "Wetlands"
L["ZONE_DUSKWOOD"] = "Duskwood"
L["ZONE_HILLSBRAD_FOOTHILLS"] = "Hillsbrad Foothills"
L["ZONE_ARATHI_HIGHLANDS"] = "Arathi Highlands"
L["ZONE_STRANGLETHORN_VALE"] = "Stranglethorn Vale"
L["ZONE_BADLANDS"] = "Badlands"
L["ZONE_SEARING_GORGE"] = "Searing Gorge"
L["ZONE_BURNING_STEPPES"] = "Burning Steppes"
L["ZONE_WESTERN_PLAGUELANDS"] = "Western Plaguelands"
L["ZONE_EASTERN_PLAGUELANDS"] = "Eastern Plaguelands"

-- Kalimdor
L["ZONE_ORGRIMMAR"] = "Orgrimmar"
L["ZONE_THUNDER_BLUFF"] = "Thunder Bluff"
L["ZONE_UNDERCITY"] = "Undercity"
L["ZONE_DUROTAR"] = "Durotar"
L["ZONE_MULGORE"] = "Mulgore"
L["ZONE_THE_BARRENS"] = "The Barrens"
L["ZONE_TELDRASSIL"] = "Teldrassil"
L["ZONE_DARKSHORE"] = "Darkshore"
L["ZONE_ASHENVALE"] = "Ashenvale"
L["ZONE_STONETALON_MOUNTAINS"] = "Stonetalon Mountains"
L["ZONE_DESOLACE"] = "Desolace"
L["ZONE_FERALAS"] = "Feralas"
L["ZONE_THOUSAND_NEEDLES"] = "Thousand Needles"
L["ZONE_TANARIS"] = "Tanaris"
L["ZONE_UNGORO_CRATER"] = "Un'Goro Crater"
L["ZONE_FELWOOD"] = "Felwood"
L["ZONE_AZSHARA"] = "Azshara"
L["ZONE_WINTERSPRING"] = "Winterspring"

-- Special Locations
L["ZONE_BOOTY_BAY"] = "Booty Bay"
L["ZONE_RATCHET"] = "Ratchet"
L["ZONE_GADGETZAN"] = "Gadgetzan"
L["ZONE_EVERLOOK"] = "Everlook"

-- Flight Master Names (for tooltip consistency)
L["NPC_GRYPHON_MASTER_TALONAXE"] = "Gryphon Master Talonaxe"
L["NPC_GRYTH_THURDEN"] = "Gryth Thurden"
L["NPC_DUNGAR_LONGDRINK"] = "Dungar Longdrink"
L["NPC_THOR"] = "Thor"
L["NPC_SHELLEI_BRONDIR"] = "Shellei Brondir"
L["NPC_ARIENA_STORMFEATHER"] = "Ariena Stormfeather"

-- Make localization table available globally
FlightLocations_Locale = L

-- Set up localization function
function FlightLocations:GetLocalizedText(key, ...)
    local text = FlightLocations_Locale[key] or key
    if arg and arg.n and arg.n > 0 then
        return string.format(text, unpack(arg))
    end
    return text
end

-- Shorthand function
function FlightLocations:L(key, ...)
    return self:GetLocalizedText(key, unpack(arg or {}))
end
