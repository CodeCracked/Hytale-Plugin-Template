@echo off
setlocal EnableExtensions

rem --- Run from the folder this .bat is in ---
pushd "%~dp0"

rem --- Paths / URLs (all relative to this .bat) ---
set "PATCHLINE=pre-release"
set "DOWNLOADER_EXE=hytale-downloader\hytale-downloader-windows-amd64.exe"
set "DOWNLOADER_ZIP=tmp\hytale-downloader.zip"
set "DOWNLOADER_URL=https://downloader.hytale.com/hytale-downloader.zip"
set "HYTALE_ZIP=libs\hytale.zip"
set "CREDENTIALS=hytale-downloader\credentials.json"

rem --- Require curl + tar ---
where curl >nul 2>&1 || (
  echo ERROR: curl is required but was not found in PATH.
  goto :fail
)
where tar >nul 2>&1 || (
  echo ERROR: tar is required but was not found in PATH.
  goto :fail
)

rem --- Ensure base folders exist ---
if not exist "libs" mkdir "libs" >nul 2>&1

rem ============================================================
rem 1) Ensure Hytale Downloader CLI exists
rem ============================================================
if not exist "%DOWNLOADER_EXE%" (
  echo Downloading Hytale Downloader CLI...

  if not exist "tmp" mkdir "tmp" >nul 2>&1

  rem Download the CLI zip
  curl -L --fail -o "%DOWNLOADER_ZIP%" "%DOWNLOADER_URL%" || (
    echo ERROR: Failed to download Hytale Downloader CLI.
    goto :fail
  )

  echo(
  echo Extracting Hytale Downloader...

  if not exist "hytale-downloader" mkdir "hytale-downloader" >nul 2>&1

  rem Extract the CLI zip
  tar -xf "%DOWNLOADER_ZIP%" -C "hytale-downloader" || (
    echo ERROR: Failed to extract Hytale Downloader CLI.
    goto :fail
  )

  rem Clean up tmp folder
  rmdir /s /q "tmp" >nul 2>&1
)

rem ============================================================
rem 2) Download Hytale
rem ============================================================
echo Downloading Hytale...

"%DOWNLOADER_EXE%" -download-path "%HYTALE_ZIP%" -credentials-path "%CREDENTIALS%" -patchline "%PATCHLINE%" || (
  echo ERROR: Hytale download failed.
  goto :fail
)

rem ============================================================
rem 3) Extract Hytale zip to libs
rem ============================================================
echo(
echo Extracting Hytale...

tar -xf "%HYTALE_ZIP%" -C "libs" || (
  echo ERROR: Failed to extract Hytale.
  goto :fail
)

rem ============================================================
rem 4) Cleanup
rem ============================================================
del /f /q "%HYTALE_ZIP%" >nul 2>&1
del /f /q "hytale-downloader\hytale.zip" >nul 2>&1

echo Done.
goto :end

:fail
echo.
echo Script failed.
popd
endlocal
pause
exit /b 1

:end
popd
endlocal
pause
exit /b 0
