IF OBJECT_ID(N'[dbo].[DBVersionHistory]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DBVersionHistory];
GO

-- Creating table 'DBVersionHistory'
CREATE TABLE [dbo].[DBVersionHistory] (
	[Id] int IDENTITY(1,1) NOT NULL,
    [VersionNumber] NVARCHAR(50)  NOT NULL,
	[Status] bit   NOT NULL,
	[UpgradedOn] datetime  NOT NULL  DEFAULT (GETDATE())
);
GO

-- Creating primary key on [RequestId] in table 'SampleHistory'
ALTER TABLE [dbo].[DBVersionHistory]
ADD CONSTRAINT [PK_DBVersionHistory]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

--Procedure to get add a new DBVersion
IF OBJECT_ID('dbo.DBVersionHistory_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DBVersionHistory_Add as select 1')
GO

ALTER PROCEDURE [dbo].[DBVersionHistory_Add] 
	@VersionNumber NVARCHAR(50),
	@Status bit
AS
BEGIN
INSERT INTO DBVersionHistory (VersionNumber, Status)
VALUES (@VersionNumber, @Status)
END
GO

-- Procedure to get the latest successful DB upgrade
IF OBJECT_ID('dbo.DBVersionHistory_GetCurrentDBVersion', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DBVersionHistory_GetCurrentDBVersion as select 1')
GO

ALTER PROCEDURE [dbo].[DBVersionHistory_GetCurrentDBVersion]
AS
BEGIN
SELECT TOP 1 v.VersionNumber FROM [dbo].[DBVersionHistory] AS v WHERE v.Status = 1 ORDER BY v.Id DESC
END
GO


