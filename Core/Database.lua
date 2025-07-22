-- Flight Locations Database
-- Contains all flight point coordinates and information for Turtle WoW

FlightLocations.Database = {}

-- Flight point data structure:
-- {
--     name = "Flight Master Name",
--     zone = "Zone Name", 
--     continent = 1 (Kalimdor) or 2 (Eastern Kingdoms),
--     x = map coordinate (0-100),
--     y = map coordinate (0-100),
--     faction = "Alliance", "Horde", or "Neutral",
--     cost = { [destination] = copper_cost },
--     npcId = NPC ID of flight master
-- }

local flightPoints = {
    -- Eastern Kingdoms Flight Points
    
    -- Alliance - Eastern Kingdoms
    {
        name = "Gryphon Master Talonaxe",
        zone = "Stormwind City",
        continent = 2,
        x = 66.3,
        y = 62.1,
        faction = "Alliance",
        npcId = 352
    },
    {
        name = "Gryth Thurden",
        zone = "Ironforge",
        continent = 2,
        x = 55.5,
        y = 47.7,
        faction = "Alliance",
        npcId = 1573
    },
    {
        name = "Cedrik Prose",
        zone = "Stormwind City",
        continent = 2,
        x = 70.9,
        y = 72.5,
        faction = "Alliance",
        npcId = 523
    },
    {
        name = "Ariena Stormfeather",
        zone = "Redridge Mountains",
        continent = 2,
        x = 30.6,
        y = 59.4,
        faction = "Alliance",
        npcId = 931
    },
    {
        name = "Thor",
        zone = "Wetlands",
        continent = 2,
        x = 9.5,
        y = 59.7,
        faction = "Alliance",
        npcId = 1387
    },
    {
        name = "Shellei Brondir",
        zone = "Wetlands",
        continent = 2,
        x = 56.3,
        y = 41.9,
        faction = "Alliance",
        npcId = 2299
    },
    {
        name = "Thorgrum Borrelson",
        zone = "Loch Modan",
        continent = 2,
        x = 33.9,
        y = 50.9,
        faction = "Alliance",
        npcId = 1572
    },
    {
        name = "Vrides Darkower",
        zone = "Duskwood",
        continent = 2,
        x = 77.5,
        y = 44.3,
        faction = "Alliance",
        npcId = 2409
    },
    {
        name = "Karos Razok",
        zone = "Stranglethorn Vale",
        continent = 2,
        x = 27.5,
        y = 77.8,
        faction = "Alliance",
        npcId = 2858
    },
    {
        name = "Gringer",
        zone = "Stranglethorn Vale",
        continent = 2,
        x = 27.6,
        y = 77.3,
        faction = "Horde",
        npcId = 2859
    },
    
    -- Horde - Eastern Kingdoms
    {
        name = "Zarise",
        zone = "Undercity",
        continent = 2,
        x = 63.3,
        y = 48.6,
        faction = "Horde",
        npcId = 4551
    },
    {
        name = "Michael Garrett",
        zone = "Tirisfal Glades",
        continent = 2,
        x = 83.0,
        y = 69.9,
        faction = "Horde",
        npcId = 2226
    },
    {
        name = "Urda",
        zone = "Silverpine Forest",
        continent = 2,
        x = 45.6,
        y = 42.6,
        faction = "Horde",
        npcId = 2389
    },
    {
        name = "Karos Razok",
        zone = "Arathi Highlands",
        continent = 2,
        x = 73.0,
        y = 32.7,
        faction = "Horde",
        npcId = 2851
    },
    {
        name = "Ursula Deline",
        zone = "Badlands",
        continent = 2,
        x = 4.0,
        y = 44.8,
        faction = "Alliance",
        npcId = 2861
    },
    {
        name = "Gorrik",
        zone = "Badlands",
        continent = 2,
        x = 4.0,
        y = 44.8,
        faction = "Horde",
        npcId = 2862
    },
    
    -- Neutral - Eastern Kingdoms
    {
        name = "Guthrum Thunderfist",
        zone = "Booty Bay",
        continent = 2,
        x = 27.0,
        y = 77.2,
        faction = "Neutral",
        npcId = 2858
    },
    
    -- Kalimdor Flight Points
    
    -- Alliance - Kalimdor
    {
        name = "Vesprystus",
        zone = "Rut'theran Village",
        continent = 1,
        x = 58.4,
        y = 94.0,
        faction = "Alliance",
        npcId = 3838
    },
    {
        name = "Silva Fil'naveth",
        zone = "Teldrassil",
        continent = 1,
        x = 58.4,
        y = 94.0,
        faction = "Alliance",
        npcId = 4267
    },
    {
        name = "Caylais Moonfeather",
        zone = "Auberdine",
        continent = 1,
        x = 36.3,
        y = 45.6,
        faction = "Alliance",
        npcId = 3841
    },
    {
        name = "Thyssiana",
        zone = "Ashenvale",
        continent = 1,
        x = 34.4,
        y = 48.0,
        faction = "Alliance",
        npcId = 4267
    },
    {
        name = "Hippogryph Master Stephanos",
        zone = "Feathermoon Stronghold",
        continent = 1,
        x = 30.2,
        y = 43.2,
        faction = "Alliance",
        npcId = 8019
    },
    
    -- Horde - Kalimdor
    {
        name = "Tal",
        zone = "Orgrimmar",
        continent = 1,
        x = 45.1,
        y = 63.9,
        faction = "Horde",
        npcId = 3310
    },
    {
        name = "Devrak",
        zone = "Orgrimmar",
        continent = 1,
        x = 45.1,
        y = 63.9,
        faction = "Horde",
        npcId = 3305
    },
    {
        name = "Wind Rider Master Keeshan",
        zone = "Razor Hill",
        continent = 1,
        x = 51.9,
        y = 43.5,
        faction = "Horde",
        npcId = 3615
    },
    {
        name = "Omusa Thunderhorn",
        zone = "Thunder Bluff",
        continent = 1,
        x = 47.0,
        y = 49.8,
        faction = "Horde",
        npcId = 2995
    },
    {
        name = "Tal",
        zone = "Thunder Bluff",
        continent = 1,
        x = 47.0,
        y = 49.8,
        faction = "Horde",
        npcId = 2389
    },
    {
        name = "Nyse",
        zone = "The Crossroads",
        continent = 1,
        x = 51.5,
        y = 30.3,
        faction = "Horde",
        npcId = 3615
    },
    {
        name = "Kroum",
        zone = "Ratchet",
        continent = 1,
        x = 63.1,
        y = 37.1,
        faction = "Neutral",
        npcId = 16227
    },
    
    -- Neutral - Kalimdor
    {
        name = "Bera Stonehammer",
        zone = "Everlook",
        continent = 1,
        x = 62.2,
        y = 36.6,
        faction = "Neutral",
        npcId = 11138
    },
    {
        name = "Fyldren Moonfeather",
        zone = "Gadgetzan",
        continent = 1,
        x = 51.0,
        y = 29.3,
        faction = "Neutral",
        npcId = 7823
    }
}

