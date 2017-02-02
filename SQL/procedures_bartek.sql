USE BarProject

--------------------UNITS--------------------

CREATE PROCEDURE addUnit
    @unit_name      NVARCHAR(32),
    @convert_factor FLOAT,
    @unit_type      INT
AS BEGIN
  INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
    (@unit_name, @convert_factor, @unit_type)
END
GO

CREATE PROCEDURE removeUnit
    @unit_id int
AS BEGIN
  DELETE FROM Units
  WHERE id = @unit_id
END
GO

CREATE PROCEDURE updateUnit
    @id                 INT,
    @new_unit_name      NVARCHAR(32),
    @new_convert_factor FLOAT,
    @new_unit_type      INT
AS BEGIN --TODO transakcja
  IF @new_unit_name != ''
    BEGIN
      UPDATE Units
      SET unit_name = @new_unit_name
      WHERE id = @id
    END
  UPDATE Units
  SET unit_type = @new_unit_type
  WHERE id = @id
  IF @new_convert_factor > 0
    BEGIN
      UPDATE Units
      SET convert_factor = @new_convert_factor
      WHERE id = @id
    END
END
GO

--------------------TAXES--------------------
CREATE PROCEDURE addTax
    @tax_name  NVARCHAR(32),
    @tax_value FLOAT
AS BEGIN
  INSERT INTO Taxes (tax_name, tax_value) VALUES
    (@tax_name, @tax_value)
END
GO

CREATE PROCEDURE removeTax
    @tax_id int
AS BEGIN
  DELETE FROM Taxes
  WHERE id = @tax_id
END
GO

CREATE PROCEDURE updateTax
    @id            INT,
    @new_tax_name  NVARCHAR(32),
    @new_tax_value FLOAT
AS BEGIN
  IF @new_tax_name != ''
    BEGIN
      UPDATE Taxes
      SET tax_name = @new_tax_name, tax_value = @new_tax_value
      WHERE id = @id
    END
END
GO

--------------------CATEGORIES--------------------

CREATE PROCEDURE addCategory
    @category_name       NVARCHAR(64),
    @slug                NVARCHAR(32),
    @overriding_category INT
AS BEGIN
  INSERT INTO Categories (category_name, slug, overriding_category) VALUES
    (@category_name, @slug, @overriding_category)
END


CREATE PROCEDURE removeCategory
    @category_id INT
AS BEGIN
  DELETE FROM Categories
  WHERE id = @category_id
END
GO


--------------------RECEIPTS--------------------

CREATE PROCEDURE addReceipt
    @description NVARCHAR(512)
AS BEGIN
  INSERT INTO Receipts (description) VALUES
    (@description)
END
GO


CREATE PROCEDURE addIngredient
    @receipt_id    INT,
    @ingredient_id INT,
    @quantity      FLOAT
AS BEGIN
  INSERT INTO Ingredients (receipt_id, ingredient_id, quantity) VALUES
    (@receipt_id, @ingredient_id, @quantity)
END
GO

--------------------PRODUCTS--------------------

CREATE PROCEDURE addProduct
    @category_id INT,
    @unit_id     INT,
    @tax_id      INT,
    @name        NVARCHAR(128)
AS BEGIN
  INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
    (@category_id, @unit_id, @tax_id, @name)
END
GO

CREATE PROCEDURE addStoredProduct
    @product_id INT
AS BEGIN
  IF NOT EXISTS(SELECT *
                FROM ProductsSold
                WHERE id = @product_id AND receipt_id IS NOT NULL)
    BEGIN
      INSERT INTO ProductsStored (id) VALUES
        (@product_id)
    END
END
GO

CREATE PROCEDURE addSoldProduct
    @product_id INT,
    @receipt_id INT
AS BEGIN
  BEGIN
    INSERT INTO ProductsSold (id, receipt_id) VALUES
      (@product_id, @receipt_id)
  END
END
GO

CREATE PROCEDURE removeProduct
    @product_id INT
AS BEGIN
  DELETE FROM Products
  WHERE id = @product_id
END
GO

CREATE PROCEDURE removeSoldProduct
    @product_id INT
AS BEGIN
  DELETE FROM ProductsSold
  WHERE id = @product_id
END
GO

CREATE PROCEDURE removeStoredProduct
    @product_id INT
AS BEGIN
  DELETE FROM ProductsStored
  WHERE id = @product_id
END
GO

CREATE PROCEDURE updatePrice
    @priduct_id INT,
    @new_price  FLOAT
AS BEGIN
  INSERT INTO Prices (product_id, period_start, price) VALUES
    (@priduct_id, GETDATE(), @new_price)
END
GO

