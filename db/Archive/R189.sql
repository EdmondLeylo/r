---DEVCME-704 Changing the stored procedure to return some additional fields

IF OBJECT_ID('dbo.Offer_GetByStudyId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetByStudyId as select 1')
GO
ALTER PROCEDURE dbo.Offer_GetByStudyId
	@StudyId NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @Conditions NVARCHAR(MAX) = '';
	
	IF @StudyId IS NOT NULL
	BEGIN
		SET @Conditions = @Conditions + ' AND o.StudyId = ' + cast(@StudyId as varchar(10))
	END
	
	DECLARE @sql NVARCHAR(MAX) = 'SELECT
		o.StudyId as StudyId,
		o.SampleId as SampleId,
		o.Status as Status,
		o.Title as Title,
		o.Topic as Topic,
		o.Description as Description,
		o.TestOffer as TestOffer,
		T.CPI as CPI
		FROM Offers o
		LEFT JOIN [dbo].[Terms] T ON (o.[Id] = T.[OfferId]) AND T.Active = 1
		WHERE 1 = 1' + @Conditions

	EXEC(@sql)
END


---DEVCME-719 Define stored procedure that returns inactive offers

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID('dbo.Offer_GetInactiveSampleIdsAndDates', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetInactiveSampleIdsAndDates as select 1')
GO

ALTER PROCEDURE [dbo].[Offer_GetInactiveSampleIdsAndDates] 
AS
BEGIN

EXEC('SELECT o.SampleId, o.Id, o.Update_Date
FROM Offers as o
WHERE o.Status = 0')

END

--
--  Start: Change for DEVCME-703 RpcService to Return attributes from SAM
--

IF OBJECT_ID('dbo.RespondentAttribute_GetRpcOfferAttributes', 'p') IS NULL
    EXEC ('CREATE PROCEDURE RespondentAttribute_GetRpcOfferAttributes as select 1')
GO
ALTER PROCEDURE [dbo].[RespondentAttribute_GetRpcOfferAttributes] 
	@OfferId UNIQUEIDENTIFIER
AS
BEGIN

SELECT r.Ident
FROM RespondentAttributes as r
WHERE r.OfferId = @OfferId

END
GO


IF OBJECT_ID('dbo.RespondentAttribute_GetOfferAttributesApi', 'p') IS NULL
    EXEC ('CREATE PROCEDURE RespondentAttribute_GetOfferAttributesApi as select 1')
GO
ALTER PROCEDURE [dbo].[RespondentAttribute_GetOfferAttributesApi] 
	@OfferId UNIQUEIDENTIFIER
AS
BEGIN

SELECT r.Ident as Name, r.[Values] as Value
FROM RespondentAttributes as r
WHERE r.OfferId = @OfferId and r.[Values] != ''
END

GO

IF OBJECT_ID('dbo.RespondentAttribute_UpdateAttributeValue', 'p') IS NULL
    EXEC ('CREATE PROCEDURE RespondentAttribute_UpdateAttributeValue as select 1')
GO
ALTER PROCEDURE [dbo].[RespondentAttribute_UpdateAttributeValue] 
	@Id INT,
	@Values NVARCHAR(MAX)
AS
BEGIN

UPDATE RespondentAttributes
SET [Values] = ISNULL(@Values, [Values])
WHERE Id = @Id
END

GO

-- IF EXISTS(SELECT * FROM sys.COLUMNS WHERE Name='Publish' AND OBJECT_ID = OBJECT_ID('dbo.AttributeSettings'))
-- BEGIN
  -- DECLARE @ConstraintName nvarchar(200)
  -- SELECT @ConstraintName = Name FROM SYS.DEFAULT_CONSTRAINTS
  -- WHERE PARENT_OBJECT_ID = OBJECT_ID('AttributeSettings')
  -- AND PARENT_COLUMN_ID = (SELECT column_id FROM sys.columns
                        -- WHERE NAME = N'Publish'
                        -- AND object_id = OBJECT_ID(N'AttributeSettings'))
  -- IF @ConstraintName IS NOT NULL
    -- EXEC('ALTER TABLE AttributeSettings DROP CONSTRAINT ' + @ConstraintName)
  -- DROP INDEX [IX_Attributes_Publish] ON [dbo].[AttributeSettings]
  -- ALTER TABLE dbo.AttributeSettings DROP COLUMN Publish
-- END

IF OBJECT_ID('dbo.AttributeSetting_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Add as select 1')
GO

ALTER PROCEDURE [dbo].[AttributeSetting_Add]
	@AttributeId NVARCHAR(max),
	@Creation_Date DATETIME = null,
	@Created_By NVARCHAR(max) = null,
	@Update_Date DATETIME = null,
	@Last_Updated_By NVARCHAR(max) = null,
	@Required bit = null
AS
BEGIN
INSERT INTO AttributeSettings (AttributeId, Creation_Date,  Created_By, Update_Date, Last_Updated_By, Required)
VALUES (@AttributeId, ISNULL(@Creation_Date,GETDATE()),ISNULL(@Created_By,'System'), ISNULL(@Update_Date,GETDATE()), ISNULL(@Last_Updated_By,'System'), ISNULL(@Required, 0))
END

GO

IF OBJECT_ID('dbo.AttributeSetting_Update', 'p') IS NULL
    EXEC ('CREATE PROCEDURE AttributeSetting_Update as select 1')
GO

ALTER PROCEDURE [dbo].[AttributeSetting_Update]
	@AttributeId NVARCHAR(max),
	@Creation_Date DateTime = null,
	@Created_By NVARCHAR(max) = null,
	@Update_Date DATETIME = null,
	@Last_Updated_By NVARCHAR(max) = null,
	@Required NVARCHAR(max) = null
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

IF OBJECT_ID('dbo.AttributeSetting_Publish', 'p') IS NOT NULL
	DROP PROCEDURE [dbo].[AttributeSetting_Publish]
GO


--
--  END: Change for DEVCME-703 RpcService to Return attributes from SAM
--


-- DEVCME-704 Adding the testOffer field to Offer_Add stored procedure
IF OBJECT_ID('dbo.Offer_Add', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_Add as select 1')
GO
ALTER PROCEDURE [dbo].[Offer_Add] 
	@StudyId INT,
	@SampleId INT, 
	@LOI INT, 
	@IR REAL, 
	@Status INT = null, 
	@Description NVARCHAR(MAX) = null,
	@Title NVARCHAR(256) = null,
	@Topic NVARCHAR(256) = null,
	@OfferLink NVARCHAR(512) = null,
	@QuotaRemaining INT,
	@StudyStartDate DATETIME,
	@StudyEndDate DATETIME = null,
	@TestOffer BIT = 0
AS
BEGIN
INSERT INTO Offers (StudyId, SampleId, LOI, IR, Status, Description, Title, Topic, OfferLink, QuotaRemaining, StudyStartDate, StudyEndDate, TestOffer)
VALUES (@StudyId, @SampleId, @LOI, @IR, @Status, @Description, @Title, @Topic, @OfferLink, @QuotaRemaining, @StudyStartDate, @StudyEndDate, @TestOffer)
END

