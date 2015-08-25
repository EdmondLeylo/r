IF app_name() <> 'SQLCMD' RAISERROR('This script must be executed through SQLCMD', 20, 1) WITH LOG
:On Error Exit
SET NOCOUNT ON
SET XACT_ABORT ON;
GO
--Begin Transaction
BEGIN TRAN;
GO
:r $(path)DEVCME-930.sql
GO	
COMMIT TRAN;
GO
