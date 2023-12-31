if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[usp_InsertSesionInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[usp_InsertSesionInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [dbo].[usp_InsertSesionInfo]
    @vSessionid       VARCHAR(400),
    @vUserName         VARCHAR(20)
   
AS
BEGIN

Declare @username varchar(50)
SELECT  @username = NULL
select @username=userName FROM dbo.tbl_User_Session WHERE userName = @vUserName

IF (@username IS NULL)
   	INSERT INTO dbo.tbl_User_Session (sessionid,userName) VALUES(@vSessionid,@vUserName)
 ELSE
	UPDATE dbo.tbl_User_Session SET sessionid = @vSessionid WHERE userName = @vUserName

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

