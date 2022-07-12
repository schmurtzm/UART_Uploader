@echo off
setlocal enabledelayedexpansion

TITLE UART Uploader - by Schmurtz
set SourceFile=%~1
set TargetDirectory=%~2
set CurrentCom=%~3
set SerialSpeed=%~4
set Additionalarg=%5


:: Modify these options to avoid asking at each run
::set SerialSpeed=115200
::set SourceFile=test.txt
::set TargetDirectory=/tmp
::set CurrentCom=COM3



:: We get first argument : source file 
REM if NOT "%SourceFile%"=="" goto SetTargetDirectory
REM if defined SourceFile (echo yessssss) else (echo Noooooo) 
if NOT defined SourceFile (goto SetSourceFile) 
if "%SourceFile:"=%"=="/?" (goto help) else (goto SetSourceFile)

:help
cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
echo.
echo     Usage:    UART_Uploader "file_path" "folder_destination" "com_port" "serial_speed" [/r] or [/s]
echo                 /r = 'run now' 
echo                 /s = 'silent' : no user interction, upload window is automatically killed after 5 seconds
echo.
echo     For help:    SerialSend /? 
echo.
echo     Example:     Schmurtz_ESP_Flasher.bat "MyBinary" "/tmp/target directory" com3 115200 /r /s
echo.
echo.
exit /B  
  
:SetSourceFile
:: if source file already defined, we go to next step
if defined SourceFile (goto SetTargetDirectory) 
cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
echo --------------------------------------------------------------------------------
echo. & echo Enter file path or enter "ff" to open file browser or drag a file here:
echo  Example : c:\logo.jpg
echo.
echo --------------------------------------------------------------------------------





set /p SourceFile=


if x%SourceFile%==x goto SetSourceFile
if x%SourceFile%==xff call :filedialog file
:: SourceFile variable without quotes :
set SourceFile=%SourceFile:"=%





:SetTargetDirectory
if defined TargetDirectory (goto SetCOM_Port) 
cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
echo --------------------------------------------------------------------------------
echo. & echo Enter the target directory without quotes & echo.
echo  Example : /tmp
echo.
echo --------------------------------------------------------------------------------

set /p TargetDirectory=
cls
if "%TargetDirectory%"=="" goto SetTargetDirectory


:SetCOM_Port

if defined CurrentCom (goto SetCOM_Speed) 
:: empty com variable
set "com="

set Counter=0
:: wmic /format:list strips trailing spaces (at least for path win32_pnpentity)
for /f "tokens=1* delims==" %%I in ('wmic path win32_pnpentity get caption /format:list ^| find "(COM"') do (
	set "str=%%~J"
	set "num=!str:*(COM=!"
	set "num=!num:)=!"
	set "CurrentCom=COM!num!"
	set /a Counter=!Counter! + 1
)

if "%Counter%"=="1" echo Only one port COM detected : %CurrentCom% & timeout 2 > NUL & Goto :SetCOM_Speed
echo Number of ports COM detected : %Counter% & timeout 2 > NUL


cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
echo --------------------------------------------------------------------------------
echo. & echo List of current COM ports : & echo.
wmic path win32_pnpentity get caption | find "(COM"
echo.
echo --------------------------------------------------------------------------------

echo. & echo Please enter the number of your ESP COM port (only the number, without "COM")
echo.
echo --------------------------------------------------------------------------------
set /p CurrentCom=
set CurrentCom=COM%CurrentCom%
cls
if "%CurrentCom%"=="" (
echo. & echo This will let ESPtool flash an ESP connected to your computer.
echo Do not use this if you have another ESP device connected (it could flash the wrong one !^) & echo.
set CurrentCom=auto
pause
)

if "%CurrentCom%"=="auto" (
	set ComCmd=
) ELSE (
	set ComCmd=--port COM%com%
)



:SetCOM_Speed
if defined SerialSpeed (goto Menu)

cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
echo --------------------------------------------------------------------------------
echo. & echo Set the serial speed (bit/s) : & echo.
echo Press enter to set to default value : 115200
echo.
echo --------------------------------------------------------------------------------

echo. & echo Please enter the number of your ESP COM port (only the number, without "COM")
echo.
echo --------------------------------------------------------------------------------
set /p SerialSpeed=

cls
if "%SerialSpeed%"=="" set SerialSpeed=115200



:Menu

if /i "%Additionalarg%"=="/r" (set Additionalarg=done& goto :StartUpload)
if /i "%Additionalarg%"=="/s" (goto :StartUpload)
set userinp=
cls
Echo+
Echo ================================================================================
Echo    UART Uploader - by Schmurtz                                      Version: 1.0
Echo ================================================================================
Echo+
Tools\nircmdc setconsolecolor 2 1
Tools\echox -c 01 -n "Source  file     :"
echo   %SourceFile:"=%
Tools\echox -c 01 -n "Target Directory :"
echo   %TargetDirectory%
Tools\echox -c 01 -n "Current COM port :"
echo   %CurrentCom% at %SerialSpeed% bit/s
Tools\nircmdc setconsolecolor 7 1
echo+
echo Hello %USERNAME%, what do you want to do?  
echo+
Tools\echox -c 18 "   ------------------- Serial / UART Commands ------------------"
echo    1) Upload Current file to Target Directory
echo    2) Display content  of the current file on the UART device
echo    3) Start putty on %CurrentCom% 
Tools\echox -c 18 "   --------------- Specific Miyoo Mini Commands ----------------"
echo    4) Restart MainUI
echo    5) Reboot Miyoo Mini
Tools\echox -c 18 "   ------------------------- Settings --------------------------"
echo    F) Choose another File ("FF" to browse for a file)
echo    D) Choose another Target Directory
echo    C) Choose another COM port
echo    S) Choose another COM speed
Tools\echox -c 18 "    -------------------------------------------------------------"
echo    Q) Exit
echo+
::Menu Choose Option Code
set /p userinp= ^> Select Option : 


