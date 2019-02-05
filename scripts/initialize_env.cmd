@echo off
Setlocal EnableDelayedExpansion
title Initialize local environment

:: Setup environment variables/configs
call %~dp0\config\config.cmd

set error=0
if "%ppk_private_key%" == "" (
  echo ppk_private_key should be set!
  set error=1
)
if "%proxy_username%" == "" (
  echo proxy_username should be set!
  set error=1
)
if "%proxy_hostname%" == "" (
  echo proxy_hostname should be set!
  set error=1
)
if "%proxy_port_dec%" == "" (
  echo proxy_port_dec should be set!
  set error=1
)
if "!proxy_password!" == "" (
  echo proxy_password should be set!
  set error=1
)
if "%aws_access_key_id%" == "" (
  echo aws_access_key_id should be set!
  set error=1
)
if "%aws_secret_access_key%" == "" (
  echo aws_secret_access_key should be set!
  set error=1
)

:: If there's missing data terminate the script.
if "%error%" == "1" (
  pause
  exit /b 4
)

echo Setting up PROXY settings...
:: Setting up proxy for aws-cli
set proxy_string=http://%proxy_username%:!proxy_password!@%proxy_hostname%:%proxy_port_dec%

:: Set for the current session (only required for first run)
set HTTP_PROXY="!proxy_string!"
set HTTPS_PROXY="!proxy_string!"
:: Set globaly
setx HTTP_PROXY "!proxy_string!"
setx HTTPS_PROXY "!proxy_string!"

echo Setting up Amazon Console (aws cli)...
:: Setup AWS CLI.
if not exist "%userprofile%\.aws\" mkdir %userprofile%\.aws\

:: Create the credentials file for AWS CLI.
echo [default] > %userprofile%\.aws\credentials
echo aws_access_key_id = %aws_access_key_id% >> %userprofile%\.aws\credentials
echo aws_secret_access_key = %aws_secret_access_key% >> %userprofile%\.aws\credentials

:: Create the config file for AWS CLI.
echo [default] > %userprofile%\.aws\config
echo region = %region% >> %userprofile%\.aws\config

:: Setup PuTTY profile for later connection
echo Generating import reg file

call %~dp0\helpers\string2hex.cmd %ppk_private_key%

