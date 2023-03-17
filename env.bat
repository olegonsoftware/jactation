@echo off

set D=%~dp0
set S=%~dpnx0

set TARGETDIR=%D%target
set LOGDIR=%D%logs
set APPJAR=%TARGETDIR%\app.jar

mkdir "%TARGETDIR%"
mkdir "%LOGDIR%"