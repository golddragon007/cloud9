rem Store the string in chr.tmp file
set /P "=%~1" < NUL > chr.tmp

rem Create zero.tmp file with the same number of Ascii zero characters
for %%a in (chr.tmp) do fsutil file createnew zero.tmp %%~Za > NUL

rem Compare both files with FC /B and get the differences
set "hex="
for /F "skip=1 tokens=2" %%a in ('fc /B chr.tmp zero.tmp') do set "hex=!hex!%%a,00,"

del chr.tmp zero.tmp
