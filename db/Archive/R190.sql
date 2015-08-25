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
------------------------------------------------------------------------------------------------------------------
--
-- DEVCME-812: Add default rate card (START)
--
IF OBJECT_ID(N'[dbo].[DefaultCpi]', 'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DefaultCpi](
  [loi] [int] NOT NULL,
  [ir] [real] NOT NULL,
  [cpi] [real] NOT NULL,
  [Creation_Date] [datetime] NOT NULL DEFAULT (GETDATE()),
  [Created_By] [nvarchar](50) NULL DEFAULT ('System'),
  PRIMARY KEY CLUSTERED 
  (
	[loi] ASC, [ir] ASC
  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
-- Procedure to insert default cpi value for a given ir/loi
IF OBJECT_ID('dbo.DefaultCpi_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_Add as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[DefaultCpi_Add]
	@loi int,
	@ir real,
	@cpi real,
	@Created_By NVARCHAR(max) = null,
	@Creation_Date DATETIME = null
AS
BEGIN
INSERT INTO DefaultCpi (loi, ir, cpi, Creation_Date,  Created_By)
VALUES (@loi, @ir, @cpi, ISNULL(@Creation_Date,GETDATE()), ISNULL(@Created_By,'System'))
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
-- Procedure to get the default cpi value based on the closest provided ir/cpi
IF OBJECT_ID('dbo.DefaultCpi_Get', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_Get as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[DefaultCpi_Get]
	@loi INT,
	@ir REAL
AS
BEGIN
	SELECT TOP 1 * from (SELECT loi, ir, cpi, ABS(loi-@loi) as x, ABS(ir-@ir) as y FROM [dbo].[DefaultCpi]) dc ORDER BY dc.x, dc.y
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.AttributeSetting_DeleteAll', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_DeleteAll as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
-- Procedure to insert default cpi value for a given ir/loi
IF OBJECT_ID('dbo.DefaultCpi_DeleteAll', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_DeleteAll as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[DefaultCpi_DeleteAll]
AS
BEGIN
DELETE FROM DefaultCpi
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
DELETE FROM [dbo].[DefaultCpi];
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 100, 0.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 90, 0.42);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 80, 0.47);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 70, 0.53);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 60, 0.62);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 50, 0.75);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 40, 0.94);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 35, 1.07);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 30, 1.25);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 25, 1.5);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 20, 1.87);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 15, 2.5);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 10, 3.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 5, 7.49);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 4, 9.36);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 3, 12.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 2, 18.71);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(3, 1, 37.43);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 100, 0.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 90, 0.42);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 80, 0.47);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 70, 0.53);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 60, 0.62);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 50, 0.75);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 40, 0.94);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 35, 1.07);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 30, 1.25);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 25, 1.5);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 20, 1.87);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 15, 2.5);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 10, 3.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 5, 7.49);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 4, 9.36);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 3, 12.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 2, 18.71);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(5, 1, 37.43);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 100, 0.4);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 90, 0.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 80, 0.49);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 70, 0.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 60, 0.66);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 50, 0.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 40, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 35, 1.13);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 30, 1.32);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 25, 1.58);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 20, 1.98);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 15, 2.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 10, 3.95);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 5, 7.9);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 4, 9.88);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 3, 13.17);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 2, 19.75);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(10, 1, 39.51);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 100, 0.42);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 90, 0.46);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 80, 0.52);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 70, 0.6);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 60, 0.7);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 50, 0.84);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 40, 1.05);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 35, 1.2);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 30, 1.39);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 25, 1.67);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 20, 2.09);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 15, 2.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 10, 4.18);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 5, 8.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 4, 10.46);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 3, 13.94);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 2, 20.92);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(15, 1, 41.83);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 100, 0.42);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 90, 0.46);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 80, 0.52);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 70, 0.6);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 60, 0.7);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 50, 0.84);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 40, 1.05);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 35, 1.2);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 30, 1.39);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 25, 1.67);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 20, 2.09);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 15, 2.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 10, 4.18);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 5, 8.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 4, 10.46);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 3, 13.94);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 2, 20.92);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(20, 1, 41.83);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 100, 0.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 90, 0.49);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 80, 0.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 70, 0.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 60, 0.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 50, 0.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 40, 1.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 35, 1.27);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 30, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 25, 1.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 20, 2.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 15, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 10, 4.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 5, 8.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 4, 11.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 3, 14.81);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 2, 22.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(25, 1, 44.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 100, 0.47);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 90, 0.53);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 80, 0.59);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 70, 0.68);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 60, 0.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 50, 0.95);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 40, 1.19);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 35, 1.35);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 30, 1.58);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 25, 1.9);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 20, 2.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 15, 3.16);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 10, 4.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 5, 9.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 4, 11.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 3, 15.8);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 2, 23.7);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(30, 1, 47.41);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 100, 0.51);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 90, 0.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 80, 0.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 70, 0.73);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 60, 0.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 50, 1.02);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 40, 1.27);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 35, 1.45);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 30, 1.69);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 25, 2.03);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 20, 2.54);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 15, 3.39);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 10, 5.08);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 5, 10.16);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 4, 12.7);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 3, 16.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 2, 25.4);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(35, 1, 50.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 100, 0.59);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 90, 0.66);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 80, 0.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 70, 0.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 60, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 50, 1.19);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 40, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 35, 1.69);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 30, 1.98);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 25, 2.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 20, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 15, 3.95);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 10, 5.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 5, 11.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 4, 14.81);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 3, 19.75);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 2, 29.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(40, 1, 59.26);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 100, 0.59);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 90, 0.66);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 80, 0.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 70, 0.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 60, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 50, 1.19);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 40, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 35, 1.69);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 30, 1.98);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 25, 2.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 20, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 15, 3.95);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 10, 5.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 5, 11.85);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 4, 14.81);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 3, 19.75);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 2, 29.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(45, 1, 59.26);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 100, 0.71);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 90, 0.79);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 80, 0.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 70, 1.02);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 60, 1.19);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 50, 1.42);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 40, 1.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 35, 2.03);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 30, 2.37);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 25, 2.84);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 20, 3.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 15, 4.74);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 10, 7.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 5, 14.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 4, 17.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 3, 23.7);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 2, 35.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(50, 1, 71.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 100, 0.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 90, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 80, 1.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 70, 1.27);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 60, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 50, 1.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 40, 2.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 35, 2.54);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 30, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 25, 3.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 20, 4.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 15, 5.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 10, 8.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 5, 17.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 4, 22.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 3, 29.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 2, 44.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(55, 1, 88.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 100, 0.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 90, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 80, 1.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 70, 1.27);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 60, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 50, 1.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 40, 2.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 35, 2.54);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 30, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 25, 3.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 20, 4.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 15, 5.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 10, 8.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 5, 17.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 4, 22.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 3, 29.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 2, 44.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(60, 1, 88.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 100, 0.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 90, 0.99);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 80, 1.11);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 70, 1.27);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 60, 1.48);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 50, 1.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 40, 2.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 35, 2.54);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 30, 2.96);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 25, 3.56);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 20, 4.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 15, 5.93);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 10, 8.89);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 5, 17.78);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 4, 22.22);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 3, 29.63);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 2, 44.44);
INSERT INTO [dbo].[DefaultCpi] (loi, ir, cpi) VALUES(61, 1, 88.89);
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
--
-- DEVCME-812: Add default rate card (END)
--
-----------------------------------------------------------------------------------------------------------------------------
--
-- DEVCME-826: Auto publish any attribute received from SAM getOpenSampleAttributes WS
-- Set to publish a list of Ids attributes
--

