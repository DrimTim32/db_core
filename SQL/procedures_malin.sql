--drop procedure addUser
--drop function getSeed
--drop procedure getHash
--drop procedure getRandom

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
@password NVARCHAR(128)
)
AS
	BEGIN
		DECLARE @Salt CHAR(25);  
		DECLARE @Hash VARBINARY(20);
		DECLARE @tmp_credentials TINYINT ;
		DECLARE @TMPUSER TABLE
		(
		  username      NVARCHAR(64),
		  password      VARBINARY(20),
		  password_salt CHAR(25),
		  permission TINYINT
		);
		INSERT INTO @TMPUSER SELECT username,password,password_salt FROM USERS WHERE username = @username
		IF EXISTS (SELECT * FROM @TMPUSER)
		BEGIN
			SET @Hash = HASHBYTES('SHA1', @Salt + @password) 
			SET @tmp_credentials = 0
			SELECT @tmp_credentials = permission FROM @TMPUSER WHERE password = @Hash
			IF permission != 0
				RETURN tmp_credentials
			ELSE
				RETURN tmp_credentials
		END
		ELSE
			RETURN -1
	END
GO