if /i "%userinp%"=="1" goto :StartUpload
if /i "%userinp%"=="2" goto :StartCat
if /i "%userinp%"=="3" start Tools\putty.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
if /i "%userinp%"=="4" call :CommandsLauncher "pkill -9  MainUI"
if /i "%userinp%"=="5" call :CommandsLauncher "reboot"
if /i "%userinp%"=="F" set "SourceFile=" & Goto SetSourceFile
if /i "%userinp%"=="FF" set "SourceFile=" & call :filedialog file
if /i "%userinp%"=="D" set "TargetDirectory=" & Goto SetTargetDirectory
if /i "%userinp%"=="C" set "CurrentCom=" & goto :SetCOM_Port
if /i "%userinp%"=="S" set "SerialSpeed=" & goto :SetCOM_Speed
if /i "%userinp%"=="Q" EXIT /B 2
goto :Menu


:: ===============================================================================================================================


:StartUpload
cls
echo ================================================================================
echo                                  Uploading ...
echo ================================================================================
echo+&echo+
Tools\nircmd.exe killprocess "PuTTY"
for /f "delims=" %%a in ('dir /s /b "%SourceFile%"') do set "SourceFilename=%%~nxa"
echo %SourceFilename%
echo echo> Commands.txt
echo DoneMsg=" ==================================== Upload done ==================================== ">> Commands.txt
echo echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;>> Commands.txt
echo cd "%TargetDirectory%">> Commands.txt
echo base64 -d ^<^<EOF ^> ^"%SourceFilename%^">> Commands.txt
echo Tools\base64.exe "%SourceFile%"
Tools\base64.exe "%SourceFile%">> Commands.txt
echo EOF>> Commands.txt
echo chmod +x "%SourceFilename%">> Commands.txt
echo echo;echo;echo  $DoneMsg >> Commands.txt
start "Uploading..." cmd /k color 0A  ^& type Commands.txt ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
echo cmd /k color 0A  ^& type Commands.txt ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
timeout 1 >NUL
::Tools\nircmd.exe win move ititle "Uploading..." 800 0 0 0
Tools\nircmd.exe win activate ititle "UART Uploader - by Schmurtz"
cls
echo ================================================================================
echo        press a key when upload seems finished to close the upload window		
echo ================================================================================
echo+&echo+
:: without /s arg , we make a pause
if /i "%Additionalarg%"=="/s" (set Additionalarg=done& timeout 5) else (pause)
Tools\nircmd.exe win close ititle "Uploading..."
if /i "%Additionalarg%"=="done" (EXIT /B 2)
goto :Menu

:: ===============================================================================================================================

:StartCat
cls
echo ================================================================================
echo                                  Display the content of the file ...
echo ================================================================================
echo+&echo+
Tools\nircmd.exe killprocess "PuTTY"

for /f "delims=" %%a in ('dir /s /b "%SourceFile%"') do set "SourceFilename=%%~nxa"
echo %SourceFilename%
echo echo> Commands.txt
echo cd "%TargetDirectory%">> Commands.txt
echo echo -e "\r\n\r\n\r\n">> Commands.txt
echo cat "%SourceFilename%">> Commands.txt


start "Display content" cmd /k color 0A  ^& type Commands.txt ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
timeout 1 >NUL
::Tools\nircmd.exe win move ititle "Uploading..." 800 0 0 0
Tools\nircmd.exe win activate ititle "UART Uploader - by Schmurtz"
cls
echo "Display content" cmd /k color 0A  ^& type Commands.txt ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
echo ================================================================================
echo        press a key when close the content file window
echo ================================================================================
echo+&echo+
pause
Tools\nircmd.exe win close ititle "Display content"

goto :Menu
start type Commands.txt  ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X


goto :Menu

:: ===============================================================================================================================

:CommandsLauncher
echo echo> Commands.txt
echo %~1>> Commands.txt
start "Remote Command" cmd /c type Commands.txt ^| Tools\plink.exe -serial %CurrentCom% -sercfg %SerialSpeed%,8,1,N,X
timeout 1 >NUL
Tools\nircmd.exe win activate ititle "UART Uploader - by Schmurtz"
cls
echo ================================================================================
echo        press a key when close the command window
echo ================================================================================
echo+&echo+
pause
Tools\nircmd.exe win close ititle "Remote Command"
goto :Menu
:: ===============================================================================================================================

:filedialog :: &file
setlocal 
set dialog="about:<input type=file id=FILE><script>FILE.click();new ActiveXObject
set dialog=%dialog%('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);
set dialog=%dialog%close();resizeTo(0,0);</script>"
for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
endlocal  & set %1=%file%

if NOT "%file%"=="""=" set SourceFile=%file%

goto :EOF






