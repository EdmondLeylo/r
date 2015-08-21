-- Change DefaultCpi_Get to get the exact cell (match loi, ir), create new sp DefaultCpi_GetClosest to get the closest cell
-- Procedure to get the default cpi value based on the closest provided ir/cpi
IF OBJECT_ID('dbo.DefaultCpi_Get', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_Get as select 1')
GO

ALTER PROCEDURE [dbo].[DefaultCpi_Get]
	@loi INT,
	@ir REAL
AS
BEGIN
	SELECT * FROM [dbo].[DefaultCpi] WHERE loi = @loi AND ir = @ir;
END
GO

-- Procedure to get the default cpi value based on the closest provided ir/cpi
IF OBJECT_ID('dbo.DefaultCpi_GetClosest', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_GetClosest as select 1')
GO

ALTER PROCEDURE [dbo].[DefaultCpi_GetClosest]
	@loi INT,
	@ir REAL
AS
BEGIN
	SELECT TOP 1 * from (SELECT loi, ir, cpi, ABS(loi-@loi) as x, ABS(ir-@ir) as y FROM [dbo].[DefaultCpi]) dc ORDER BY dc.x, dc.y
END
GO

IF OBJECT_ID('dbo.DefaultCpi_GetAll', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_GetAll as select 1')
GO

ALTER PROCEDURE [dbo].[DefaultCpi_GetAll]
AS
BEGIN
	SELECT * FROM [dbo].[DefaultCpi] ORDER BY LOI, IR;
END
GO

-----------------------------------------------------------------------------------------------------------------------------
-- Procedure to update default cpi value for a given ir/loi
IF OBJECT_ID('dbo.DefaultCpi_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_Update as select 1')
GO

ALTER PROCEDURE [dbo].[DefaultCpi_Update]
	@loi int,
	@ir real,
	@cpi real,
	@Created_By NVARCHAR(max) = null,
	@Creation_Date DATETIME = null
AS
BEGIN
UPDATE [dbo].[DefaultCpi] SET [cpi] = @cpi, [Creation_Date] = ISNULL(@Creation_Date,GETDATE()), [Created_By] = ISNULL(@Created_By,'System')
WHERE loi = @loi AND ir = @ir;
END
GO

-----------------------------------------------------------------------------------------------------------------------------
