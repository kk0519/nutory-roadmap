@echo off
REM Meshilog Flutter Setup Script
REM Run this once from Windows cmd or pwsh to set up the development environment

echo === Meshilog Flutter Dev Setup ===

REM Step 1: Check if Flutter is installed
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter not found. Downloading Flutter SDK...
    cd /d C:\
    mkdir flutter_sdk 2>nul
    cd flutter_sdk
    REM Download Flutter 3.22.0 stable for Windows
    curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.22.0-stable.zip" -o flutter.zip
    tar -xf flutter.zip
    setx PATH "%PATH%;C:\flutter_sdk\flutter\bin" /M
    echo Flutter installed. Restart cmd and re-run this script.
    pause
    exit /b 0
)

echo Flutter found: OK

REM Step 2: Enable Windows desktop (for local testing without emulator)
flutter config --enable-windows-desktop

REM Step 3: Install dependencies
cd /d %~dp0meshilog
flutter pub get
echo Dependencies installed: OK

REM Step 4: Install Firebase CLI (via npm if available, otherwise standalone)
where firebase >nul 2>&1
if %errorlevel% neq 0 (
    where npm >nul 2>&1
    if %errorlevel% equ 0 (
        npm install -g firebase-tools
    ) else (
        echo Install Node.js from https://nodejs.org then re-run, or download Firebase CLI standalone.
        echo https://firebase.tools/bin/win/latest
    )
)

REM Step 5: Install FlutterFire CLI
dart pub global activate flutterfire_cli

echo.
echo === NEXT MANUAL STEPS (browser required) ===
echo 1. firebase login
echo 2. Go to https://console.firebase.google.com -- create project "meshilog"
echo 3. Enable: Authentication (Email/Password), Firestore, Storage
echo 4. cd meshilog
echo 5. flutterfire configure --project=meshilog
echo 6. flutter run -d windows   (for local test)
echo.
pause
