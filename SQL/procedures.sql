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
