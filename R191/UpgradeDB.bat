@ECHO off

:::::::::::::::::::::::::::::::
SET ServerName=EDMOND-PC\edmond
SET DBName=OffersII
SET FileName=R191.sql
::If not Integrated Security set the username and password
SET Username=sa
SET Password=leylo09
:::::::::::::::::::::::::::::::



SET RESULT=false
IF [%Username%] == [] set RESULT=TRUE
IF [%Password%] == [] set RESULT=TRUE
IF "%RESULT%" == "TRUE" (	
    sqlcmd  -S %ServerName% -d %DBName% -i "%~dp0"%FileName% -v path="%~dp0" 	
)ELSE (	
	sqlcmd  -S %ServerName% -d %DBName% -i "%~dp0"%FileName% -v path="%~dp0" -U %Username% -P %Password%
)

		
	IF ERRORLEVEL 1 GOTO err_handler

	IF "%RESULT%" == "TRUE" (			
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%FileName:~0,-4%', 1);"	
	)ELSE (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%FileName:~0,-4%', 1);"	 -U %Username% -P %Password%
	)	
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: DB upgrade successful :::::::::::::::::::::::::::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	GOTO :END

	:err_handler
	
	IF "%RESULT%" == "TRUE" (	
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%FileName:~0,-4%', 0);"
	)ELSE (		
		sqlcmd -S %ServerName% -d %DBName% -Q "INSERT INTO DBVersionHistory (VersionNumber, Status) VALUES('%FileName:~0,-4%', 0);"  -U %Username% -P %Password%
	)		
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
	echo ::::: DB upgrade failed. The changes are Rolled back ::::::::::::::::::.
	echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.
        
	:END
	
	
PAUSE

::Exit