echo Windows Registry Editor Version 5.00 > "%temp_regfile_name%"
echo. >> "%temp_regfile_name%"
echo [HKEY_USERS\%user_sid%\SOFTWARE\Microsoft\AppV\Client\Packages\%package_id%\REGISTRY\USER\%user_sid%\Software\SimonTatham\PuTTY\Sessions\%putty_profile%] >> "%temp_regfile_name%"
echo @=hex(40000): >> "%temp_regfile_name%"
echo "Present"=dword:00000001 >> "%temp_regfile_name%"
echo "HostName"="" >> "%temp_regfile_name%"
echo "LogFileName"="putty.log" >> "%temp_regfile_name%"
echo "LogType"=dword:00000000 >> "%temp_regfile_name%"
echo "LogFileClash"=dword:ffffffff >> "%temp_regfile_name%"
echo "LogFlush"=dword:00000001 >> "%temp_regfile_name%"
echo "SSHLogOmitPasswords"=dword:00000001 >> "%temp_regfile_name%"
echo "SSHLogOmitData"=dword:00000000 >> "%temp_regfile_name%"
echo "Protocol"="ssh" >> "%temp_regfile_name%"
echo "PortNumber"=dword:00000016 >> "%temp_regfile_name%"
echo "CloseOnExit"=dword:00000001 >> "%temp_regfile_name%"
echo "WarnOnClose"=dword:00000001 >> "%temp_regfile_name%"
echo "PingInterval"=dword:00000000 >> "%temp_regfile_name%"
echo "PingIntervalSecs"=dword:00000005 >> "%temp_regfile_name%"
echo "TCPNoDelay"=dword:00000001 >> "%temp_regfile_name%"
echo "TCPKeepalives"=dword:00000000 >> "%temp_regfile_name%"
echo "TerminalType"="xterm" >> "%temp_regfile_name%"
echo "TerminalSpeed"="38400,38400" >> "%temp_regfile_name%"
echo "TerminalModes"="CS7=A,CS8=A,DISCARD=A,DSUSP=A,ECHO=A,ECHOCTL=A,ECHOE=A,ECHOK=A,ECHOKE=A,ECHONL=A,EOF=A,EOL=A,EOL2=A,ERASE=A,FLUSH=A,ICANON=A,ICRNL=A,IEXTEN=A,IGNCR=A,IGNPAR=A,IMAXBEL=A,INLCR=A,INPCK=A,INTR=A,ISIG=A,ISTRIP=A,IUCLC=A,IUTF8=A,IXANY=A,IXOFF=A,IXON=A,KILL=A,LNEXT=A,NOFLSH=A,OCRNL=A,OLCUC=A,ONLCR=A,ONLRET=A,ONOCR=A,OPOST=A,PARENB=A,PARMRK=A,PARODD=A,PENDIN=A,QUIT=A,REPRINT=A,START=A,STATUS=A,STOP=A,SUSP=A,SWTCH=A,TOSTOP=A,WERASE=A,XCASE=A" >> "%temp_regfile_name%"
echo "AddressFamily"=dword:00000000 >> "%temp_regfile_name%"
echo "ProxyExcludeList"="" >> "%temp_regfile_name%"
echo "ProxyDNS"=dword:00000001 >> "%temp_regfile_name%"
echo "ProxyLocalhost"=dword:00000000 >> "%temp_regfile_name%"
echo "ProxyMethod"=dword:00000003 >> "%temp_regfile_name%"
echo "ProxyHost"="%proxy_hostname%" >> "%temp_regfile_name%"
echo "ProxyPort"=dword:%proxy_port% >> "%temp_regfile_name%"
echo "ProxyUsername"="%proxy_username%" >> "%temp_regfile_name%"
echo "ProxyPassword"="!proxy_password!" >> "%temp_regfile_name%"
echo "ProxyTelnetCommand"="connect %host %port\\n" >> "%temp_regfile_name%"
echo "ProxyLogToTerm"=dword:00000001 >> "%temp_regfile_name%"
echo "Environment"="" >> "%temp_regfile_name%"
echo "UserName"="ec2-user" >> "%temp_regfile_name%"
echo "UserNameFromEnvironment"=dword:00000000 >> "%temp_regfile_name%"
echo "LocalUserName"="" >> "%temp_regfile_name%"
echo "NoPTY"=dword:00000000 >> "%temp_regfile_name%"
echo "Compression"=dword:00000000 >> "%temp_regfile_name%"
echo "TryAgent"=dword:00000001 >> "%temp_regfile_name%"
echo "AgentFwd"=dword:00000001 >> "%temp_regfile_name%"
echo "GssapiFwd"=dword:00000000 >> "%temp_regfile_name%"
echo "ChangeUsername"=dword:00000000 >> "%temp_regfile_name%"
echo "Cipher"="aes,chacha20,blowfish,3des,WARN,arcfour,des" >> "%temp_regfile_name%"
echo "KEX"="ecdh,dh-gex-sha1,dh-group14-sha1,rsa,WARN,dh-group1-sha1" >> "%temp_regfile_name%"
echo "HostKey"="ed25519,ecdsa,rsa,dsa,WARN" >> "%temp_regfile_name%"
echo "RekeyTime"=dword:0000003c >> "%temp_regfile_name%"
echo "RekeyBytes"="1G" >> "%temp_regfile_name%"
echo "SshNoAuth"=dword:00000000 >> "%temp_regfile_name%"
echo "SshBanner"=dword:00000001 >> "%temp_regfile_name%"
echo "AuthTIS"=dword:00000000 >> "%temp_regfile_name%"
echo "AuthKI"=dword:00000001 >> "%temp_regfile_name%"
echo "AuthGSSAPI"=dword:00000001 >> "%temp_regfile_name%"
echo "GSSLibs"="gssapi32,sspi,custom" >> "%temp_regfile_name%"
echo "GSSCustom"="" >> "%temp_regfile_name%"
echo "SshNoShell"=dword:00000000 >> "%temp_regfile_name%"
echo "SshProt"=dword:00000003 >> "%temp_regfile_name%"
echo "LogHost"="" >> "%temp_regfile_name%"
echo "SSH2DES"=dword:00000000 >> "%temp_regfile_name%"
echo "PublicKeyFile"=hex(400001):5b,00,7b,00,50,00,72,00,6f,00,66,00,69,00,6c,00,65,00,7d,00,5d,00,5c,00,2e,00,73,00,73,00,68,00,5c,00,%hex%00,00 >> "%temp_regfile_name%"
echo "RemoteCommand"="" >> "%temp_regfile_name%"
echo "RFCEnviron"=dword:00000000 >> "%temp_regfile_name%"
echo "PassiveTelnet"=dword:00000000 >> "%temp_regfile_name%"
echo "BackspaceIsDelete"=dword:00000001 >> "%temp_regfile_name%"
echo "RXVTHomeEnd"=dword:00000000 >> "%temp_regfile_name%"
echo "LinuxFunctionKeys"=dword:00000000 >> "%temp_regfile_name%"
echo "NoApplicationKeys"=dword:00000000 >> "%temp_regfile_name%"
echo "NoApplicationCursors"=dword:00000000 >> "%temp_regfile_name%"
echo "NoMouseReporting"=dword:00000000 >> "%temp_regfile_name%"
echo "NoRemoteResize"=dword:00000000 >> "%temp_regfile_name%"
echo "NoAltScreen"=dword:00000000 >> "%temp_regfile_name%"
echo "NoRemoteWinTitle"=dword:00000000 >> "%temp_regfile_name%"
echo "NoRemoteClearScroll"=dword:00000000 >> "%temp_regfile_name%"
echo "RemoteQTitleAction"=dword:00000001 >> "%temp_regfile_name%"
echo "NoDBackspace"=dword:00000000 >> "%temp_regfile_name%"
echo "NoRemoteCharset"=dword:00000000 >> "%temp_regfile_name%"
echo "ApplicationCursorKeys"=dword:00000000 >> "%temp_regfile_name%"
echo "ApplicationKeypad"=dword:00000000 >> "%temp_regfile_name%"
echo "NetHackKeypad"=dword:00000000 >> "%temp_regfile_name%"
echo "AltF4"=dword:00000001 >> "%temp_regfile_name%"
echo "AltSpace"=dword:00000000 >> "%temp_regfile_name%"
echo "AltOnly"=dword:00000000 >> "%temp_regfile_name%"
echo "ComposeKey"=dword:00000000 >> "%temp_regfile_name%"
echo "CtrlAltKeys"=dword:00000001 >> "%temp_regfile_name%"
echo "TelnetKey"=dword:00000000 >> "%temp_regfile_name%"
echo "TelnetRet"=dword:00000001 >> "%temp_regfile_name%"
echo "LocalEcho"=dword:00000002 >> "%temp_regfile_name%"
echo "LocalEdit"=dword:00000002 >> "%temp_regfile_name%"
echo "Answerback"="PuTTY" >> "%temp_regfile_name%"
echo "AlwaysOnTop"=dword:00000000 >> "%temp_regfile_name%"
echo "FullScreenOnAltEnter"=dword:00000000 >> "%temp_regfile_name%"
echo "HideMousePtr"=dword:00000000 >> "%temp_regfile_name%"
echo "SunkenEdge"=dword:00000000 >> "%temp_regfile_name%"
echo "WindowBorder"=dword:00000001 >> "%temp_regfile_name%"
echo "CurType"=dword:00000000 >> "%temp_regfile_name%"
echo "BlinkCur"=dword:00000000 >> "%temp_regfile_name%"
echo "Beep"=dword:00000001 >> "%temp_regfile_name%"
echo "BeepInd"=dword:00000000 >> "%temp_regfile_name%"
echo "BellWaveFile"="" >> "%temp_regfile_name%"
echo "BellOverload"=dword:00000001 >> "%temp_regfile_name%"
echo "BellOverloadN"=dword:00000005 >> "%temp_regfile_name%"
echo "BellOverloadT"=dword:000007d0 >> "%temp_regfile_name%"
echo "BellOverloadS"=dword:00001388 >> "%temp_regfile_name%"
echo "ScrollbackLines"=dword:000007d0 >> "%temp_regfile_name%"
echo "DECOriginMode"=dword:00000000 >> "%temp_regfile_name%"
echo "AutoWrapMode"=dword:00000001 >> "%temp_regfile_name%"
echo "LFImpliesCR"=dword:00000000 >> "%temp_regfile_name%"
echo "CRImpliesLF"=dword:00000000 >> "%temp_regfile_name%"
echo "DisableArabicShaping"=dword:00000000 >> "%temp_regfile_name%"
echo "DisableBidi"=dword:00000000 >> "%temp_regfile_name%"
echo "WinNameAlways"=dword:00000001 >> "%temp_regfile_name%"
echo "WinTitle"="" >> "%temp_regfile_name%"
echo "TermWidth"=dword:00000050 >> "%temp_regfile_name%"
echo "TermHeight"=dword:00000018 >> "%temp_regfile_name%"
echo "Font"="Courier New" >> "%temp_regfile_name%"
echo "FontIsBold"=dword:00000000 >> "%temp_regfile_name%"
echo "FontCharSet"=dword:00000000 >> "%temp_regfile_name%"
echo "FontHeight"=dword:0000000a >> "%temp_regfile_name%"
echo "FontQuality"=dword:00000000 >> "%temp_regfile_name%"
echo "FontVTMode"=dword:00000004 >> "%temp_regfile_name%"
echo "UseSystemColours"=dword:00000000 >> "%temp_regfile_name%"
echo "TryPalette"=dword:00000000 >> "%temp_regfile_name%"
echo "ANSIColour"=dword:00000001 >> "%temp_regfile_name%"
echo "Xterm256Colour"=dword:00000001 >> "%temp_regfile_name%"
echo "BoldAsColour"=dword:00000001 >> "%temp_regfile_name%"
echo "Colour0"="187,187,187" >> "%temp_regfile_name%"
echo "Colour1"="255,255,255" >> "%temp_regfile_name%"
echo "Colour2"="0,0,0" >> "%temp_regfile_name%"
echo "Colour3"="85,85,85" >> "%temp_regfile_name%"
echo "Colour4"="0,0,0" >> "%temp_regfile_name%"
echo "Colour5"="0,255,0" >> "%temp_regfile_name%"
echo "Colour6"="0,0,0" >> "%temp_regfile_name%"
echo "Colour7"="85,85,85" >> "%temp_regfile_name%"
echo "Colour8"="187,0,0" >> "%temp_regfile_name%"
echo "Colour9"="255,85,85" >> "%temp_regfile_name%"
echo "Colour10"="0,187,0" >> "%temp_regfile_name%"
echo "Colour11"="85,255,85" >> "%temp_regfile_name%"
echo "Colour12"="187,187,0" >> "%temp_regfile_name%"
echo "Colour13"="255,255,85" >> "%temp_regfile_name%"
echo "Colour14"="0,0,187" >> "%temp_regfile_name%"
echo "Colour15"="85,85,255" >> "%temp_regfile_name%"
echo "Colour16"="187,0,187" >> "%temp_regfile_name%"
echo "Colour17"="255,85,255" >> "%temp_regfile_name%"
echo "Colour18"="0,187,187" >> "%temp_regfile_name%"
echo "Colour19"="85,255,255" >> "%temp_regfile_name%"
echo "Colour20"="187,187,187" >> "%temp_regfile_name%"
echo "Colour21"="255,255,255" >> "%temp_regfile_name%"
echo "RawCNP"=dword:00000000 >> "%temp_regfile_name%"
echo "PasteRTF"=dword:00000000 >> "%temp_regfile_name%"
echo "MouseIsXterm"=dword:00000000 >> "%temp_regfile_name%"
echo "RectSelect"=dword:00000000 >> "%temp_regfile_name%"
echo "MouseOverride"=dword:00000001 >> "%temp_regfile_name%"
echo "Wordness0"="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" >> "%temp_regfile_name%"
echo "Wordness32"="0,1,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1" >> "%temp_regfile_name%"
echo "Wordness64"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,2" >> "%temp_regfile_name%"
echo "Wordness96"="1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1" >> "%temp_regfile_name%"
echo "Wordness128"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1" >> "%temp_regfile_name%"
echo "Wordness160"="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1" >> "%temp_regfile_name%"
echo "Wordness192"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2" >> "%temp_regfile_name%"
echo "Wordness224"="2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2" >> "%temp_regfile_name%"
echo "LineCodePage"="UTF-8" >> "%temp_regfile_name%"
echo "CJKAmbigWide"=dword:00000000 >> "%temp_regfile_name%"
echo "UTF8Override"=dword:00000001 >> "%temp_regfile_name%"
echo "Printer"="" >> "%temp_regfile_name%"
echo "CapsLockCyr"=dword:00000000 >> "%temp_regfile_name%"
echo "ScrollBar"=dword:00000001 >> "%temp_regfile_name%"
echo "ScrollBarFullScreen"=dword:00000000 >> "%temp_regfile_name%"
echo "ScrollOnKey"=dword:00000000 >> "%temp_regfile_name%"
echo "ScrollOnDisp"=dword:00000001 >> "%temp_regfile_name%"
echo "EraseToScrollback"=dword:00000001 >> "%temp_regfile_name%"
echo "LockSize"=dword:00000000 >> "%temp_regfile_name%"
echo "BCE"=dword:00000001 >> "%temp_regfile_name%"
echo "BlinkText"=dword:00000000 >> "%temp_regfile_name%"
echo "X11Forward"=dword:00000000 >> "%temp_regfile_name%"
echo "X11Display"="" >> "%temp_regfile_name%"
echo "X11AuthType"=dword:00000001 >> "%temp_regfile_name%"
echo "X11AuthFile"="" >> "%temp_regfile_name%"
echo "LocalPortAcceptAll"=dword:00000000 >> "%temp_regfile_name%"
echo "RemotePortAcceptAll"=dword:00000000 >> "%temp_regfile_name%"
echo "PortForwardings"="L22=github.com:22,L222=localhost:22,L3306=localhost:3306,L8080=localhost:8080,R9000=localhost:9000" >> "%temp_regfile_name%"
echo "BugIgnore1"=dword:00000000 >> "%temp_regfile_name%"
echo "BugPlainPW1"=dword:00000000 >> "%temp_regfile_name%"
echo "BugRSA1"=dword:00000000 >> "%temp_regfile_name%"
echo "BugIgnore2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugHMAC2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugDeriveKey2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugRSAPad2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugPKSessID2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugRekey2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugMaxPkt2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugOldGex2"=dword:00000000 >> "%temp_regfile_name%"
echo "BugWinadj"=dword:00000000 >> "%temp_regfile_name%"
echo "BugChanReq"=dword:00000000 >> "%temp_regfile_name%"
echo "StampUtmp"=dword:00000001 >> "%temp_regfile_name%"
echo "LoginShell"=dword:00000001 >> "%temp_regfile_name%"
echo "ScrollbarOnLeft"=dword:00000000 >> "%temp_regfile_name%"
echo "BoldFont"="" >> "%temp_regfile_name%"
echo "BoldFontIsBold"=dword:00000000 >> "%temp_regfile_name%"
echo "BoldFontCharSet"=dword:00000000 >> "%temp_regfile_name%"
echo "BoldFontHeight"=dword:00000000 >> "%temp_regfile_name%"
echo "WideFont"="" >> "%temp_regfile_name%"
echo "WideFontIsBold"=dword:00000000 >> "%temp_regfile_name%"
echo "WideFontCharSet"=dword:00000000 >> "%temp_regfile_name%"
echo "WideFontHeight"=dword:00000000 >> "%temp_regfile_name%"
echo "WideBoldFont"="" >> "%temp_regfile_name%"
echo "WideBoldFontIsBold"=dword:00000000 >> "%temp_regfile_name%"
echo "WideBoldFontCharSet"=dword:00000000 >> "%temp_regfile_name%"
echo "WideBoldFontHeight"=dword:00000000 >> "%temp_regfile_name%"
echo "ShadowBold"=dword:00000000 >> "%temp_regfile_name%"
echo "ShadowBoldOffset"=dword:00000001 >> "%temp_regfile_name%"
echo "SerialLine"="COM1" >> "%temp_regfile_name%"
echo "SerialSpeed"=dword:00002580 >> "%temp_regfile_name%"
echo "SerialDataBits"=dword:00000008 >> "%temp_regfile_name%"
echo "SerialStopHalfbits"=dword:00000002 >> "%temp_regfile_name%"
echo "SerialParity"=dword:00000000 >> "%temp_regfile_name%"
echo "SerialFlowControl"=dword:00000001 >> "%temp_regfile_name%"
echo "WindowClass"="" >> "%temp_regfile_name%"
echo "ConnectionSharing"=dword:00000000 >> "%temp_regfile_name%"
echo "ConnectionSharingUpstream"=dword:00000001 >> "%temp_regfile_name%"
echo "ConnectionSharingDownstream"=dword:00000001 >> "%temp_regfile_name%"
echo "SSHManualHostKeys"="" >> "%temp_regfile_name%"

echo Importing PuTTY profile
reg import %temp_regfile_name%
echo Cleanup...
del %temp_regfile_name%
echo PuTTY profile was created successfully with %putty_profile% name.

if not exist config\cache\config.%cloud9_username%.cmd (
  echo No cache file fount for this environment, cache generation started.
  
  if not exist "config\cache\" mkdir config\cache\
  
  for /f "tokens=1-3,9 delims=	" %%i in ('aws ec2 describe-instances --filters "Name=tag:Name,Values=*%cloud9_username%*" --output text') do (
    if "%%i" == "INSTANCES" (
      set instance_id=%%l
    ) else if "%%i" == "TAGS" if "%%j" == "aws:cloud9:environment" (
      set environment_id=%%k
    )
  )
  
  echo set package_id=%package_id% > config\cache\config.%cloud9_username%.cmd
  echo set user_sid=%user_sid% >> config\cache\config.%cloud9_username%.cmd
  echo set instance_id=%instance_id% >> config\cache\config.%cloud9_username%.cmd
  echo set environment_id=%environment_id% >> config\cache\config.%cloud9_username%.cmd
)
