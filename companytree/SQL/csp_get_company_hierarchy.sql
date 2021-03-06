USE [bootstrap_test]
GO
/****** Object:  StoredProcedure [dbo].[csp_get_company_hierarchy]    Script Date: 2015-02-09 09:44:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[csp_get_company_hierarchy]
	-- Add the parameters for the stored procedure here
	@@idcompany AS INTEGER,
	@@retval AS NVARCHAR(MAX) = N'' OUTPUT
AS
BEGIN
-- FLAG_EXTERNALACCESS --
	DECLARE @idparent INTEGER
	DECLARE @topcompany INTEGER
	DECLARE @maxlevel INTEGER = 10
	DECLARE @i INTEGER = 1
	SELECT @idparent = [parentcompany], @topcompany = [idcompany] FROM [company] WHERE [idcompany] = @@idcompany AND [status] = 0
	WHILE @idparent IS NOT NULL AND @i < @maxlevel
	BEGIN
		SELECT @topcompany = [idcompany], @idparent = [parentcompany] FROM [company] WHERE [status] = 0 AND [idcompany] = @idparent
		SELECT @i = @i + 1
	END
	SELECT @@retval = CAST(
	(
		SELECT 
			[name],
			[idcompany] AS 'idrecord',
			ISNULL(dbo.cfn_get_company_children([idcompany], 0),N'') AS 'children'
		FROM [company] WHERE [idcompany] =  @topcompany
		FOR XML PATH(''), TYPE
	 )AS NVARCHAR(MAX))

	-- PARSE XML TO WEIRD ASS D3 JSON FORMAT 
	SELECT @@retval = REPLACE(@@retval,'<children/>','<children></children>')
	SELECT @@retval = REPLACE(@@retval,'<children>','"children" : [')
	SELECT @@retval = REPLACE(@@retval,'</children>',']},')
	SELECT @@retval = REPLACE(@@retval,'<name>','{"name" : "')
	SELECT @@retval = REPLACE(@@retval,'</name>','", ')
	SELECT @@retval = REPLACE(@@retval,'<idrecord>',' "idrecord" : "')
	SELECT @@retval = REPLACE(@@retval,'</idrecord>','", ')
	SELECT @@retval = REPLACE(@@retval,',]',']')
	SELECT @@retval = SUBSTRING(@@retval,0,LEN(@@retval))
END
