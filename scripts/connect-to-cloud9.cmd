@echo off
Setlocal EnableDelayedExpansion
title Connect with PuTTY to Cloud 9

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
if not "%status_code%" == "0" if not "%status_code%" == "16" (
  set cold_start=1
  for /f %%i in ('aws ec2 start-instances --instance-ids %instance_id%') do (
    rem Just for hide return value...
  )
  echo Starting your instance...
  
  :statusLoop
  timeout 1 /NOBREAK
  
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

:: If we still don't have a package id in this place, than probably the user using a locally installed non virtualized version.
if "%package_id%" == "" (
  reg add "HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions\%putty_profile%" /v HostName /t REG_SZ /d %public_ip% /f
) else (
  ::reg add "HKEY_USERS\%user_sid%\SOFTWARE\Microsoft\AppV\Client\Packages\%package_id%\REGISTRY\USER\%user_sid%\Software\SimonTatham\PuTTY\Sessions\%putty_profile%" /v HostName /t REG_SZ /d %public_ip% /f
  reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\AppV\Client\Packages\%package_id%\REGISTRY\USER\%user_sid%\Software\SimonTatham\PuTTY\Sessions\%putty_profile%" /v HostName /t REG_SZ /d %public_ip% /f
)
echo New IP address was successfully set up

if "%cold_start%" == "1" (
  echo Let's wait a few sec until the server will be available for us...
  :: Here the ping host -a would be better, but it's blocked...
  timeout %wait_for_server% /NOBREAK
)

if "%accept_fingerprint%" == "1" (
  echo Accepting fingerprint automatically...
  echo y | %putty_path%plink.exe -load "%putty_profile%" exit
)

echo Starting PuTTY
start %putty_path%putty.exe -load "%putty_profile%"
