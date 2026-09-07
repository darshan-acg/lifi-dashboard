@echo off
REM ---------------------------------------------------------------
REM  Publishes the latest ks5623.html to GitHub Pages.
REM  Run this file after every edit to the dashboard.
REM ---------------------------------------------------------------
setlocal
cd /d "%~dp0"

echo.
echo  Copying the newest dashboard into the site folder...
copy /Y "..\ks5623.html" "index.html" >nul
if errorlevel 1 (
  echo  ERROR: ..\ks5623.html was not found.
  pause
  exit /b 1
)

echo  Committing...
git add -A
git commit -m "Update dashboard" || echo  (nothing changed since the last publish)

echo  Pushing to GitHub...
git push origin main
if errorlevel 1 (
  echo.
  echo  Push failed. Check the internet connection and the GitHub sign-in.
  pause
  exit /b 1
)

echo.
echo  Done. GitHub Pages rebuilds in about a minute.
echo.
pause
