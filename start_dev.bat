@echo off
REM Meshilog Development Quick Start
REM Opens Chrome with iPhone viewport at the Flutter Web dev server

echo Starting Meshilog Dev Mode...
echo.
echo [1] Opening Chrome with iPhone 14 Pro viewport...
echo     URL: http://localhost:8765
echo.
echo TIPS in Chrome:
echo   F12          -> Open DevTools
echo   Ctrl+Shift+M -> Toggle device toolbar (mobile view)
echo   Select device: iPhone 14 Pro or Pixel 7
echo.

REM Open Chrome with mobile emulation flags
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" ^
    --new-window ^
    "http://localhost:8765"

echo Chrome opened. Use F12 + Ctrl+Shift+M for mobile view.
pause
