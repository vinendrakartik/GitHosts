:: This script will first create a backup of the original or current hosts
:: file and save it in a file titled "hosts.skel"
::
:: If "hosts.skel" exists, the new hosts file with the customized unified hosts
:: will be copied to the proper path. Next, the DNS cache will be refreshed.
::
:: THIS BAT FILE MUST BE LAUNCHED WITH ADMINISTRATOR PRIVILEGES
@ECHO OFF
TITLE Update Hosts

:: Check if we are administrator. If not, exit immediately.
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %ERRORLEVEL% NEQ 0 (
    ECHO This script must be run with administrator privileges!
    ECHO Please launch command prompt as administrator. Exiting...
    EXIT /B 1
)

if not exist "%WINDIR%\System32\drivers\etc\hosts.skel" (
	COPY %WINDIR%\System32\drivers\etc\hosts %WINDIR%\System32\drivers\etc\hosts.skel
)
GOTO PNG
:Menu
cls
ECHO ==============  MENU  ===============
ECHO -------------------------------------
ECHO 1.	DOWNLOAD LATEST HOSTS
ECHO -------------------------------------
ECHO 2.	CHECK HOSTS
ECHO -------------------------------------
ECHO ==========PRESS 'Q' TO QUIT==========
SET INPUT=
SET /P INPUT=Choice::

IF /I '%INPUT%'=='1' GOTO STA
IF /I '%INPUT%'=='2' GOTO CHECK
IF /I '%INPUT%'=='Q' EXIT
ECHO ============INVALID INPUT============
ECHO -------------------------------------
ECHO Please select a number from the Main
echo Menu [1-2] or select 'Q' to quit.
ECHO -------------------------------------
ECHO ======PRESS ANY KEY TO CONTINUE======
GOTO:MENU

:STA
:: Update hosts file
cls
echo.
echo.
echo Downloading Latest Hosts
CSCript "D:\GitRepo\hosts\Updatehosts.vbs"  					>nul
if ERRORLEVEL = 1 ( echo Downloading Success. Copying the updated hosts) else (
echo Downloading Failed
pause
goto :MENU)
echo .
echo .
echo Copying Hosts
:: Move new hosts file in-place
COPY "D:\GitRepo\hosts\hosts" %WINDIR%\System32\drivers\etc\ 	>nul

echo.
echo.
echo Flushing DNS cache
:: Flush the DNS cache
ipconfig /flushdns 												>nul
REM ipconfig /renew 												>nul
pause
:png
cls
PING -n 1 www.google.com|find "Reply from " 					>NUL
IF NOT ERRORLEVEL 1 goto :MENU
IF     ERRORLEVEL 1 goto :TRYAGAIN	

:TRYAGAIN
echo Looks Like there Is NO INTERNET CONNECTION. Please CONNECT TO INTERNET and retry
pause

goto :png

:CHECK
PING -n 1 com-notice.info |find "Reply from " 					>NUL
IF NOT ERRORLEVEL 1 ( echo FAIL
pause 
goto :MENU)
IF     ERRORLEVEL 1 ( echo PASS 
pause 
goto :MENU)
