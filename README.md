# Flight Locations Addon for Turtle WoW

A World of Warcraft addon specifically designed for Turtle WoW that displays all flight locations on the world map, showing both discovered and undiscovered flight points.

## Features

- **Complete Flight Point Database**: Includes all standard Vanilla WoW flight points
- **Visual Map Integration**: Shows flight points as icons on the world map
- **Discovery Tracking**: Automatically tracks which flight points you've discovered
- **Faction Filtering**: Option to show only flight points available to your faction
- **Customizable Display**: Adjust icon size, transparency, and visibility options
- **Detailed Tooltips**: Hover over icons for flight master names, coordinates, and faction info
- **Statistics Tracking**: View your flight point discovery progress
- **Turtle WoW Compatible**: Built specifically for the Vanilla WoW client used by Turtle WoW

## Installation

1. Download or clone this repository
2. Copy the `FlightLocations` folder to your World of Warcraft `Interface\AddOns\` directory
3. The path should look like: `World of Warcraft\Interface\AddOns\FlightLocations\`
4. Restart World of Warcraft or reload your UI with `/reload`
5. Enable the addon in the AddOns list at the character selection screen

## Usage

### Basic Commands

- `/flightlocations` or `/fl` - Show help
- `/fl toggle` - Toggle minimap icons on/off
- `/fl undiscovered` - Toggle display of undiscovered flight points
- `/fl discovered` - Toggle display of discovered flight points
- `/fl config` - Open configuration window
- `/fl stats` - Show flight point statistics
- `/fl debug` - Toggle debug mode

### Configuration Options

Access the configuration panel with `/fl config` or through the interface options. You can adjust:

- **Show Discovered Flight Points**: Display flight points you've already discovered
- **Show Undiscovered Flight Points**: Display flight points you haven't found yet
- **Show Tooltips**: Enable/disable informational tooltips when hovering over icons
- **Filter by Faction**: Only show flight points available to your faction
- **Show on World Map**: Enable/disable world map icons
- **Icon Size**: Adjust the size of flight point icons (8-32 pixels)
- **Icon Transparency**: Adjust the opacity of flight point icons

### Map Integration

- Open your world map to see flight point icons
- Icons are color-coded by faction:
  - **Blue**: Alliance flight points
  - **Red**: Horde flight points  
  - **Yellow**: Neutral flight points
  - **Gray**: Undiscovered flight points
- Hover over icons for detailed information
- Click icons for basic information
- Shift+click icons to share location in chat

### Discovery System

The addon automatically detects when you discover new flight points by:

- Monitoring when you open taxi maps
- Tracking available flight destinations
- Saving discovery status per character

## File Structure

```text
FlightLocations/
├── FlightLocations.toc          # Addon metadata
├── FlightLocations.lua          # Main addon file
├── Core/
│   ├── Database.lua             # Flight point database
│   ├── FlightLocations.lua      # Core functionality
│   └── MapIntegration.lua       # Map integration logic
├── UI/
│   ├── FlightLocationFrame.lua  # Configuration interface
│   └── MapOverlay.lua           # Map overlay system
└── Localization/
    └── enUS.lua                 # English localization
```

## Compatibility

- **Client Version**: World of Warcraft 1.12.1 (Vanilla)
- **Server**: Turtle WoW
- **Interface Version**: 11200
- **Dependencies**: None

## Customization

### Adding Custom Flight Points

To add custom Turtle WoW flight points, edit `Core/Database.lua` and add entries to the `turtleWoWFlightPoints` table:

```lua
{
    name = "Flight Master Name",
    zone = "Zone Name",
    continent = 1, -- 1 for Kalimdor, 2 for Eastern Kingdoms
    x = 50.0,      -- X coordinate (0-100)
    y = 50.0,      -- Y coordinate (0-100)
    faction = "Neutral", -- "Alliance", "Horde", or "Neutral"
    npcId = 12345  -- NPC ID of flight master
}
```

### Icon Customization

Icon textures can be modified in `UI/MapOverlay.lua` by changing the texture paths:

```lua
local ICON_DISCOVERED = "Interface\\TaxiFrame\\UI-Taxi-Icon-Green"
local ICON_UNDISCOVERED = "Interface\\TaxiFrame\\UI-Taxi-Icon-Gray"
-- etc.
```

## Troubleshooting

### Common Issues

1. **Icons not showing**:
   - Check that "Show on World Map" is enabled in settings
   - Verify the addon is enabled in the AddOns list
   - Try `/reload` to refresh the UI

2. **Discovery not working**:
   - Open flight maps at flight masters to trigger discovery
   - Check that you have the proper permissions to use the flight point

3. **Performance issues**:
   - Reduce icon size in configuration
   - Disable undiscovered flight points if not needed
   - Lower icon transparency for less visual impact

### Debug Mode

Enable debug mode with `/fl debug` to see additional information in chat about:

- Database initialization
- Map overlay updates
- Flight point discovery events

## Contributing

This addon is designed specifically for Turtle WoW. Contributions are welcome for:

- Additional Turtle WoW specific flight points
- Bug fixes and optimizations
- Localization for other languages
- UI improvements

## License

This addon is created for the Turtle WoW community. World of Warcraft remains the intellectual property of Blizzard Entertainment.

## Changelog

### Version 1.0.0

- Initial release
- Complete Vanilla WoW flight point database
- World map integration
- Discovery tracking system
- Configuration interface
- Statistics tracking
- Turtle WoW compatibility