IF OBJECT_ID('dbo.AttributeSetting_Publish_FromAttributeIdList', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Publish_FromAttributeIdList as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-----------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[AttributeSetting_Publish_FromAttributeIdList]
    @LisAttributeId NVARCHAR(max),
	@Status BIT
AS 
BEGIN
UPDATE AttributeSettings SET Publish = Cast(@Status as varchar)  WHERE AttributeId in(SELECT * FROM [dbo].[ParseArray](@LisAttributeId,','))
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

----------------------------------------------------------------------------------------------------------------------
IF object_id('dbo.[ParseArray]') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ParseArray
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[ParseArray](
       @Array VARCHAR(8000),
       @separator CHAR(1)
)
RETURNS @T TABLE ([value] varchar(100))
AS
BEGIN
    DECLARE @separator_position INT 
    DECLARE @array_value VARCHAR(1000) 
    
    SET @array = @array + @separator
    
    WHILE PATINDEX('%' + @separator + '%', @array) <> 0
    BEGIN
        SELECT @separator_position = PATINDEX('%' + @separator + '%',@array)
        SELECT @array_value = LEFT(@array, @separator_position - 1)
    
        INSERT INTO @T
        VALUES
        (
            @array_value
        )
        SELECT @array = STUFF(@array, 1, @separator_position, '')
    END
    RETURN
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-------------------------------------------------------------------------------------------------------------------------

--
-- DEVCME-794: Mainstream Console - Add History View (START)
--

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------
IF OBJECT_ID(N'[dbo].[FK_SampleHistoryDetail_RequestId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[SampleHistoryDetail] DROP CONSTRAINT [FK_SampleHistoryDetail_RequestId];
	
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
	
	
IF OBJECT_ID(N'[dbo].[SampleHistory ]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SampleHistory ];
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-- Creating table 'SampleHistory'
CREATE TABLE [dbo].[SampleHistory] (
	[RequestId] nvarchar(256)	NOT NULL,
    [OfferId] uniqueidentifier  NOT NULL,
	[Action] nvarchar(50)	NOT NULL,
	[UpdatedOn] datetime  NOT NULL  DEFAULT (GETDATE()),
	[UpdatedBy] nvarchar(50) NOT NULL
);
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-- Creating primary key on [RequestId] in table 'SampleHistory'
ALTER TABLE [dbo].[SampleHistory]
ADD CONSTRAINT [PK_SampleHistory]
    PRIMARY KEY CLUSTERED ([RequestId] ASC);
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-- Creating foreign key on [OfferId] in table 'SampleHistory'
ALTER TABLE [dbo].[SampleHistory]
ADD CONSTRAINT [FK_SampleHistory_OfferId]
    FOREIGN KEY ([OfferId])
    REFERENCES [dbo].[Offers]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

IF OBJECT_ID(N'[dbo].[SampleHistoryDetail ]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SampleHistoryDetail ];
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-- Creating table 'SampleHistoryDetail'
CREATE TABLE [dbo].[SampleHistoryDetail] (
	[RequestId] nvarchar(256)	NOT NULL,
    [Property] nvarchar(50)	NOT NULL,
	[OldValue] nvarchar(256)	NOT NULL,
	[NewValue] nvarchar(256)	NOT NULL
);
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-- Creating primary key on [RequestId] and [Property] in table 'SampleHistoryDetail'
ALTER TABLE [dbo].[SampleHistoryDetail]
ADD CONSTRAINT [PK_SampleHistoryDetail]
    PRIMARY KEY CLUSTERED 
	(
		[RequestId] ASC,
		[Property] ASC
	);
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
-- Creating foreign key on [RequestId] in table 'SampleHistoryDetail'
ALTER TABLE [dbo].[SampleHistoryDetail]
ADD CONSTRAINT [FK_SampleHistoryDetail_RequestId]
    FOREIGN KEY ([RequestId])
    REFERENCES [dbo].[SampleHistory]
        ([RequestId])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
IF OBJECT_ID('dbo.SampleHistory_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE SampleHistory_Add as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
ALTER PROCEDURE [dbo].[SampleHistory_Add] 
	@RequestId nvarchar(256),
	@OfferId UNIQUEIDENTIFIER,
	@Action nvarchar(50),
	@UpdatedBy nvarchar(50) = null
AS
BEGIN
INSERT INTO SampleHistory (RequestId, OfferId, Action, UpdatedBy)
VALUES (@RequestId, @OfferId, @Action, @UpdatedBy)
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
IF OBJECT_ID('dbo.SampleHistoryDetail_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE SampleHistoryDetail_Add as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
ALTER PROCEDURE [dbo].[SampleHistoryDetail_Add] 
	@RequestId nvarchar(256),
	@Property nvarchar(50),
	@OldValue nvarchar(256),
	@NewValue nvarchar(256) = null
AS
BEGIN
INSERT INTO SampleHistoryDetail (RequestId, Property, OldValue, NewValue)
VALUES (@RequestId, @Property, @OldValue, @NewValue)
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

IF OBJECT_ID('dbo.SampleHistory_GetBySampleId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE SampleHistory_GetBySampleId as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
ALTER PROCEDURE SampleHistory_GetBySampleId 
	@SampleId int 
AS
BEGIN
SELECT sh.* FROM [dbo].[SampleHistory] as sh,[dbo].[Offers] as o WHERE o.SampleId=@SampleId AND sh.OfferId=o.Id order by sh.UpdatedOn desc
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

IF OBJECT_ID('dbo.SampleHistoryDetail_GetByRequestId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE SampleHistoryDetail_GetByRequestId as select 1')
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
ALTER PROCEDURE SampleHistoryDetail_GetByRequestId 
	@RequestId nvarchar(256) 
AS
BEGIN
SELECT * FROM [dbo].[SampleHistoryDetail] WHERE RequestId = @RequestId
END
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
--
-- DEVCME-794: Mainstream Console - Add History View (END)-------------------------------------------------------
--
-- DEVCME-750: define stored procedure to delete providers by ProviderId ---------------------------------------------
-- 

IF OBJECT_ID('dbo.Provider_DeleteByProviderId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Provider_DeleteByProviderId as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
---------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[Provider_DeleteByProviderId] 
	@ProviderId NVARCHAR(100)
AS
BEGIN
DELETE FROM Providers
WHERE ProviderId = @ProviderId
END

GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
--
-- End DEVCME-750
---
--- DEVCME-846 : Adding trigger on Offers table to reset try count when status transitions from pending to any other status

IF EXISTS (SELECT name FROM sys.objects
      WHERE name = 'tr_Offers_Status' AND type = 'TR')
   DROP TRIGGER tr_Offers_Status;
GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
Create TRIGGER tr_Offers_Status
   ON [dbo].[Offers] FOR UPDATE AS
  IF UPDATE(Status)
BEGIN
    Delete from [dbo].[QuotaMapping] where [SampleId] in(SELECT inserted.SampleId FROM inserted where inserted.Status <>1 );
	Delete from [dbo].[SampleMapping] where [SampleId] in(SELECT inserted.SampleId FROM inserted where inserted.Status <>1);
	Delete from [dbo].[QuotaExpressions] where [SampleId] in(SELECT inserted.SampleId FROM inserted where inserted.Status <>1);
	Update [dbo].[Offers] SET [RetryCount] = 0 FROM Inserted,Deleted where Inserted.Status <> Deleted.Status AND Inserted.RetryCount <> 0 AND [dbo].[Offers].[Id] = Deleted.Id;
END

GO
IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
---
--- End DEVCME-846
---



COMMIT TRAN;
GO
SET NOCOUNT OFF;
SET NOEXEC OFF;
GO
--
-------------------------------------------------------------------------------------------------------------------
-- 

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--   DON'T PLACE ANY STATEMENT AFTER COMMITTING THE TRANSACTION - ALL STATEMENTS SHOULD GO BEFORE THE COMMIT -------
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
