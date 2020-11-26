@echo off
@setlocal enableextensions enabledelayedexpansion
@chcp 866
@color 02 
@cls
:: ########### help section #################
@IF /i "%~1"=="" (goto func_help)
@IF /i "%~1"=="/?" (goto func_help)
@IF /i "%~1"=="?" (goto func_help)
@IF /i "%~1"=="-h" (goto func_help)
@IF /i "%~1"=="help" (goto func_help)
:: ########### set var section ################
:start
@REG ADD "HKCU\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f >NUL 2>&1
@set ps_exec=psexec\PsExec.exe
@set R_HOST=%~1
@IF "%~1"=="" (@set /p R_HOST="'R_HOST': ")
@set R_USER=%~2
@IF "%~2"=="" (@set /p R_USER="'R_USER': ")
@set R_PWD=%~3
@IF "%~3"=="" (@set /p R_PWD="'R_PWD': ")
@set R_CMD=%~4
@IF "%~4"=="" (@set /p R_CMD="'R_CMD': ")
@set HHMMSS=12:00:00
:: ############ body execution section ###########
@echo.
@echo ----------------------------------------------------
@echo.
@echo ::PSEXEC: remote administration tools...
@echo.
@echo ----------------------------------------------------
@echo ::Start session current time %TIME%...
@echo ----------------------------------------------------
@echo.
call :get_ping_host
If %errorlevel% equ 0 (
   @echo Ping %R_HOST%  Online
   %ps_exec% \\%R_HOST% -u %R_USER% -p %R_PWD% %R_CMD%
) Else (
	@echo Ping %R_HOST%  Offline
)	
call :get_ping_host
If %errorlevel% equ 0 (
   @echo Ping %R_HOST%  Online
   call :get_cur_time
   @echo Create task for %R_HOST%, tasks planned !HHMMSS!
   %ps_exec% \\%R_HOST% -u %R_USER% -p %R_PWD% SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC ONCE /TN journal /TR "wevtutil cl Security" /ST !HHMMSS! /V1 /Z /F | FIND "Предупреждение"
   ::>NUL 2>&1
	If %errorlevel% equ 0 (
		echo Create task success!
	) Else (
		echo Create task failed!
	)
) Else (
	@echo Ping %R_HOST%  Offline
)
@echo ----------------------------------------------------
@echo.
@echo ::End session current time %time%...
@echo ----------------------------------------------------
@echo.
@pause
goto :endl

:get_ping_host
:: ping remote target and if ping is success then create tasks clear audit journal 
@ping "%R_HOST%" -n 1 -w 20 >NUL 2>&1
exit /b %errorlevel%

:get_cur_time
:: Set current time,
@set HH=!TIME:~0,2!
@IF !HH! LSS 10 (SET HH=0!HH:~1,1!)
@set MM=1!TIME:~3,2!
@set /a MM=!MM!-100
@set /a MM=!MM!+2
@IF !MM! LSS 10 (SET MM=0!MM:~0,1!)
@IF !MM! EQU 60 (SET MM=00 & SET /a HH=!HH!+1)
@set SS=1!TIME:~6,2!
@set /a SS=!SS!-100
@IF !SS! LSS 10 (SET SS=0!SS:~0,1!)
@set HHMMSS=!HH!:!MM!:!SS!
exit /b 0

:func_help
::echo help
@echo %0 R_HOST R_USER R_PWD R_CMD
@echo R_HOST - ip address server
@echo R_USER - remote host username
@echo R_PWD - remote host password 
@echo R_CMD - remote host command (batch,script,execution file etc.)
@set /p Q="Continue Y\N? "
@IF /I "%Q%"=="y" (call :start)

:endl
:: end batch file
Endlocal
@exit /b 0  
