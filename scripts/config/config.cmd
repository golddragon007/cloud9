:: Configs
:: %username% - windows currently logged in user's user name

:: Set here your proxy password, in plain text. If you using ! character, then you need to escape it with ^^^ (^^^!). You may need to use for other special characters too.
set proxy_password=
:: Set your private ppk key here, it should be located in c:\Users\<your profile>\.ssh\ directory!
set ppk_private_key=
:: Proxy username.
set proxy_username=
:: Proxy host name/domain/ip.
set proxy_hostname=
:: Proxy port number in decimal format.
set proxy_port_dec=
:: Cloud 9 username.
set cloud9_username=
:: PuTTY profile name, as the PuTTY settings will be saved.
set putty_profile=Cloud9
:: This is the PuTTY's package id from the AppV, the script figures out if it's not set.
set package_id=
:: This is your windows' account's SID identifier, the script figures out if it's not set.
set user_sid=
:: This is required because after starting cloud 9 it won't appear on the Internet immediately. Should be an integer number.
set wait_for_server=10
:: This determinate if your cloud 9 currently running or not, it can change by the runtime.
set cold_start=0
:: Temp name of the file which will be created, imported and deleted for PuTTY configs
set temp_regfile_name=putty_profile_gen.reg

:: Load local config as an override.
call %~dp0\config.local.cmd

:: Config ends (some automatic configs run from here)

:: Convert port to hex format.
if not "%proxy_port_dec%" == "" (
  call %~dp0\..\helpers\dec2hex.cmd %proxy_port_dec%
  set proxy_port=%Hexnum%
)

echo Looking for SID and Package id
if "%user_sid%" == "" (
  for /f "tokens=2" %%i in ('whoami /user /fo table /nh') do set user_sid=%%i
)
if "%package_id%" == "" (
  for /f "tokens=1-3" %%A in ('reg query HKEY_USERS\%user_sid%\SOFTWARE\Classes\Applications\putty.exe\shell\open\command /t REG_SZ') do (
    set ValueName=%%A
    set ValueType=%%B
    set ValueValue=%%C
    if not "%%C" == "" goto registry_read_end
  )
  :registry_read_end
  for /f "tokens=10 delims=\" %%A in (%ValueValue%) do (
    set package_id=%%A
  )
)

:: Some checks
if "%putty_profile%" == "" (
  echo putty_profile should be set!
  exit /b 4
)
