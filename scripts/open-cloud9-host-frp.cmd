@echo off
Setlocal EnableDelayedExpansion
title Open Cloud 9 host in browser

:: Setup environment variables/configs
call %~dp0\config\config.cmd

:: Start making connection
echo Your cloud 9 username is %cloud9_username%

echo Give the site dir which you want to open (if empty root dir will be opened)
set /P site_dir=

:: Check if there's any credentials set.
set http_access=%frp_http_access_user%:%frp_http_access_pass%@
if "%frp_http_access_user%" == "" set http_access=
if "%frp_http_access_pass%" == "" set http_access=

:: Open the site in the most comfortable way.

if not "%site_dir%" == "" (
  start https://%http_access%%cloud9_username%.c9.fpfis.tech.ec.europa.eu/%site_dir%/build/
) else (
  start https://%http_access%%cloud9_username%.c9.fpfis.tech.ec.europa.eu/
)
