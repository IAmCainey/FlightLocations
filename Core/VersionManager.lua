-- Version Management for Flight Locations
-- This file contains version history and upgrade management

FlightLocations.VersionManager = {}

-- Version history with semantic versioning (MAJOR.MINOR.PATCH)
FlightLocations.VersionManager.history = {
    ["1.0.0"] = {
        releaseDate = "2025-07-22",
        changes = {
            "Initial release",
            "Complete Vanilla WoW flight point database",
            "World map integration with icon overlay",
            "Discovery tracking system",
            "Configuration interface",
            "Statistics tracking",
            "Turtle WoW compatibility",
            "Faction-based filtering",
            "Customizable icon size and transparency"
        },
        breaking = false,
        database = 1 -- Database schema version
    }
    -- Future versions will be added here following semantic versioning
    -- Examples:
    -- ["1.0.1"] = {
    --     releaseDate = "2025-XX-XX",
    --     changes = {
    --         "Bug fixes",
    --         "Performance improvements"
    --     },
    --     breaking = false,
    --     database = 1
    -- },
    -- ["1.1.0"] = {
    --     releaseDate = "2025-XX-XX", 
    --     changes = {
    --         "New feature: Minimap integration",
    --         "Added custom Turtle WoW flight points",
    --         "Improved UI responsiveness"
    --     },
    --     breaking = false,
    --     database = 2
    -- },
    -- ["2.0.0"] = {
    --     releaseDate = "2025-XX-XX",
    --     changes = {
    --         "Major rewrite for improved performance",
    --         "New database format (breaking change)",
    --         "Enhanced discovery system"
    --     },
    --     breaking = true,
    --     database = 3
    -- }
}

-- Semantic versioning utilities
function FlightLocations.VersionManager:ParseVersion(versionString)
    if not versionString then return nil end
    
    local parts = {}
    for part in string.gmatch(versionString, "[^%.]+") do
        local num = tonumber(part)
        if num then
            table.insert(parts, num)
        else
            return nil -- Invalid version format
        end
    end
    
    -- Ensure we have at least 3 parts (major.minor.patch)
    while table.getn(parts) < 3 do
        table.insert(parts, 0)
    end
    
    return {
        major = parts[1] or 0,
        minor = parts[2] or 0,
        patch = parts[3] or 0,
        full = versionString
    }
end

function FlightLocations.VersionManager:CompareVersions(version1, version2)
    local v1 = self:ParseVersion(version1)
    local v2 = self:ParseVersion(version2)
    
    if not v1 or not v2 then return 0 end
    
    if v1.major > v2.major then return 1
    elseif v1.major < v2.major then return -1
    elseif v1.minor > v2.minor then return 1
    elseif v1.minor < v2.minor then return -1
    elseif v1.patch > v2.patch then return 1
    elseif v1.patch < v2.patch then return -1
    else return 0 end
end

function FlightLocations.VersionManager:IsVersionNewer(oldVersion, newVersion)
    return self:CompareVersions(newVersion, oldVersion) > 0
end

function FlightLocations.VersionManager:IsBreakingChange(fromVersion, toVersion)
    if not self.history[toVersion] then return false end
    return self.history[toVersion].breaking or false
end

function FlightLocations.VersionManager:GetDatabaseVersion(version)
    if not self.history[version] then return 1 end
    return self.history[version].database or 1
end

function FlightLocations.VersionManager:GetChangelog(version)
    if not self.history[version] then return {} end
    return self.history[version].changes or {}
end

function FlightLocations.VersionManager:ShowChangelog(version)
    local changes = self:GetChangelog(version)
    if table.getn(changes) == 0 then
        FlightLocations:Print("No changelog available for version " .. (version or "unknown"))
        return
    end
    
    FlightLocations:Print("Changes in version " .. version .. ":")
    for i, change in ipairs(changes) do
        FlightLocations:Print("  • " .. change)
    end
end

function FlightLocations.VersionManager:HandleUpgrade(oldVersion, newVersion)
    if not oldVersion then
        -- First installation
        FlightLocations:Print("Welcome to Flight Locations! Type /fl for commands.")
        return
    end
    
    local isNewer = self:IsVersionNewer(oldVersion, newVersion)
    if not isNewer then
        return -- No upgrade needed
    end
    
    local isBreaking = self:IsBreakingChange(oldVersion, newVersion)
    if isBreaking then
        FlightLocations:Print("|cffff8000Warning:|r This update contains breaking changes!")
        FlightLocations:Print("Your settings may need to be reconfigured.")
    end
    
    -- Show changelog for new version
    FlightLocations:Print("Updated to Flight Locations v" .. newVersion)
    self:ShowChangelog(newVersion)
    
    -- Handle database migrations
    self:MigrateDatabase(oldVersion, newVersion)
end

function FlightLocations.VersionManager:MigrateDatabase(oldVersion, newVersion)
    local oldDB = self:GetDatabaseVersion(oldVersion)
    local newDB = self:GetDatabaseVersion(newVersion)
    
    if oldDB == newDB then
        return -- No database changes
    end
    
    FlightLocations:Print("Migrating database from version " .. oldDB .. " to " .. newDB)
    
    -- Database migration logic would go here
    -- For now, we'll just clear any cache to be safe
    if FlightLocationsDB.cache then
        FlightLocationsDB.cache = nil
        FlightLocations:Debug("Cleared cache during database migration")
    end
    
    FlightLocationsDB.databaseVersion = newDB
end

-- Version validation
function FlightLocations.VersionManager:ValidateVersion(version)
    local parsed = self:ParseVersion(version)
    if not parsed then
        FlightLocations:Print("|cffff0000Error:|r Invalid version format: " .. (version or "nil"))
        return false
    end
    
    return true
end

-- Get current version information
function FlightLocations.VersionManager:GetVersionInfo()
    local currentVersion = FlightLocations.version
    local info = {
        version = currentVersion,
        parsed = self:ParseVersion(currentVersion),
        releaseDate = self.history[currentVersion] and self.history[currentVersion].releaseDate,
        databaseVersion = self:GetDatabaseVersion(currentVersion),
        buildDate = FlightLocations.addonInfo.buildDate,
        buildNumber = FlightLocations.addonInfo.buildNumber
    }
    
    return info
end
