if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_User_Session]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_User_Session]
GO

CREATE TABLE [dbo].[tbl_User_Session] (
	[SessionId] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

