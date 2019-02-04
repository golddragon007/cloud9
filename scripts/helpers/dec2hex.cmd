@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SET DECnum=%1
SET NumDig=%2
SET Hexnum=

SET Powers=268435456 16777216 1048576 65536 4096 256 16 1
::=======================================================
::| WARNING! Limit is 2147483647 i.e. 7FFFFFF  WARNING! |
::=======================================================
SET /A Limit=%DECnum%/16
IF %Limit% LSS 0 ECHO Out of Range &GOTO :EOF
SET /A Val268435456=%DECnum% / 268435456
SET /A Mod268435456=%DECnum% %% 268435456
FOR %%A in (%Powers%) DO CALL:HEXcalc %%A
FOR %%A in (%Powers%) DO CALL:HEXchar %%A
FOR %%A in (%Powers%) DO SET Hexnum=!Hexnum!!Val%%A!
GOTO :EOF

:HEXcalc
IF %1==1 GOTO :EOF
SET /A Div=%1 /16
SET /A Val%Div%=!Mod%1! / %Div%
SET /A Mod%Div%=!Mod%1! %% %Div%
GOTO :EOF

:HEXchar
IF !Val%1!==10 SET Val%1=A
IF !Val%1!==11 SET Val%1=B
IF !Val%1!==12 SET Val%1=C
IF !Val%1!==13 SET Val%1=D
IF !Val%1!==14 SET Val%1=E
IF !Val%1!==15 SET Val%1=F
GOTO :EOF