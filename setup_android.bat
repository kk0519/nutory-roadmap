@echo off
REM Meshilog Android Dev Setup
REM Run from Windows cmd.exe (right-click -> Run as administrator if UAC prompt appears)
REM Expected time: 10-20 min (download + install)

echo ============================================
echo  Meshilog Android Emulator Setup
echo ============================================
echo.

REM Step 1: Install Flutter for Windows
echo [1/5] Installing Flutter for Windows via winget...
winget install Google.AndroidStudio.Stable --silent --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo Failed. Trying alternate package name...
    winget install Google.AndroidStudio --silent --accept-package-agreements --accept-source-agreements
)
echo Flutter install done.

REM Step 2: Install Flutter SDK via winget (if available) or manual
echo [2/5] Checking Flutter SDK...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter not found. Downloading Flutter 3.22.0 for Windows...
    mkdir C:\flutter_sdk 2>nul
    curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.22.0-stable.zip" -o C:\flutter_sdk\flutter.zip
    tar -xf C:\flutter_sdk\flutter.zip -C C:\flutter_sdk\
    setx PATH "%PATH%;C:\flutter_sdk\flutter\bin" /M
    set "PATH=%PATH%;C:\flutter_sdk\flutter\bin"
    echo Flutter extracted to C:\flutter_sdk\flutter\bin
    echo NOTE: Restart cmd after setup to use flutter command.
)

REM Step 3: Android SDK setup via cmdline-tools
echo [3/5] Setting up Android SDK...
set ANDROID_HOME=C:\Android\sdk
set PATH=%PATH%;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\emulator

REM Find sdkmanager from Android Studio installation
set SDKMANAGER=
for %%p in (
    "C:\Program Files\Android\Android Studio\jbr\bin"
    "C:\Users\%USERNAME%\AppData\Local\Android\Sdk\cmdline-tools\latest\bin"
) do (
    if exist "%%p\sdkmanager.bat" set SDKMANAGER=%%p\sdkmanager.bat
)

REM Download cmdline-tools if not found
if not defined SDKMANAGER (
    echo Downloading Android cmdline-tools...
    mkdir C:\Android\sdk\cmdline-tools 2>nul
    curl -L "https://dl.google.com/android/repository/commandlinetools-win-12266719_latest.zip" -o C:\Android\sdk\cmdline-tools.zip
    tar -xf C:\Android\sdk\cmdline-tools.zip -C C:\Android\sdk\cmdline-tools\
    ren C:\Android\sdk\cmdline-tools\cmdline-tools C:\Android\sdk\cmdline-tools\latest 2>nul
    set SDKMANAGER=C:\Android\sdk\cmdline-tools\latest\bin\sdkmanager.bat
)

echo Android SDK location: %ANDROID_HOME%

REM Step 4: Install required SDK components (lightweight: API30 no Google Play)
echo [4/5] Installing SDK components (emulator + API 30 system image)...
echo y | "%SDKMANAGER%" --sdk_root="%ANDROID_HOME%" --licenses
echo y | "%SDKMANAGER%" --sdk_root="%ANDROID_HOME%" "platform-tools" "emulator" "platforms;android-30" "system-images;android-30;google_apis;x86_64"

REM Step 5: Create AVD (lightweight: 1GB RAM, no camera for speed)
echo [5/5] Creating Android Virtual Device (Pixel 6 API 30)...
set AVDMANAGER=C:\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat
if not exist "%AVDMANAGER%" (
    for %%p in ("C:\Users\%USERNAME%\AppData\Local\Android\Sdk\cmdline-tools\latest\bin\avdmanager.bat") do (
        if exist "%%p" set AVDMANAGER=%%p
    )
)

echo no | "%AVDMANAGER%" --sdk_root="%ANDROID_HOME%" create avd ^
    --name "Meshilog_Pixel6_API30" ^
    --device "pixel_6" ^
    --package "system-images;android-30;google_apis;x86_64" ^
    --force

echo.
echo ============================================
echo  Setup Complete!
echo ============================================
echo.
echo Next steps:
echo   1. Start emulator:
echo      C:\Android\sdk\emulator\emulator.exe -avd Meshilog_Pixel6_API30 -memory 1024 -no-snapshot
echo.
echo   2. Run Flutter app (new cmd window):
echo      cd C:\NutriLedger\meshilog
echo      flutter run
echo.
echo   3. Select the emulator when prompted.
echo.
pause
