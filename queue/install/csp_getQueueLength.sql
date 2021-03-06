USE []
GO
/****** Object:  StoredProcedure [dbo].[csp_getQueueLength]    Script Date: 05/08/2014 21:41:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<ILE
-- Create date: <2014-04-28>
-- Description:	<Used to update contract queuepos>
-- =============================================
CREATE PROCEDURE [dbo].[csp_getQueueLength]
(		
		@@idcampaign int
)
AS
BEGIN
	-- FLAG_EXTERNALACCESS --
	SET NOCOUNT ON;

	select max(queuepos) as maxqueue from participant where queuepos is not null and campaign = @@idcampaign
	FOR XML RAW('value'),TYPE, ROOT('queue')
END