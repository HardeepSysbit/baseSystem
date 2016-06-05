
GO
/****** Object:  Table [dbo].[userGroup]    Script Date: 3/17/2016 6:47:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userGroup](
	[userGroup] [uniqueidentifier] NULL,
	[version] [timestamp] NULL,
	[name] [char](10) NULL,
	[rights] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userId]    Script Date: 3/17/2016 6:47:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userId](
	[userId] [uniqueidentifier] NOT NULL,
	[version] [timestamp] NULL,
	[name] [char](15) NULL,
	[pswd] [char](36) NULL,
	[userGroup] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[userGroup] ([userGroup], [name], [rights]) VALUES (N'0178dbf0-018e-488a-a914-5b0e04a2d4bf', N'adminGroup', N'{"isAdmin":true,"isInt":false,"isExt":false}')
INSERT [dbo].[userGroup] ([userGroup], [name], [rights]) VALUES (N'28c3abda-d080-415a-b216-61e4e892cef2', N'intGroup  ', N'{"isAdmin":false,"isInt":true,"isExt":false}')
INSERT [dbo].[userGroup] ([userGroup], [name], [rights]) VALUES (N'aedc74b2-bbfb-42b1-8e98-3deadd6fe452', N'extGroup  ', N'{"isAdmin":false,"isInt":false,"isExt":true}')
INSERT [dbo].[userId] ([userId], [name], [pswd], [userGroup]) VALUES (N'b4d281fb-adc4-400f-8217-6c5e6a6509a2', N'admin          ', N'123456                              ', N'0178dbf0-018e-488a-a914-5b0e04a2d4bf')
INSERT [dbo].[userId] ([userId], [name], [pswd], [userGroup]) VALUES (N'28c3abda-d080-415a-b216-61e4e892cef2', N'int            ', N'123456                              ', N'53803e92-c895-4578-a9d5-63546cb85497')
INSERT [dbo].[userId] ([userId], [name], [pswd], [userGroup]) VALUES (N'aedc74b2-bbfb-42b1-8e98-3deadd6fe452', N'transporter    ', N'123456                              ', N'8b7561d1-462f-4a90-81f3-dbc681c3849e')
/****** Object:  StoredProcedure [dbo].[logIn]    Script Date: 3/17/2016 6:47:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hardeep
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[logIn] 
	-- Add the parameters for the stored procedure here
	@userId char(15) = '', 
	@pswd char(36) = '',
	@newPswd char(36) = '',
	@reset bit

AS
BEGIN


	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.rights from userId A  
	Left Join userGroup B on A.userGroup = B.userGroup
	where A.name = @userId and A.pswd = @pswd

	
END

GO
