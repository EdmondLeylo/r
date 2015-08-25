--Adding OfferLink to the return of the stored procedure

IF OBJECT_ID('dbo.Offer_GetByStudyId', 'p') IS NULL
    EXEC ('CREATE PROCEDURE Offer_GetByStudyId as select 1')
GO
ALTER PROCEDURE [dbo].[Offer_GetByStudyId]
	@StudyId NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @Conditions NVARCHAR(MAX) = '';
	
	IF @StudyId IS NOT NULL
	BEGIN
		SET @Conditions = @Conditions + ' AND o.StudyId = ' + cast(@StudyId as varchar(10))
	END
	
	DECLARE @sql NVARCHAR(MAX) = 'SELECT
		o.Id as oid,
		o.StudyId as StudyId,
		o.SampleId as SampleId,
		o.Status as Status,
		o.Title as Title,
		o.Topic as Topic,
		o.Description as Description,
		o.OfferLink as OfferLink,
		o.TestOffer as TestOffer,
		t.Id as tid,
		T.CPI as CPI
		FROM Offers o
		LEFT JOIN [dbo].[Terms] T ON (o.[Id] = T.[OfferId]) AND T.Active = 1
		WHERE 1 = 1' + @Conditions

	EXEC(@sql)
END