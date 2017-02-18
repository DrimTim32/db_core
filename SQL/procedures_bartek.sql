USE BarProject

--------------------UNITS--------------------
GO
CREATE PROCEDURE addUnit(
  @unit_name      NVARCHAR(32),
  @convert_factor FLOAT,
  @unit_type      INT)
AS BEGIN
  INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
    (@unit_name, @convert_factor, @unit_type)
END
GO


CREATE PROCEDURE removeUnit
    @unit_id INT
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
AS BEGIN
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
    @tax_id INT
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
      SET tax_name = @new_tax_name
      WHERE id = @id
    END
  UPDATE Taxes
  SET tax_value = @new_tax_value
  WHERE id = @id

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
GO


CREATE PROCEDURE removeCategory
    @category_id INT
AS BEGIN
  DELETE FROM Categories
  WHERE id = @category_id
END
GO

CREATE PROCEDURE updateCategory
    @id             INT,
    @new_slug       NVARCHAR(32),
    @new_name       NVARCHAR(64),
    @new_overriding INT
AS BEGIN
  IF @new_slug != ''
    BEGIN
      UPDATE Categories
      SET slug = @new_slug
      WHERE id = @id
    END
  IF @new_name != ''
    BEGIN
      UPDATE Categories
      SET category_name = @new_name
      WHERE id = @id
    END
  UPDATE Categories
  SET overriding_category = @new_overriding
  WHERE id = @id
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

CREATE PROCEDURE updateReceipt
    @id              INT,
    @new_description NVARCHAR(512)
AS BEGIN
  IF @new_description != ''
    BEGIN
      UPDATE Receipts
      SET description = @new_description
      WHERE id = @id
    END
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


CREATE PROCEDURE udpateIngredient
    @receipt_id    INT,
    @ingredient_id INT,
    @new_quantity  FLOAT
AS BEGIN
  UPDATE Ingredients
  SET quantity = @new_quantity
  WHERE receipt_id = @receipt_id AND ingredient_id = @ingredient_id
END
GO

CREATE PROCEDURE removeReceipt
    @id INT
AS BEGIN
  DELETE FROM Receipts
  WHERE id = @id
END
GO

CREATE PROCEDURE removeIngredient
    @receipt_id    INT,
    @ingredient_id INT
AS BEGIN
  DELETE FROM Ingredients
  WHERE ingredient_id = @ingredient_id AND receipt_id = @receipt_id
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
  SELECT IDENT_CURRENT('Products') AS RETURNVALUE
END
GO


CREATE PROCEDURE updateProduct
    @id           INT,
    @new_category INT,
    @new_unit     INT,
    @new_tax      INT,
    @new_name     NVARCHAR(128)
AS BEGIN
  UPDATE Products
  SET category_id = @new_category, unit_id = @new_unit, tax_id = @new_tax
  WHERE id = @id
  IF @new_name != ''
    BEGIN
      UPDATE Products
      SET name = @new_name
      WHERE id = @id
    END

END
GO

CREATE PROCEDURE changeReceipt
    @product_id  INT,
    @new_receipt INT
AS BEGIN
  UPDATE ProductsSold
  SET receipt_id = @new_receipt
  WHERE id = @product_id
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

--------------------LOG--------------------

CREATE PROCEDURE logLogin
    @username   NVARCHAR(63),
    @login_date DATETIME
AS BEGIN
  INSERT INTO LoginLog (username, login_time) VALUES
    (@username, @login_date)
END
GO

-----------------warehouse----------------\

CREATE PROCEDURE markDelivered
    @id INT
AS BEGIN
  UPDATE Warehouse_orders
  SET delivery_date = getdate()
  WHERE id = @id
END
GO

CREATE PROCEDURE markPaid
    @id INT
AS BEGIN
  UPDATE Client_orders
  SET payment_time = getdate()
  WHERE id = @id
END
GO

CREATE PROCEDURE changeStock
    @product_id      INT,
    @quantity_change SMALLINT,
    @location_id     INT
AS BEGIN
  IF NOT exists(SELECT *
                FROM Warehouse
                WHERE product_in_stock_id = @product_id AND location_id = @location_id)
    BEGIN
      EXEC addToWarehouse @location_id, @product_id, @quantity_change
    END
  ELSE
    BEGIN
      EXEC updateQuantityInWarehouse @location_id, @product_id, @quantity_change
    END

END
GO