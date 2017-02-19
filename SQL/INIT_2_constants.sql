USE BarProject
GO

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


INSERT INTO UnitTypes (type_name) VALUES
  ('vol'),
  ('mass'),
  ('piece')

INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
  ('szt.', 1, 3),
  ('kg', 1, 2),
  ('dag', 100, 2),
  ('l', 1, 1),
  ('ml', 1000, 1)

INSERT INTO Taxes (tax_name, tax_value) VALUES
  ('VAT 23 %', 0.23),
  ('VAT 7%', 0.08)