@echo off
Setlocal EnableDelayedExpansion
title Open Cloud 9 ide in browser

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

start https://%region%.console.aws.amazon.com/cloud9/ide/%environment_id%
