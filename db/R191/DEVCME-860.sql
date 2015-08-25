
IF OBJECT_ID('dbo.Offer_GetActiveSampleIds', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetActiveSampleIds as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetActiveSampleIds] 
AS
BEGIN
SELECT o.SampleId, o.Id
FROM Offers as o
WHERE o.Status = 1
END
GO

------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Offer_GetInactiveSampleIdsAndDates', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetInactiveSampleIdsAndDates as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetInactiveSampleIdsAndDates] 
AS
BEGIN
SELECT o.SampleId, o.Id, o.Update_Date
FROM Offers as o
WHERE o.Status = 0
END
GO

------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Offer_GetOfferIdsFromStudyIds', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetOfferIdsFromStudyIds as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetOfferIdsFromStudyIds] 
	@StudyIds NVARCHAR(MAX)
AS
BEGIN
SELECT Id as OfferId, StudyId
FROM Offers as o
WHERE o.StudyId in (SELECT * FROM [dbo].[ParseArray](@StudyIds,',')) AND o.Status = 1
END
GO

------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Offer_GetPendingSampleIdsAndRetryCount', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetPendingSampleIdsAndRetryCount as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetPendingSampleIdsAndRetryCount]
AS
BEGIN
SELECT o.SampleId, o.Id, o.RetryCount
FROM Offers as o
WHERE o.Status = 3
END
GO

------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Offer_GetStudyIdsFromOfferIds', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetStudyIdsFromOfferIds as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetStudyIdsFromOfferIds] 
	@OfferIds NVARCHAR(MAX)
AS
BEGIN
DECLARE @SQL NVARCHAR(MAX)
SELECT StudyId, Id
FROM Offers as o
WHERE o.Id in (SELECT * FROM [dbo].[ParseArray](@OfferIds,'/'))
END
GO

------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Offer_GetSuspendedSampleIdsAndDates', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetSuspendedSampleIdsAndDates as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetSuspendedSampleIdsAndDates] 
AS
BEGIN
SELECT o.SampleId, o.Id, o.StudyStartDate, o.StudyEndDate
FROM Offers as o
WHERE o.Status = 2
END
GO

---------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Attribute_CheckAttribute', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Attribute_CheckAttribute as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Attribute_CheckAttribute]
	@Attribute NVARCHAR(50)
AS
BEGIN
SELECT *
FROM Attributes
WHERE UPPER(Id) = UPPER(@Attribute) 
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Attribute_Delete', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Attribute_Delete as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Attribute_Delete]
	@Id NVARCHAR(50)
AS
BEGIN
DELETE FROM Attributes
WHERE Id = @Id
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
--------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Attribute_GetById', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Attribute_GetById as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Attribute_GetById]
	@Id NVARCHAR(50) = null 
AS
BEGIN
SELECT * FROM [dbo].[Attributes] WHERE Id = @Id
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

---------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Attribute_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Attribute_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Attribute_Update]
	@Id NVARCHAR(50),
	@Name NVARCHAR(100) = null,
	@ShortName NVARCHAR(100) = null,
	@Label NVARCHAR(500) = null,
	@Type NVARCHAR(100) = null
AS
BEGIN

UPDATE Attributes
	SET Name = ISNULL(@Name, Name),
 ShortName = ISNULL(@ShortName, ShortName),
 Label = ISNULL(@Label, Label),
 Type = ISNULL(@Type, Type)
WHERE Id = @Id

END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeOption_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeOption_Add as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeOption_Add]
	@AttributeId NVARCHAR(50),
	@Code INT, 
	@Description NVARCHAR(500)
AS
BEGIN
INSERT INTO AttributeOptions(AttributeId, Code, Description)
VALUES (@AttributeId, @Code, @Description)
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeOption_Delete', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeOption_Delete as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeOption_Delete] 
	@AttributeId NVARCHAR(50),
	@Code int
AS
BEGIN
DELETE FROM AttributeOptions
WHERE AttributeId = @AttributeId AND Code=@Code
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeOption_GetById', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeOption_GetById as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeOption_GetById]
	@AttributeId NVARCHAR(50) = null 
AS
BEGIN
SELECT [dbo].[AttributeOptions].[AttributeId] as AttributeId, [dbo].[AttributeOptions].[Code] as Code,[dbo].[AttributeOptions].[Description] as Description FROM [dbo].[AttributeOptions] WHERE AttributeId = @AttributeId ORDER BY CASE WHEN ISNUMERIC(Code) = 1 THEN CAST(Code AS INT) ELSE 0
END
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO


----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeOption_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeOption_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeOption_Update]
	@AttributeId NVARCHAR(50),
	@Code INT,
	@Description NVARCHAR(500) = null
AS
BEGIN
UPDATE AttributeOptions
SET Description = ISNULL(@Description, Description)
WHERE AttributeId = @AttributeId AND Code = @Code
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeSetting_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Add as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeSetting_Add]
	@AttributeId NVARCHAR(50),
	@Creation_Date DATETIME = null,
	@Created_By NVARCHAR(50) = null,
	@Update_Date DATETIME = null,
	@Last_Updated_By NVARCHAR(50) = null,
	@Required bit = null
