USE BAR

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
      IF (@new_unit_name != '')
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
      IF (@new_convert_factor > 0)
        BEGIN
          UPDATE Units
          SET convert_factor = @new_convert_factor
          WHERE id = @id
        END
    END
END
GO


--------------------TAXES--------------------
CREATE PROCEDURE addTax
    @tax_name  NVARCHAR(32),
    @tax_value FLOAT AS BEGIN
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
    @new_tax_value FLOAT AS BEGIN
  IF EXISTS(SELECT *
            FROM Taxes
            WHERE id = @id)
    BEGIN
      IF (@new_tax_name != '')
        BEGIN
          UPDATE Taxes
          SET tax_name = @new_tax_name, tax_value = @new_tax_value
          WHERE id = @id
        END
    END
END
GO

--------------------CATEGORIES--------------------