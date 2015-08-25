-- If error encountered in previous batch (DLL batch), we need to stop executing the subsequent batches. By default,
-- subsequent batches will execute even if an error is encountered in the previous batch that's why we need to 
-- explicitly 'tell' SQL server to stop executing the subsequent batches.
-- Check http://stackoverflow.com/questions/6941738/can-the-use-or-lack-of-use-of-go-in-t-sql-scripts-effect-the-outcome for more details.

-- When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back
-- Check https://msdn.microsoft.com/en-us/library/ms188792.aspx for more details.
SET XACT_ABORT ON;
GO

BEGIN TRAN;
GO
-------------------------------------------------------------------------------------------------------------

-- Batch Start

-- Batch End
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
-- Batch Start

-- Batch End
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------
GO
COMMIT TRAN;
GO
-- We need to restore back these parameters for future executions to work.
SET NOCOUNT OFF;
SET NOEXEC OFF;
GO
------------------------------------------------------------------------------------------------------