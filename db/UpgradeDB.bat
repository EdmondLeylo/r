@ECHO off

IF "%~1"=="" (
SET ServerName=EDMOND-PC\edmond
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



SET DB_INFO=TRUE
IF [%ServerName%] == [] SET DB_INFO=FALSE
IF [%DBName%] == [] SET DB_INFO=FALSE
IF "%DB_INFO%" == "FALSE" (
	SET ERROR_MSG=Error: Please provide the required missing info ServerName\DBName
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo :::::%ERROR_MSG%:::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	IF NOT "%~1"=="" ( exit /b 2 )
	GOTO END
)



SET INTEGRATED_SECURITY=FALSE
IF [%ServerName%] == [] SET INTEGRATED_SECURITY=TRUE
IF [%Password%] == [] SET INTEGRATED_SECURITY=TRUE

SET ReleaseDIR=%~dp0
SET ReleaseFolder=%ReleaseDIR:~0,-1%

IF "%ReleaseNumber%" == "" (for %%f IN ("%ReleaseFolder%") DO SET ReleaseNumber=%%~nxf)

IF NOT EXIST "%ReleaseDIR%index.txt" (
	SET ERROR_MSG=Error: index.txt was not found. The DB upgrade has terminated
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: %ERROR_MSG%  :::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	IF NOT "%~1"=="" ( exit /b 3 )
	GOTO END

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
FOR /F "usebackq tokens=* delims=" %%x in ("%ReleaseDIR%index.txt") DO (
	@ECHO :r $^(path^)%%x>> "%ReleaseScriptFile%"
	@ECHO GO>> "%ReleaseScriptFile%"	
)
@ECHO COMMIT TRAN;>> "%ReleaseScriptFile%"
@ECHO GO>> "%ReleaseScriptFile%"

IF NOT EXIST "%ReleaseScriptFile%" (
	SET ERROR_MSG=Error creating %ReleaseFileName%. The DB upgrade has terminated
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: %ERROR_MSG%  ::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	IF NOT "%~1"=="" ( exit /b 4 )
	GOTO END

)

IF "%INTEGRATED_SECURITY%" == "TRUE" (	
    sqlcmd -S %ServerName% -d %DBName% -i "%ReleaseScriptFile%" -v path="%ReleaseDIR%"
)ELSE (	
	sqlcmd -S %ServerName% -d %DBName% -i "%ReleaseScriptFile%" -v path="%ReleaseDIR%"	-U %Username% -P %Password%
)

		
	IF ERRORLEVEL 1 GOTO err_handler

	IF "%INTEGRATED_SECURITY%" == "TRUE" (			
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 1);"	
	)ELSE (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 1);"	 -U %Username% -P %Password%
	)	
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: DB upgrade successful :::::::::::::::::::::::::::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	GOTO :END

	:err_handler
	
	IF "%INTEGRATED_SECURITY%" == "TRUE" (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 0);"
	)ELSE (		
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%ReleaseNumber%', 0);"  -U %Username% -P %Password%
	)
	SET ERROR_MSG=DB upgrade failed. The changes are Rolled back		
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: %ERROR_MSG% ::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	
	IF NOT "%~1"=="" ( exit /b 5 )

	:END
	

