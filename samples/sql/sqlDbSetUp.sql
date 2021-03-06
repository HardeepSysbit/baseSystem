GO
/****** Object:  UserDefinedFunction [dbo].[fncLeftPad]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop table userGroup
--drop table userId
--drop table config
--drop function fncLeftPad
--drop proc Login
--drop  Procedure [dbo].[rightsKey]
--drop  Procedure [dbo].[userGroupIns]
--drop  Procedure [dbo].[userGroupDel]
--drop  Procedure [dbo].[userGroupGet]
--drop  Procedure [dbo].[userGroupKey]
--drop  Procedure [dbo].[userGroupSel]
--drop  Procedure [dbo].[userGroupUpd]
--drop  Procedure [dbo].[userIdIns]
--drop  Procedure [dbo].[userIdDel]
--drop  Procedure [dbo].[userIdGet]
--drop  Procedure [dbo].[userIdSel]
--drop  Procedure [dbo].[userIdUpd]


Create FUNCTION [dbo].[fncLeftPad]


(


@str nvarchar(max),
@pad_size int,
@pad_char nchar(1)


)


RETURNS nvarchar(max)


AS


BEGIN

Select @str = RTRIM(@str)

RETURN right(replicate(@pad_char, @pad_size)+@str, @pad_size)

END







GO
/****** Object:  Table [dbo].[config]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[config](
	[key] [char](15) NULL,
	[value] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userGroup]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userGroup](
	[_id] [uniqueidentifier] NULL,
	[_ts] [timestamp] NOT NULL,
	[name] [char](35) NULL,
	[rightsList] [varchar](max) NULL,
	[upDatedBy] [char](35) NULL,
	[upDatedOn] [smalldatetime] NULL,
	[createdBy] [char](35) NULL,
	[createdOn] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userId]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userId](
	[_id] [uniqueidentifier] NULL,
	[_ts] [timestamp] NOT NULL,
	[name] [char](35) NULL,
	[pswd] [char](36) NULL,
	[userGroup] [uniqueidentifier] NULL,
	[upDatedBy] [char](35) NULL,
	[upDatedOn] [smalldatetime] NULL,
	[createdBy] [char](35) NULL,
	[createdOn] [smalldatetime] NULL,
	[reset] [bit] NULL,
	[eMail] [varchar](100) NULL,
	[userId] [char](15) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[config] ([key], [value]) VALUES (N'rights', N'[{ "name": "System", "rights": { "userId": false, "group": false }},{ "name": "App", "rights": { "setUp": false }}]')
INSERT [dbo].[userGroup] ([name], [rightsList], [_id], [upDatedBy], [upDatedOn], [createdBy], [createdOn]) VALUES (N'admin', N'[{"name":"System","rights":{"userId":true,"group":true}},{"name":"App","rights":{"SetUp":true}}]', N'28c3abda-d080-415a-b216-61e4e892cef2', N'admin', CAST(N'2016-03-26 12:04:00' AS SmallDateTime), NULL, NULL)
INSERT [dbo].[userId] ([name], [pswd], [userGroup], [_id], [upDatedBy], [upDatedOn], [createdBy], [createdOn], [reset], [eMail], [userId]) VALUES (N'admin                              ', N'-1522920846                         ', N'28c3abda-d080-415a-b216-61e4e892cef2', N'b4d281fb-adc4-400f-8217-6c5e6a6509a2', N'admin                              ', CAST(N'2016-03-26 16:16:00' AS SmallDateTime), NULL, NULL, NULL, N'123456', N'admin          ')


GO
/****** Object:  StoredProcedure [dbo].[logIn]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hardeep
-- Create date: 
-- Description:	
-- =============================================

Create Procedure [dbo].[LogIn]
(
	@userId char(15) , 
	@pswd char(36) ,
	@newPswd char(36),
	@reset bit
	
)

As


SET NOCOUNT ON
SET XACT_ABORT OFF -- Allow procedure to continue after error

DECLARE 	@ProcName_VC    	varchar(30),      -- Name of this procedure
			@Error_IT      		integer,          -- Local variable to capture the error code.
			@RowCnt_IT     		integer,          -- Number of rows returned 
			@ErrMsg_VC     		varchar(1000)     -- Error message to return

-- *******************
-- Set local variables
-- *******************
SELECT		@ProcName_VC             = object_name(@@procid),
			@Error_IT                = 0,
			@RowCnt_IT               = 0
                                       

DECLARE @userGroup uniqueIdentifier,
        @userReset bit
    

Select top 1  @userGroup = userGroup, @userReset = iSnULL(reset,0) from 
userId A where name = @UserId and Pswd = @pswd 


SELECT @Error_IT   = @@Error, 
@RowCnt_IT         = @@RowCount 


if @RowCnt_IT  = 0
Begin
                              SELECT @ErrMsg_VC = 'Invalid Login'
                              GOTO ENDERROR
End


IF (@Error_IT != 0)
BEGIN
                              SELECT @ErrMsg_VC = 'Error getting records'
                              GOTO ENDERROR
END

if  @userReset  = 1 And IsNull(@reset,0) = 0
Begin
                              SELECT @ErrMsg_VC = 'Password Reset Required'
                              GOTO ENDERROR
End

If @reset = 1
Begin

               Update UserId  Set pswd = @newPswd , [reset] = 0
                where UserId = @UserId and Pswd = @pswd 

               
               SELECT @Error_IT                           = @@Error, 
                                             @RowCnt_IT                      = @@RowCount 


               if @RowCnt_IT  = 0
               Begin
                              SELECT @ErrMsg_VC = 'Unable to Change Password'
                              GOTO ENDERROR
               End


               IF (@Error_IT != 0)
               BEGIN
               Begin
                              SELECT @ErrMsg_VC = 'Unable to Change Password'
                              GOTO ENDERROR
               End

END


End

SELECT rightsList from  userGroup Where _id = @userGroup
	
	
	


RETURN 0

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
      RAISERROR (@ErrMsg_vc,16,1)
      RETURN 1
   END






--CREATE PROCEDURE [dbo].[logIn] 
--	-- Add the parameters for the stored procedure here
--	@userId char(15) = '', 
--	@pswd char(36) = '',
--	@newPswd char(36) = '',
--	@reset bit

--AS
--BEGIN


--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT rightsList = b.rightsList from userId A  
--	Left Join userGroup B on A.userGroup = B._id
--	where A.userId = @userId and A.pswd = @pswd

	
--END



GO
/****** Object:  StoredProcedure [dbo].[rightsKey]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[rightsKey]
As 
Select value from config where [key] = 'rights'


GO
/****** Object:  StoredProcedure [dbo].[userGroupDel]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[userGroupDel]
(
	@_id uniqueIdentifier,
	@_ts bigInt


)
AS


DECLARE @ErrMsg_VC  varchar(max)

Delete FROM userGroup 
Where _id = @_id and CONVERT(decimal, _ts + 0) = @_ts


If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to update record <br/> Record may have been modified by another user <br/> Please refresh data'
	GOTO ENDERROR
END


RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
	   RAISERROR (@ErrMsg_VC, 16, 1)
	 RETURN -1
   END


GO
/****** Object:  StoredProcedure [dbo].[userGroupGet]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userGroupGet]
(
	@_id uniqueIdentifier

)
As
Select  _id = _id, _ts = CONVERT(decimal,_ts + 0), name = rtrim(name), rightsList =   rightsList from userGroup 
Where _id = @_id




GO
/****** Object:  StoredProcedure [dbo].[userGroupIns]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userGroupIns]
(
	@name char(35),
	@rightsList varchar(max),
	@createdBy char(35),
    @createdOn smallDateTime

)

AS

DECLARE @_id uniqueIdentifier
DECLARE @ErrMsg_VC  varchar(max)


-- Create New ID
Select @_id = newid() 

-- Insert Action
Insert into userGroup
(
_id,
name, 
rightsList,
createdBy,
createdOn
)
Select @_id, 
@name,
@rightsList ,
@createdBy,
@createdOn


If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to update record <br/> Record may have been modified by another user <br/> Please refresh data'
	GOTO ENDERROR
END

Select _id = @_id

RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
	 RAISERROR (25000,-1,-1, @ErrMsg_VC);
	 RETURN -1
   END




GO
/****** Object:  StoredProcedure [dbo].[userGroupKey]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[userGroupKey]

As

Select [key] = _id, [value] =name 
from userGroup
Order by name




GO
/****** Object:  StoredProcedure [dbo].[userGroupSel]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userGroupSel]
(
	@_id uniqueIdentifier

)
As
Select  _id = _id, _ts =  CONVERT(decimal, _ts + 0), name = name from userGroup 
Where @_id is Null or _id  = @_id
order by name


GO
/****** Object:  StoredProcedure [dbo].[userGroupUpd]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userGroupUpd]
(
	@_id uniqueIdentifier,
	@_ts bigInt,
	@name char(35),
	@rightsList varchar(max),
	@updatedBy char(35),
    @updatedOn smallDateTime


)

AS


DECLARE @ErrMsg_VC  varchar(200)

UPDATE userGroup set 
name = @name , 
rightsList = @rightsList,
updatedBy = @updatedBy,  
updatedOn = @updatedOn
WHERE _id =  @_id and CONVERT(decimal, _ts + 0) = @_ts

If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to update record <br/> Record may have been modified by another user <br/> Please refresh data'
	GOTO ENDERROR
END


RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
    RAISERROR (@ErrMsg_VC, 16, 1)
	RETURN -1
   END





GO
/****** Object:  StoredProcedure [dbo].[userIdDel]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create  Procedure [dbo].[userIdDel]
(
	@_id uniqueIdentifier,
	@_ts bigInt


)
AS


DECLARE @ErrMsg_VC  varchar(max)

Delete FROM userId 
Where _id = @_id and CONVERT(decimal, _ts + 0) = @_ts


If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to update record <br/> Record may have been modified by another user <br/> Please refresh data'
	GOTO ENDERROR
END


RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
	   RAISERROR (@ErrMsg_VC, 16, 1)
	 RETURN -1
   END


GO
/****** Object:  StoredProcedure [dbo].[userIdGet]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userIdGet]
(
	@_id uniqueIdentifier

)
As
Select  _id = _id, _ts = CONVERT(decimal,_ts + 0), name = rtrim(name), userGroup, reset, eMail, userId,pswd from userId 
Where _id = @_id



GO
/****** Object:  StoredProcedure [dbo].[userIdIns]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userIdIns]
(
	@name char(35),
	@createdBy char(35),
    @createdOn smallDateTime,
	@eMail varchar(100),
	@pswd char(36),
	@reset	bit,
	@userGroup uniqueIdentifier,
	@userId char(15)

)

AS

DECLARE @_id uniqueIdentifier
DECLARE @ErrMsg_VC  varchar(max)


-- Create New ID
Select @_id = newid() 

-- Insert Action
Insert into userId
(
_id,
name, 
pswd ,
reset,
userGroup ,
userId ,
eMail,
createdBy,
createdOn
)
Select
 @_id, 
@name,
@pswd ,
@reset,
@userGroup ,
@userId ,
@eMail,
@createdBy,
@createdOn


If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to insert record <br/>'
	GOTO ENDERROR
END

Select _id = @_id

RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
	 RAISERROR (25000,-1,-1, @ErrMsg_VC);
	 RETURN -1
   END




GO
/****** Object:  StoredProcedure [dbo].[userIdSel]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userIdSel]
(
	@_id uniqueIdentifier

)
As
Select  _id = A._id, _ts =  CONVERT(decimal, A._ts + 0), name = A.name, A.userId, [userGroup] = b.name from userId A Left Join userGroup B On A.userGroup = B._Id
Where @_id is Null or A._id  = @_id
order by name


GO
/****** Object:  StoredProcedure [dbo].[userIdUpd]    Script Date: 4/5/2016 7:59:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[userIdUpd]
(
	@_id uniqueIdentifier,
	@_ts bigInt,
	@name varchar(35),
	@eMail varchar(100),
	@pswd char(36),
	@reset	bit,
	@userGroup uniqueIdentifier,
	@userId char(15),
	@updatedBy char(35),
    @updatedOn smallDateTime


)


AS


DECLARE @ErrMsg_VC  varchar(200)

UPDATE userId set 
name = @name , 
email =	@eMail,
pswd = 	@pswd ,
reset =	@reset,
userGroup = @userGroup,
userId =	@userId,
updatedBy = @updatedBy,  
updatedOn = @updatedOn
WHERE _id =  @_id and CONVERT(decimal, _ts + 0) = @_ts

If @@rowCount = 0
BEGIN
	Select @ErrMsg_Vc = 'Unable to update record <br/> Record may have been modified by another user <br/> Please refresh data'
	GOTO ENDERROR
END


RETURN  

-- **************
-- Error Handling
-- **************

ENDERROR:
   BEGIN
    RAISERROR (@ErrMsg_VC, 16, 1)
	RETURN -1
   END





GO
