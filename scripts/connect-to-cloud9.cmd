@echo off
Setlocal EnableDelayedExpansion
title Connect with PuTTY to Cloud 9

:: Setup environment variables/configs
call %~dp0\config\config.cmd

:: Start making connection
echo Your cloud 9 username is %cloud9_username%
for /f "tokens=1-3,9 delims=	" %%i in ('aws ec2 describe-instances --filters "Name=tag:Name,Values=*%cloud9_username%*" --output text') do (
  if "%%i" == "INSTANCES" (
    set instance_id=%%l
  ) else if "%%i" == "STATE" (
    set status_code=%%j
    set status_text=%%k
  )
)


echo Your instance state is %status_text%
if not "%status_code%" == "0" if not "%status_code%" == "16" (
  set cold_start=1
  for /f %%i in ('aws ec2 start-instances --instance-ids %instance_id%') do (
    rem Just for hide return value...
  )
  echo Starting your instance...
  
  :statusLoop
  timeout 1
  
  for /f "tokens=1,2 delims=	" %%i in ('aws ec2 describe-instances --instance-ids %instance_id% --query "Reservations[*].Instances[*].State" --output text') do (
    set status_code=%%i
    set status_text=%%j
  )
  echo Your instance is currently %status_text%
  if not "%status_code%" == "16" goto statusLoop
  
  echo Your instance successfully started
)

echo Getting public ip...
for /f %%i in ('aws ec2 describe-instances --instance-ids %instance_id% --query "Reservations[*].Instances[*].PublicIpAddress" --output text') do set public_ip=%%i
echo Your public address is: %public_ip%

reg add "HKEY_USERS\%user_sid%\SOFTWARE\Microsoft\AppV\Client\Packages\%package_id%\REGISTRY\USER\%user_sid%\Software\SimonTatham\PuTTY\Sessions\%putty_profile%" /v HostName /t REG_SZ /d %public_ip% /f
echo New IP address was successfully set up

if "%cold_start%" == "1" (
  echo Let's wait a few sec until the server will be available for us...
  :: Here the ping host -a would be better, but it's blocked...
  timeout %wait_for_server%
)

echo Starting PuTTY
start %LOCALAPPDATA%\Microsoft\AppV\Client\Integration\%package_id%\Root\VFS\ProgramFilesX86\PuTTY\putty.exe plink -ssh -load %putty_profile%
