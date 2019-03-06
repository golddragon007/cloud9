@echo off
Setlocal EnableDelayedExpansion
title Stop cloud 9 environment

:: Setup environment variables/configs
call %~dp0\config\config.cmd

:: Start making connection
echo Your cloud 9 username is %cloud9_username%
if "%instance_id%" == "" (
  for /f "tokens=1-3,9 delims=	" %%i in ('aws ec2 describe-instances --filters "Name=tag:Name,Values=*%cloud9_username%*" --output text') do (
    if "%%i" == "INSTANCES" (
      set instance_id=%%l
    )
  )
)

for /f "tokens=1,2 delims=	" %%i in ('aws ec2 describe-instances --instance-ids %instance_id% --query "Reservations[*].Instances[*].State" --output text') do (
  set status_code=%%i
  set status_text=%%j
)


echo Your instance state is %status_text%
if not "%status_code%" == "80" (
  set cold_start=1
  for /f %%i in ('aws ec2 stop-instances --instance-ids %instance_id%') do (
    rem Just for hide return value...
  )
  echo Stopping your instance...
  
  :statusLoop
  timeout 1 /NOBREAK
  
  for /f "tokens=1,2 delims=	" %%i in ('aws ec2 describe-instances --instance-ids %instance_id% --query "Reservations[*].Instances[*].State" --output text') do (
    set status_code=%%i
    set status_text=%%j
  )
  echo Your instance is currently %status_text%
  if not "%status_code%" == "80" goto statusLoop
  
  echo Your instance successfully stopped
)