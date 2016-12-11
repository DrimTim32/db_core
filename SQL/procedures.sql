USE BAR

CREATE PROCEDURE addUnit
    @unit_name      NVARCHAR(32),
    @convert_factor FLOAT,
    @unit_type      INT
AS BEGIN
  IF (SELECT COUNT(*)
      FROM Units
      WHERE unit_name = @unit_name) = 0
    BEGIN
      INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
        (@unit_name, @convert_factor, @unit_type)
    END
END
GO


CREATE PROCEDURE deleteUnit
    @unit_name NVARCHAR(32)
AS BEGIN
  DELETE FROM Units
  WHERE unit_name = @unit_name
END
GO

create procedure AddEmployee
@name NVARCHAR(64),@surname NVARCHAR(64),@phone NVARCHAR(64),@position TINYINT
AS
BEGIN 
	IF  (EXISTS(SELECT surname FROM Employees WHERE surname=@surname AND name =@name))
		RETURN 1
	ELSE 
		BEGIN
			INSERT INTO Employees(name,surname,phone,position)
			VALUES
			(@name,@surname,@phone,@position)
		END
END
GO 

CREATE PROCEDURE AddUser
@password NVARCHAR(128),@username NVARCHAR(64), @user_id INT
AS 
	BEGIN
		IF  (Exists(SELECT Username FROM Users WHERE username=@username))
			    return 1;
		ELSE
			BEGIN
				  DECLARE @Seed INT;
				  DECLARE @LCV TINYINT;
				  DECLARE @CTime DATETIME;
				  DECLARE @Salt CHAR(25);
				  DECLARE @PwdWithSalt VARCHAR(125);
				  SET @CTime = GETDATE();
				  SET @Seed = (DATEPART(hh, @Ctime) * 10000000) + (DATEPART(n, @CTime) * 100000) 
					  + (DATEPART(s, @CTime) * 1000) + DATEPART(ms, @CTime);
				  SET @LCV = 1;
				  SET @Salt = CHAR(ROUND((RAND(@Seed) * 94.0) + 32, 3));
				    WHILE (@LCV < 25)
					  BEGIN
						SET @Salt =  CONCAT(CHAR(ROUND((RAND() * 94.0) + 32, 3)),@SALT)
					 SET @LCV = @LCV + 1;
					  END; 
				  SET @PwdWithSalt = @Salt + @password;
				INSERT INTO Users
				(user_id,username,password,password_salt)
				VALUES
				(@user_id,@username,HASHBYTES('SHA1', @PwdWithSalt),@Salt)
			END
	END
GO

CREATE PROCEDURE AddUserByInfo
@password NVARCHAR(128),@username NVARCHAR(64), @name NVARCHAR(64), @surname NVARCHAR(64)
AS 
BEGIN
	IF  (EXISTS(SELECT Username FROM Users WHERE username=@username))
			RETURN 1; 
	ELSE
	BEGIN
		DECLARE @id INT
		SET @id = (SELECT id FROM Employees WHERE @name = name and @surname = surname)
		IF @id is not Null
		BEGIN
			EXEC	AddUser
					@password = @password,
					@username = @username,
					@user_id = @id
		END
		ELSE
			RETURN 1
	END

END
GO
