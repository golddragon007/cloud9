@echo off
Setlocal EnableDelayedExpansion
title Open Cloud 9 host in browser

:: Setup environment variables/configs
call %~dp0\config\config.cmd

:: Start making connection
echo Your cloud 9 username is %cloud9_username%
if "%environment_id%" == "" (
  echo Getting environment id...
  for /f "tokens=1-3 delims=	" %%i in ('aws ec2 describe-instances --filters "Name=tag:Name,Values=*%cloud9_username%*" --output text') do (
    if "%%i" == "TAGS" if "%%j" == "aws:cloud9:environment" (
      set environment_id=%%k
    )
  )
)

if "%1" == "" (
  echo Give the site dir which you want to open (if empty apache root dir will be opened^)
  set /P site_dir=
) else (
  set site_dir=%1
)

if not "%site_dir%" == "" (
  start https://%environment_id%.vfs.cloud9.%region%.amazonaws.com/%site_dir%/build/
) else (
  start https://%environment_id%.vfs.cloud9.%region%.amazonaws.com/
)
