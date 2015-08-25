@ECHO off

set ReleaseNumber="R191"
set WEBADMIN_HOME=..\webAdmin
set WEBAPI_HOME=..\WebAPI
set INTERNALAPI_HOME=..\InternalAPI
set THREADS_HOME=..\Threads
set THREADS_CONFIG_DIR=%OFFER_SERVICE_ENV_TYPE%\OfferService
set DB_DIR=DB

IF "%OFFER_SERVICE_ENV_TYPE%" == "DEV" (
	set _DeploySetParametersFile=DEV/setParam.xml
) ELSE IF "%OFFER_SERVICE_ENV_TYPE%" == "INT" (
	set _DeploySetParametersFile=INT/setParam.xml
) ELSE IF "%OFFER_SERVICE_ENV_TYPE%" == "PROD" (
	set _DeploySetParametersFile=PROD/setParam.xml
) ELSE IF "%OFFER_SERVICE_ENV_TYPE%" == "LOCAL" (
	set _DeploySetParametersFile=LOCAL/setParam.xml
) ELSE (
	goto :SETOSENVPATH
)

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo ::::: This script will install Offer Service applications to ::::::::
echo ::::::::::::::::::::::::---------::::::::::::::::::::::::::::::::::::
echo ":::::::::::::::::::::::   %OFFER_SERVICE_ENV_TYPE%   :::::::::::::::::::::::::::::::::::"
echo ::::::::::::::::::::::::---------::::::::::::::::::::::::::::::::::::
echo ::::: 1) WebAdmin :::::::::::::::::::::::::::::::::::::::::::::::::::
echo ::::: 2) WebAPI :::::::::::::::::::::::::::::::::::::::::::::::::::::
echo ::::: 3) InternalAPI ::::::::::::::::::::::::::::::::::::::::::::::::
echo ::::: 4) OfferService Windows Service :::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo Note: The script will pause waiting for a key press before moving on:
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo "Ready to deploy WebAdmin application..."
pause
call %WEBADMIN_HOME%\Kikai.WebAdmin.deploy.cmd /Y

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::: Done Deploying WebAdmin ::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo "Ready to deploy WebAPI..."
pause
call %WEBAPI_HOME%\Kikai.WebAPI.deploy.cmd /Y

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::: Done Deploying WebAPI ::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo "Ready to deploy InternalAPI..."
pause
call %INTERNALAPI_HOME%\Kikai.InternalAPI.deploy.cmd /Y

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::: Done Deploying InternalAPI :::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo "Ready to deploy OfferService Windows Service..."
pause
echo "Copying %OFFER_SERVICE_ENV_TYPE%" configuration files..."
xcopy /Y %THREADS_CONFIG_DIR%\* %THREADS_HOME%\
call %THREADS_HOME%\installOSWS.bat

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::: Done Installing OfferService Windows Service :::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo "Ready to upgrade the database to the latest version..."
pause

%DB_DIR%\UpgradeDbWrapper.exe %_DeploySetParametersFile% "KikaiDB-Web.config Connection String" "%DB_DIR%\UpgradeDB.bat"

echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::: Done Upgrading the database to the latest version ::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
pause

goto :END

:SETOSENVPATH
echo "The environment variable OFFER_SERVICE_ENV_TYPE is not set properly"
echo "Allowed values are DEV, INT and PROD"
echo "Value found is %OFFER_SERVICE_ENV_TYPE%
pause

:END