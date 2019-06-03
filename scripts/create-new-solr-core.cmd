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

if not "%status_code%" == "16" (
  echo Start your instance first!
  pause
  exit /b 4
)

:: Ask for core, if not in parameter.
:askparam
if "%1" == "" (
  echo Give the new solr core name, which should be created:
  set /P solr_core=
) else (
  set solr_core=%1
)

:: If just enter was pressed, then ask again.
if "%solr_core%" == "" (
  goto askparam
)

:: Create remote connection.
echo. | %putty_path%plink.exe -load "%putty_profile%" "docker exec ApacheSolr /opt/solr/bin/solr create_core -c %solr_core% -d /opt/solr/server/solr/d7_search_api/conf/ && exit"

echo Your new Solr core is ready to use with the endpoint: /solr/%solr_core%.
pause
