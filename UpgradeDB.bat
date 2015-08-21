::@ECHO off

IF "%~1"=="" (
SET ServerName=TAREK-PC\MSSQLSERVER12
SET DBName=OffersII
::If using sql server Integrated Security keep the Username and Password empty
SET Username=
SET Password=
) ELSE (
SET ServerName=%1
SET DBName=%2
SET Username=%3
SET Password=%4
)

SET RESULT=false
IF [%Username%] == [] set RESULT=TRUE
IF [%Password%] == [] set RESULT=TRUE

SET ReleaseDIR=%~dp0
SET ReleaseFolder=%ReleaseDIR:~0,-1%
for %%f IN ("%ReleaseFolder%") DO SET ReleaseNumber=%%~nxf

IF NOT EXIST %ReleaseNumber%.txt (

	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: Error %ReleaseNumber%.txt was not found. The DB upgrade has terminated :::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	GOTO err_handler

)

SET ReleaseFileName=%ReleaseNumber%.sql
SET ReleaseScriptFile=%ReleaseDIR%%ReleaseFileName%

::COPY /y NUL EmptyFile.sql >NUL

@ECHO IF app_name() ^<^> 'SQLCMD' RAISERROR('This script must be executed through SQLCMD', 20, 1) WITH LOG> "%ReleaseScriptFile%"
@ECHO :On Error Exit>> "%ReleaseScriptFile%"
@ECHO SET NOCOUNT ON>> "%ReleaseScriptFile%"
@ECHO SET XACT_ABORT ON;>> "%ReleaseScriptFile%"
@ECHO GO>> "%ReleaseScriptFile%"
@ECHO --Begin Transaction>> "%ReleaseScriptFile%"
@ECHO BEGIN TRAN;>> "%ReleaseScriptFile%"
@ECHO GO>> "%ReleaseScriptFile%"
FOR /F "tokens=* delims=" %%x in (%ReleaseNumber%.txt) DO (
	@ECHO :r $^(path^)%%x>> "%ReleaseScriptFile%"
	@ECHO GO>> "%ReleaseScriptFile%"	
)
@ECHO COMMIT TRAN;>> "%ReleaseScriptFile%"
@ECHO GO>> "%ReleaseScriptFile%"

IF NOT EXIST %ReleaseScriptFile% (

	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: Error creating %ReleaseFileName%. The DB upgrade has terminated ::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	GOTO err_handler

)

IF "%RESULT%" == "TRUE" (	
    sqlcmd -S %ServerName% -d %DBName% -i "%ReleaseScriptFile%" -v path="%ReleaseDIR%"
)ELSE (	
	sqlcmd -S %ServerName% -d %DBName% -i "%ReleaseScriptFile%" -v path="%ReleaseDIR%"	-U %Username% -P %Password%
)

		
	IF ERRORLEVEL 1 GOTO err_handler

	IF "%RESULT%" == "TRUE" (			
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 1);"	
	)ELSE (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 1);"	 -U %Username% -P %Password%
	)	
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: DB upgrade successful :::::::::::::::::::::::::::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	GOTO :END

	:err_handler
	
	IF "%RESULT%" == "TRUE" (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 0);"
	)ELSE (		
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 0);"  -U %Username% -P %Password%
	)		
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: DB upgrade failed. The changes are Rolled back ::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	
	IF NOT "%~1"=="" ( exit /b 2 )

	:END
	
	
PAUSE
