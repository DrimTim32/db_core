USE BarProject


INSERT INTO EmployePermissions (name, value)
VALUES
  (N'admin', 255),
  (N'Owner', 127),
  (N'WarehouseAdministrator', 16),
  (N'Cook', 2),
  (N'Waitresss', 1),
  (N'NoUser', 0)
GO

DECLARE @return_value INT

EXEC @return_value = [dbo].[addUser]
    @password = N'qwerty',
    @username = N'malin',
    @name = N'marcin',
    @surname = N'malinowski',
    @permission = 1
GO

DECLARE @return_value INT
EXEC @return_value = [dbo].[addUser]
    @password = N'gogo',
    @username = N'gogo',
    @name = N'gogo',
    @surname = N'gogo',
    @permission = 1
GO

DECLARE @return_value INT,
@tmp_credentials SMALLINT

EXEC @return_value = [dbo].[checkCredentials]
    @username = N'malin',
    @password = N'qwerty',
    @tmp_credentials = @tmp_credentials OUTPUT
SELECT @tmp_credentials AS N'@tmp_credentials'
