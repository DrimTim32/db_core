USE BarProject
GO
-- Dodawanie administratora systemu ( z niego ida zapytania do SQL)
CREATE USER bar_admin WITH PASSWORD = ')5T+tdH,%8wK&<)' 
GRANT EXECUTE TO bar_admin
sp_addrolemember 'db_datawriter', bar_admin

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

INSERT INTO Taxes(tax_name, tax_value) VALUES
  ('VAT 23 %', 0.23),
  ('VAT 7%', 0.08)
  
INSERT INTO EmployePermissions(name,id)
VALUES (N'admin',255)

  -- dodawanie osoby o podwyzszonych uprawnieniach 
EXEC	[dbo].[AddEmployee]
		@name = N'Marcin',
		@surname = N'Malinowski',
		@phone = N'+48123123123',
		@position = 255
		 

exec  [dbo].[AddUserByInfo]
		@password = N'qwerty',
		@username = N'malin',
		@name = 'Marcin',
		@surname = 'Malinowski'