AS
BEGIN
INSERT INTO AttributeSettings (AttributeId, Creation_Date,  Created_By, Update_Date, Last_Updated_By, Required)
VALUES (@AttributeId, ISNULL(@Creation_Date,GETDATE()),ISNULL(@Created_By,'System'), ISNULL(@Update_Date,GETDATE()), ISNULL(@Last_Updated_By,'System'), ISNULL(@Required, 0))
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeSetting_Delete', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Delete as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeSetting_Delete]
	@AttributeId NVARCHAR(50)
AS
BEGIN
DELETE FROM AttributeSettings
WHERE AttributeId = @AttributeId
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeSetting_GetById', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_GetById as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeSetting_GetById]
	@AttributeId NVARCHAR(50) = null 
AS
BEGIN
SELECT * FROM [dbo].[AttributeSettings] WHERE AttributeId = @AttributeId
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

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

ALTER PROCEDURE [dbo].[AttributeSetting_Publish_FromAttributeIdList]
    @LisAttributeId NVARCHAR(2000),
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

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.AttributeSetting_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[AttributeSetting_Update]
	@AttributeId NVARCHAR(50),
	@Creation_Date DateTime = null,
	@Created_By NVARCHAR(50) = null,
	@Update_Date DATETIME = null,
	@Last_Updated_By NVARCHAR(50) = null,
	@Required NVARCHAR(10) = null
AS
BEGIN

UPDATE AttributeSettings
SET Creation_Date = ISNULL(@Creation_Date, GETDATE()),
	Created_By = ISNULL(@Created_By,Created_By),
	Update_Date = ISNULL(@Update_Date, GetDate()),
	Last_Updated_By = ISNULL(@Last_Updated_By, Last_Updated_By),
	Required = ISNULL(@Required, Required)
WHERE AttributeId = @AttributeId

END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

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

ALTER PROCEDURE [dbo].[DefaultCpi_Add]
	@loi int,
	@ir real,
	@cpi real,
	@Created_By NVARCHAR(50) = null,
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

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.DefaultCpi_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE DefaultCpi_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[DefaultCpi_Update]
	@loi int,
	@ir real,
	@cpi real,
	@Created_By NVARCHAR(50) = null,
	@Creation_Date DATETIME = null
AS
BEGIN
UPDATE [dbo].[DefaultCpi] SET [cpi] = @cpi, [Creation_Date] = ISNULL(@Creation_Date,GETDATE()), [Created_By] = ISNULL(@Created_By,'System')
WHERE loi = @loi AND ir = @ir;
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Offer_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Offer_Update]
	@Id UNIQUEIDENTIFIER,
	@StudyId INT = null,
	@SampleId INT = null, 
	@LOI INT = null, 
	@IR REAL = null, 
	@Status INT = null, 
	@Test NVARCHAR(10) = null,
	@Description NVARCHAR(MAX) = null,
	@Title NVARCHAR(256) = null,
	@Topic NVARCHAR(256) = null,
	@OfferLink NVARCHAR(512) = null,
	@QuotaRemaining INT = null,
	@StudyStartDate DATETIME = null,
	@StudyEndDate DATETIME = null,
	@RetryCount INT = null
AS
BEGIN

UPDATE Offers
SET StudyId = ISNULL(@StudyId, StudyId),
	SampleId = ISNULL(@SampleId, SampleId),
	LOI = ISNULL(@LOI, LOI),
	IR = ISNULL(@IR, IR),
	Status = ISNULL(@Status, Status),
	Description = ISNULL(@Description, Description),
	Title = ISNULL(@Title, Title),
	Topic = ISNULL(@Topic, Topic),
	OfferLink = ISNULL(@OfferLink, OfferLink),
	QuotaRemaining = ISNULL(@QuotaRemaining, QuotaRemaining),
	StudyStartDate = ISNULL(@StudyStartDate, StudyStartDate),
	StudyEndDate = ISNULL(@StudyEndDate, StudyEndDate),
	TestOffer = ISNULL(@Test, TestOffer),
	RetryCount = ISNULL(@RetryCount, RetryCount)
WHERE Id = @Id
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Provider_GetByProviderId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Provider_GetByProviderId as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Provider_GetByProviderId]
	@ProviderId NVARCHAR(450) 
AS
BEGIN
SELECT * FROM [dbo].[Providers] WHERE ProviderId = @ProviderId
END
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('dbo.Provider_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Provider_Update as select 1')
GO

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO

ALTER PROCEDURE [dbo].[Provider_Update] 
	@Id INT,
	@ProviderId NVARCHAR(450),
	@WelcomeUrlCode NVARCHAR(MAX), 
	@Enabled BIT
AS
BEGIN

UPDATE Providers
SET ProviderId = ISNULL(@ProviderId, ProviderId),
	WelcomeUrlCode = ISNULL(@WelcomeUrlCode, WelcomeUrlCode),
	Enabled = ISNULL(@Enabled, Enabled)
WHERE Id = @Id
END

IF @@Error <> 0
	BEGIN
		PRINT ('An error encountered in the previous batch - Stopping the execution of the remaining batches...');
		SET NOCOUNT ON;
		SET NOEXEC ON;
	END
GO
