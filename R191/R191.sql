IF app_name() <> 'SQLCMD'
     RAISERROR('This script must be executed through SQLCMD', 20, 1) WITH LOG

:On Error Exit
	 
SET NOCOUNT ON

SET XACT_ABORT ON;
GO

--Begin Transaction
BEGIN TRAN;
GO

--SQL Script files to be executed(file per ticket). Make sure that the attributes.sql is the last file to be executed

:r $(path)\DEVCME-868.sql
GO

:r $(path)\DEVCME-860.sql
GO

:r $(path)\DEVCME-753.sql
GO

:r $(path)\attributes.sql
GO


COMMIT TRAN;
GO

