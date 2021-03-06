
/****** Object:  UserDefinedFunction [dbo].[cfn_get_company_children]    Script Date: 2015-02-09 09:44:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JKA
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[cfn_get_company_children]
(
	-- Add the parameters for the function here
	@@idparent INTEGER,
	@@level INTEGER
)
RETURNS XML

AS
BEGIN
	-- Declare the return variable here
	RETURN
	(
		SELECT	
				[name] AS 'name',
				[idcompany] AS 'idrecord',
				CASE WHEN @@level < 10 THEN ISNULL([dbo].[cfn_get_company_children]([idcompany],@@level + 1),N'') ELSE N'' END AS 'children'
		FROM [company]
		WHERE [parentcompany]= @@idparent
		FOR XML PATH(''), TYPE
	)

END
