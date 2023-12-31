if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[usp_ValidateSessionInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[usp_ValidateSessionInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [dbo].[usp_ValidateSessionInfo]
    @vSessionid       varchar(400),
    @status int out
   
AS
BEGIN
set nocount on

declare @cnt int

SELECT  @cnt=count(*)from dbo.tbl_User_Session where sessionid=@vSessionid 
if @cnt = 0
begin
	set @status = 1
end
else
begin
	set @status = 2
end

END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

