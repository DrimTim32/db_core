--drop procedure addUser
--drop function getSeed
--drop procedure getSalt
--drop procedure getRandom
--drop procedure userExists
--------------------UTILS-------------------

CREATE PROCEDURE getRandom
(
@Seed INT,
@Random FLOAT OUTPUT
)
AS
	BEGIN  
	SELECT @Random = RAND(@Seed)  
	RETURN
	END
GO


CREATE FUNCTION getSeed()
RETURNS INT
AS
	BEGIN 
		DECLARE @CTime DATETIME;
		SET @CTime = GETDATE();
		RETURN (DATEPART(hh, @Ctime) * 10000000) + (DATEPART(n, @CTime) * 100000) 
			+ (DATEPART(s, @CTime) * 1000) + DATEPART(ms, @CTime); 
	END;
GO  
 
CREATE PROCEDURE getSalt
( 
@Salt CHAR(25) OUTPUT
) 
AS
	BEGIN 
		DECLARE @Seed INT;
		EXEC @Seed = dbo.getSeed

		DECLARE @LCV TINYINT;
		SET @LCV = 1; 
		 
		DECLARE @Random FLOAT;
		
		EXEC getRandom @Seed, @Random OUTPUT

		SELECT @Salt = CHAR(ROUND((RAND(@Seed) * 94.0) + 32, 3));
		WHILE (@LCV < 25)
			BEGIN
				SET @Salt =  CONCAT(CHAR(ROUND((RAND() * 94.0) + 32, 3)),@SALT)
				SET @LCV = @LCV + 1;
			END; 
		RETURN
	END
GO

--------------------USERS--------------------

CREATE PROCEDURE addUser
@password NVARCHAR(128),
@username NVARCHAR(64),
@name     NVARCHAR(64),
@surname  NVARCHAR(64),
@permission TINYINT
AS
	BEGIN
		IF  (Exists(SELECT Username FROM Users WHERE username=@username))
			    return 1;
		ELSE
			BEGIN
				DECLARE @Salt CHAR(25);  
				DECLARE @Hash VARBINARY(20)
				EXEC getSalt @Salt OUTPUT  
				SET @Hash = HASHBYTES('SHA1', @Salt + @password)
				INSERT INTO Users
				(username,password,password_salt,name,surname,permission)
				VALUES
				(@username,@Hash,@Salt,@name,@surname,@permission)
			END
	END
GO

CREATE PROCEDURE userExists
(
@login  NVARCHAR(64)
)
AS
	BEGIN
		IF EXISTS (SELECT username from Users WHERE @login = username)
			RETURN 1
		ELSE
			RETURN -1
	END
GO 
 
CREATE PROCEDURE checkCredentials
(
@username NVARCHAR(64),
@password NVARCHAR(128),
@tmp_credentials SMALLINT OUTPUT
)
AS
	BEGIN
		DECLARE @Salt CHAR(25);  
		DECLARE @Hash VARBINARY(20);
		SET @tmp_credentials  = NULL ;
		DECLARE @TMPUSER TABLE
		(
		  username      NVARCHAR(64),
		  password      VARBINARY(20),
		  password_salt CHAR(25),
		  permission TINYINT
		);
		INSERT INTO @TMPUSER SELECT username,password,password_salt,permission FROM USERS WHERE username = @username
		IF EXISTS (SELECT * FROM @TMPUSER)
		BEGIN
			SELECT @Salt = T.password_salt FROM @TMPUSER T 
			SET @Hash = HASHBYTES('SHA1', @Salt + @password) 
			SELECT @tmp_credentials = 
					(select P.value from EmployePermissions P 
							where P.id 	= (select T.permission from @TMPUSER T WHERE T.password = @Hash))
		END 
	END
GO

create procedure createInternalError (
	@error_name NVARCHAR(64),
	@error_time datetime,
	@message NVARCHAR(3000),
	@stack_trace NVARCHAR(1000),
	@context NVARCHAR(900),
	@inner_message NVARCHAR(400)
)
as
begin
	insert into InternalErrors (error_name, error_time, message, stack_trace, context, inner_message)
	values (@error_name, @error_time, @message, @stack_trace, @context, @inner_message)
end
go