-- Turtle WoW specific flight points (these are custom additions)
local turtleWoWFlightPoints = {
    -- Custom Turtle WoW flight points can be added here
    -- These would need to be discovered through gameplay or community data
}

-- Discovered flight points (saved per character)
local discoveredFlightPoints = {}

function FlightLocations.Database:Initialize()
    -- Merge standard and Turtle WoW specific flight points
    self.allFlightPoints = {}
    
    for i, point in ipairs(flightPoints) do
        table.insert(self.allFlightPoints, point)
    end
    
    for i, point in ipairs(turtleWoWFlightPoints) do
        table.insert(self.allFlightPoints, point)
    end
    
    -- Load discovered flight points from saved variables
    if FlightLocationsDB and FlightLocationsDB.discoveredFlightPoints then
        discoveredFlightPoints = FlightLocationsDB.discoveredFlightPoints
    else
        FlightLocationsDB.discoveredFlightPoints = {}
        discoveredFlightPoints = FlightLocationsDB.discoveredFlightPoints
    end
    
    FlightLocations:Debug("Database initialized with " .. table.getn(self.allFlightPoints) .. " flight points")
end

function FlightLocations.Database:GetAllFlightPoints()
    return self.allFlightPoints or {}
end

function FlightLocations.Database:GetFlightPointsForZone(zoneName)
    local zonePoints = {}
    
    for i, point in ipairs(self:GetAllFlightPoints()) do
        if point.zone == zoneName then
            table.insert(zonePoints, point)
        end
    end
    
    return zonePoints
end

function FlightLocations.Database:GetFlightPointsForContinent(continent)
    local continentPoints = {}
    
    for i, point in ipairs(self:GetAllFlightPoints()) do
        if point.continent == continent then
            table.insert(continentPoints, point)
        end
    end
    
    return continentPoints
end

function FlightLocations.Database:IsFlightPointDiscovered(point)
    local playerName = UnitName("player")
    local realmName = GetRealmName()
    local key = playerName .. "-" .. realmName
    
    if not discoveredFlightPoints[key] then
        return false
    end
    
    -- Check if this flight point is discovered
    for i, discovered in ipairs(discoveredFlightPoints[key]) do
        if discovered.zone == point.zone and discovered.name == point.name then
            return true
        end
    end
    
    return false
end

function FlightLocations.Database:MarkFlightPointDiscovered(point)
    local playerName = UnitName("player")
    local realmName = GetRealmName()
    local key = playerName .. "-" .. realmName
    
    if not discoveredFlightPoints[key] then
        discoveredFlightPoints[key] = {}
    end
    
    -- Check if already discovered
    if not self:IsFlightPointDiscovered(point) then
        table.insert(discoveredFlightPoints[key], {
            name = point.name,
            zone = point.zone,
            discoveredTime = time()
        })
        
        FlightLocations:Print("Discovered flight point: " .. point.name .. " in " .. point.zone)
    end
end

function FlightLocations.Database:UpdateDiscoveredFlightPoints()
    -- This function would be called when the taxi map is opened
    -- In a real implementation, you would scan the available taxi nodes
    -- and mark them as discovered
    
    -- For now, this is a placeholder that could be enhanced with
    -- actual taxi node detection logic
    FlightLocations:Debug("Updating discovered flight points...")
end

function FlightLocations.Database:GetPlayerFaction()
    local playerFaction = UnitFactionGroup("player")
    return playerFaction or "Unknown"
end

function FlightLocations.Database:CanUseFlightPoint(point)
    local playerFaction = self:GetPlayerFaction()
    
    if point.faction == "Neutral" then
        return true
    end
    
    return point.faction == playerFaction
end
