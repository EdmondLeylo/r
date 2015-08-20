
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
