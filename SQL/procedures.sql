USE BarProject

--------------------UNITS--------------------
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

CREATE PROCEDURE updateUnit
    @id                 INT,
    @new_unit_name      NVARCHAR(32),
    @new_convert_factor FLOAT,
    @new_unit_type      INT
AS BEGIN
  IF EXISTS(SELECT *
            FROM units
            WHERE id = @id)
    BEGIN
      IF @new_unit_name != ''
        BEGIN
          UPDATE Units
          SET unit_name = @new_unit_name
          WHERE id = @id
        END
      IF EXISTS(SELECT *
                FROM UnitTypes
                WHERE id = @new_unit_type)
        BEGIN
          UPDATE Units
          SET unit_type = @new_unit_type
          WHERE id = @id
        END
      IF @new_convert_factor > 0
        BEGIN
          UPDATE Units
          SET convert_factor = @new_convert_factor
          WHERE id = @id
        END
    END
END
GO

--------------------EMPLOYEES--------------------

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


--------------------USERS--------------------

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

--------------------TAXES--------------------
CREATE PROCEDURE addTax
    @tax_name  NVARCHAR(32),
    @tax_value FLOAT
AS BEGIN
  IF (SELECT COUNT(*)
      FROM Taxes
      WHERE tax_name = @tax_name) = 0
    BEGIN
      INSERT INTO Taxes (tax_name, tax_value) VALUES
        (@tax_name, @tax_value)
    END
END
GO

CREATE PROCEDURE deleteTax
    @tax_name NVARCHAR(32)
AS BEGIN
  DELETE FROM Taxes
  WHERE tax_name = @tax_name
END
GO

CREATE PROCEDURE updateTax
    @id            INT,
    @new_tax_name  NVARCHAR(32),
    @new_tax_value FLOAT
AS BEGIN
  IF EXISTS(SELECT *
            FROM Taxes
            WHERE id = @id)
    BEGIN
      IF @new_tax_name != ''
        BEGIN
          UPDATE Taxes
          SET tax_name = @new_tax_name, tax_value = @new_tax_value
          WHERE id = @id
        END
    END
END
GO

--------------------CATEGORIES--------------------

CREATE PROCEDURE addCategory
    @id                  INT,
    @category_name       NVARCHAR(64),
    @slug                NVARCHAR(32),
    @overriding_category INT
AS BEGIN
  IF (SELECT COUNT(*)
      FROM Categories
      WHERE id = @id) = 0 AND (@overriding_category = 0 OR @overriding_category != 0 AND
                                                           EXIST(SELECT * FROM Categories WHERE
                                                                 id = @overriding_category))
    BEGIN
      INSERT INTO Categories (id, category_name, slug, overriding_categpry) VALUES
        (@id, @category_name, @slug, @overriding_categpry)
    END

END
