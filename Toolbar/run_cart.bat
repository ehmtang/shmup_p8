@echo off
rem Move up one level from the batch file location
for %%I in ("%~dp0..") do set "parent=%%~fI"

rem Extract the folder name (e.g., "shmup")
for %%I in ("%parent%") do set "parent_folder=%%~nxI"

echo The folder is: %parent_folder%

rem Set the default cart name
set "cartName=cart.p8"

rem Construct the full path correctly
set "cartPath=%parent%\%cartName%"

echo Loading from: %cartPath%
cmd /c start pico8.exe -run "%cartPath%"
