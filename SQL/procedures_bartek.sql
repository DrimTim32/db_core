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
      WHERE id = @id) = 0 AND
     (@overriding_category = 0 OR @overriding_category != 0 AND EXISTS(SELECT *
                                                                       FROM Categories
                                                                       WHERE
                                                                         id = @overriding_category))
    BEGIN
      INSERT INTO Categories (id, category_name, slug, overriding_category) VALUES
        (@id, @category_name, @slug, @overriding_category)
    END

END


CREATE PROCEDURE removeCategory
  @category_id int
AS BEGIN
  if EXISTS(select * from Categories where id = @category_id)
    BEGIN
      DELETE FROM Categories WHERE id = @category_id
    END

END

  --------------------RECEIPTS--------------------

  CREATE PROCEDURE addReceipt
      @description NVARCHAR(512)
  AS BEGIN
    INSERT INTO Receipts (description) VALUES
      (@description)
  END


  CREATE PROCEDURE addIngredient
      @receipt_id    INT,
      @ingredient_id INT,
      @quantity      FLOAT
  AS BEGIN
    IF (SELECT COUNT(*)
        FROM Ingredients
        WHERE receipt_id = @receipt_id AND ingredient_id = @ingredient_id) = 0
      BEGIN
        IF EXISTS(SELECT *
                  FROM Receipts
                  WHERE id = @receipt_id) AND
           EXISTS(SELECT *
                  FROM ProductsStored
                  WHERE id = @ingredient_id)
          BEGIN
            INSERT INTO Ingredients (receipt_id, ingredient_id, quantity) VALUES
              (@receipt_id, @ingredient_id, @quantity)
          END
      END
  END

  --------------------PRODUCTS--------------------

  CREATE PROCEDURE addProduct
  AS BEGIN

  END

  CREATE PROCEDURE addStoredProduct
      @product_id INT
  AS BEGIN
    IF EXISTS(SELECT *
              FROM Products
              WHERE id = @product_id) AND
       NOT EXISTS(SELECT *
                  FROM ProductsSold
                  WHERE id = @product_id AND receipt_id IS NOT NULL)
      BEGIN
        INSERT INTO ProductsStored (id) VALUES
          (@product_id)
      END
  END

  CREATE PROCEDURE addSoldProduct
      @product_id INT,
      @receipt_id INT
  AS BEGIN

  END

