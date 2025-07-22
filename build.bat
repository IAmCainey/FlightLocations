@echo off
REM Build script for Flight Locations addon (Windows)
REM This script helps maintain proper versioning for releases

if "%1"=="" (
    echo Usage: %0 ^<version^> [release-notes]
    echo Example: %0 1.0.1 "Bug fixes and performance improvements"
    echo.
    for /f "tokens=3" %%i in ('findstr /r "## Version:" FlightLocations.toc') do echo Current version: %%i
    exit /b 1
)

set NEW_VERSION=%1
set RELEASE_NOTES=%2

echo Building Flight Locations v%NEW_VERSION%

REM Update .toc file version
powershell -Command "(Get-Content FlightLocations.toc) -replace '^## Version:.*', '## Version: %NEW_VERSION%' | Set-Content FlightLocations.toc"

REM Update build date in main file
for /f "tokens=1-3 delims=/" %%a in ('date /t') do set BUILD_DATE=%%c-%%a-%%b
powershell -Command "(Get-Content FlightLocations.lua) -replace 'buildDate = \".*\"', 'buildDate = \"%BUILD_DATE%\"' | Set-Content FlightLocations.lua"

REM Create release directory
set RELEASE_DIR=..\FlightLocations-%NEW_VERSION%
if exist "%RELEASE_DIR%" rmdir /s /q "%RELEASE_DIR%"
mkdir "%RELEASE_DIR%"

REM Copy addon files (excluding development files)
xcopy /E /I /Y *.* "%RELEASE_DIR%\" >nul 2>&1
xcopy /E /I /Y Core "%RELEASE_DIR%\Core\" >nul 2>&1
xcopy /E /I /Y UI "%RELEASE_DIR%\UI\" >nul 2>&1
xcopy /E /I /Y Localization "%RELEASE_DIR%\Localization\" >nul 2>&1

REM Remove development files
del "%RELEASE_DIR%\build.sh" 2>nul
del "%RELEASE_DIR%\build.bat" 2>nul
del "%RELEASE_DIR%\Config.example.lua" 2>nul

echo Release package created: %RELEASE_DIR%
echo.
echo Next steps:
echo 1. Update Core\VersionManager.lua with version %NEW_VERSION% changelog
echo 2. Test the addon thoroughly
echo 3. Commit changes to version control
echo 4. Create git tag: git tag v%NEW_VERSION%
echo 5. Package for distribution

REM Optional: Create zip package if 7-Zip is available
where 7z >nul 2>&1
if %errorlevel%==0 (
    cd ..
    7z a FlightLocations-%NEW_VERSION%.zip FlightLocations-%NEW_VERSION%\ -x!*.git* -x!*.DS_Store*
    echo 6. Zip package created: FlightLocations-%NEW_VERSION%.zip
    cd FlightLocations
) else (
    echo 6. Install 7-Zip to automatically create zip packages
)

pause
