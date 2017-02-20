USE BarProject
GO

--------------------UNITS--------------------

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


--------------------RECIPES--------------------

CREATE PROCEDURE addRecipe
    @description NVARCHAR(512)
AS BEGIN
  INSERT INTO Recipes (description) VALUES
    (@description)
END
GO

CREATE PROCEDURE updateRecipe
    @id              INT,
    @new_description NVARCHAR(512)
AS BEGIN
  IF @new_description != ''
    BEGIN
      UPDATE Recipes
      SET description = @new_description
      WHERE id = @id
    END
END
GO

CREATE PROCEDURE addIngredient
    @recipe_id     INT,
    @ingredient_id INT,
    @quantity      FLOAT
AS BEGIN
  INSERT INTO Ingredients (recipe_id, ingredient_id, quantity) VALUES
    (@recipe_id, @ingredient_id, @quantity)
END
GO


CREATE PROCEDURE updateIngredient
    @recipe_id     INT,
    @ingredient_id INT,
    @new_quantity  FLOAT
AS BEGIN
  UPDATE Ingredients
  SET quantity = @new_quantity
  WHERE recipe_id = @recipe_id AND ingredient_id = @ingredient_id
END
GO

CREATE PROCEDURE removeRecipe
    @id INT
AS BEGIN
  DELETE FROM Recipes
  WHERE id = @id
END
GO

CREATE PROCEDURE removeIngredient
    @recipe_id     INT,
    @ingredient_id INT
AS BEGIN
  DELETE FROM Ingredients
  WHERE ingredient_id = @ingredient_id AND recipe_id = @recipe_id
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
  RETURN IDENT_CURRENT('Products')
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

CREATE PROCEDURE changeRecipe
    @product_id INT,
    @new_recipe INT
AS BEGIN
  UPDATE ProductsSold
  SET recipe_id = @new_recipe
  WHERE id = @product_id
END
GO

CREATE PROCEDURE addStoredProduct
    @product_id INT
AS BEGIN
  IF NOT EXISTS(SELECT *
                FROM ProductsSold
                WHERE id = @product_id AND recipe_id IS NOT NULL)
    BEGIN
      INSERT INTO ProductsStored (id) VALUES
        (@product_id)
    END
END
GO

CREATE PROCEDURE addSoldProduct
    @product_id INT,
    @recipe_id  INT
AS BEGIN
  BEGIN
    INSERT INTO ProductsSold (id, recipe_id) VALUES
      (@product_id, @recipe_id)
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
    @new_price  MONEY
AS BEGIN
  DECLARE @current_price MONEY
  SET @current_price = (SELECT price
                        FROM productsLastPrices
                        WHERE product_id = @priduct_id)
  IF @current_price IS NULL OR @current_price != @new_price
    BEGIN
      INSERT INTO Prices (product_id, period_start, price) VALUES
        (@priduct_id, GETDATE(), @new_price)
    END
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

-----------------WAREHOUSE----------------\

CREATE PROCEDURE markDelivered
    @id INT
AS BEGIN
  UPDATE Warehouse_orders
  SET delivery_date = dateadd(HOUR, 2, getdate())
  WHERE id = @id
END
GO

CREATE PROCEDURE markPaid
    @id INT
AS BEGIN
  UPDATE Client_orders
  SET payment_time = dateadd(HOUR, 2, getdate())
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

CREATE PROCEDURE addLocation
  (@name        NVARCHAR(40),
   @address     NVARCHAR(60),
   @city        NVARCHAR(15),
   @postal_code NVARCHAR(10),
   @country     NVARCHAR(15),
   @phone       NVARCHAR(25)
  )
AS
  BEGIN
    INSERT INTO Locations (name, address, city, postal_code, country, phone)
    VALUES (@name, @address, @city, @postal_code, @country, @phone)

  END
-- REMOVE
GO
CREATE PROCEDURE removeLocation
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Locations
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateLocation
  (@id              INT,
   @new_name        NVARCHAR(40),
   @new_address     NVARCHAR(60),
   @new_city        NVARCHAR(15),
   @new_postal_code NVARCHAR(10),
   @new_country     NVARCHAR(15),
   @new_phone       NVARCHAR(25)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Locations
      SET name = @new_name
      WHERE id = @id
    IF @new_address != ''
      UPDATE Locations
      SET address = @new_address
      WHERE id = @id
    IF @new_city != ''
      UPDATE Locations
      SET city = @new_city
      WHERE id = @id
    IF @new_postal_code != ''
      UPDATE Locations
      SET postal_code = @new_postal_code
      WHERE id = @id
    IF @new_country != ''
      UPDATE Locations
      SET country = @new_country
      WHERE id = @id
    IF @new_phone != ''
      UPDATE Locations
      SET phone = @new_phone
      WHERE id = @id
  END

--------------------SUPPLIERS--------------------
-- ADD
GO
CREATE PROCEDURE addSupplier
  (
    @name         NVARCHAR(40),
    @address      NVARCHAR(60),
    @city         NVARCHAR(15),
    @postal_code  NVARCHAR(10),
    @country      NVARCHAR(15),
    @contact_name NVARCHAR(30),
    @phone        NVARCHAR(25),
    @fax          NVARCHAR(25),
    @website      NVARCHAR(MAX)
  )
AS
  BEGIN
    INSERT INTO Suppliers (name, address, city, postal_code, country, contact_name, phone, fax, website)
    VALUES (@name, @address, @city, @postal_code, @country, @contact_name, @phone, @fax, @website)
  END
-- REMOVE
GO
CREATE PROCEDURE removeSupplier
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Suppliers
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateSupplier
  (@id               INT,
   @new_name         NVARCHAR(40),
   @new_address      NVARCHAR(60),
   @new_city         NVARCHAR(15),
   @new_postal_code  NVARCHAR(10),
   @new_country      NVARCHAR(15),
   @new_contact_name NVARCHAR(30),
   @new_phone        NVARCHAR(25),
   @new_fax          NVARCHAR(25),
   @new_website      NVARCHAR(MAX)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Suppliers
      SET name = @new_name
      WHERE id = @id
    IF @new_address != ''
      UPDATE Suppliers
      SET address = @new_address
      WHERE id = @id
    IF @new_city != ''
      UPDATE Suppliers
      SET city = @new_city
      WHERE id = @id
    IF @new_postal_code != ''
      UPDATE Suppliers
      SET postal_code = @new_postal_code
      WHERE id = @id
    IF @new_country != ''
      UPDATE Suppliers
      SET country = @new_country
      WHERE id = @id
    IF @new_contact_name != ''
      UPDATE Suppliers
      SET contact_name = @new_contact_name
      WHERE id = @id
    IF @new_phone != ''
      UPDATE Suppliers
      SET phone = @new_phone
      WHERE id = @id
    IF @new_fax != ''
      UPDATE Suppliers
      SET fax = @new_fax
      WHERE id = @id
    IF @new_website != ''
      UPDATE Suppliers
      SET website = @new_website
      WHERE id = @id
  END

--------------------SPOTS--------------------
-- ADD
GO
CREATE PROCEDURE addSpot
  (
    @name        NVARCHAR(40),
    @location_id INT
  )
AS
  BEGIN
    INSERT INTO Spots (name, location_id)
    VALUES (@name, @location_id)
  END
-- REMOVE
GO
CREATE PROCEDURE removeSpot
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Spots
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateSpot
  (@id       INT,
   @new_name NVARCHAR(40)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Spots
      SET name = @new_name
      WHERE id = @id
  END
--------------------WORKSTATIONS--------------------
-- ADD
GO
CREATE PROCEDURE addWorkstation
  (
    @name        NVARCHAR(40),
    @location_id INT
  )
AS
  BEGIN
    INSERT INTO Workstations (name, location_id)
    VALUES (@name, @location_id)
  END
-- REMOVE
GO
CREATE PROCEDURE removeWorkstation
    @id INT
AS
  BEGIN
    DELETE FROM Workstations
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWorkstation
  (@id              INT,
   @new_location_id INT,
   @new_name        NVARCHAR(40)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Workstations
      SET name = @new_name
      WHERE id = @id
    UPDATE Workstations
    SET location_id = @new_location_id
    WHERE id = @id
  END
--------------------WAREHOUSE--------------------
-- ADD to
/*
	location_id int not null,
	product_in_stock_id int not null,
	quantity smallint not null,
	primary key (location_id, product_in_stock_id),
	foreign key (location_id) references Locations(id),
	foreign key (product_in_stock_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodno?? nazwy)
	on delete cascade
*/
GO
CREATE PROCEDURE addToWarehouse
  (
    @location_id         INT,
    @product_in_stock_id INT,
    @quantity            SMALLINT
  )
AS
  BEGIN
    INSERT INTO Warehouse (location_id, product_in_stock_id, quantity)
    VALUES (@location_id, @product_in_stock_id, @quantity)
  END
-- REMOVE from
GO
CREATE PROCEDURE removeFromWarehouse -- usuwa caly wierz, a NIE zmniejsza o 1
  (@location_id         INT,
   @product_in_stock_id INT
  )
AS
  BEGIN
    DELETE FROM Warehouse
    WHERE location_id = @location_id
          AND product_in_stock_id = @product_in_stock_id
  END
-- UPDATE quantity
GO
CREATE PROCEDURE updateQuantityInWarehouse -- argument mowi o ile zwiekszyc/zmniejszyc quantity produktu w magazynie
  (
    @location_id         INT,
    @product_in_stock_id INT,
    @quantity_change     SMALLINT
  )
AS
  BEGIN
    UPDATE Warehouse
    SET quantity = quantity + @quantity_change
    WHERE location_id = @location_id
          AND product_in_stock_id = @product_in_stock_id

  END
GO

--------------------WORKSTATION RIGHTS--------------------
-- ADD
GO
CREATE PROCEDURE addWorkstationRights
  (@workstation_id     INT,
   @employe_permission TINYINT
  )
AS
  BEGIN
    INSERT INTO Workstation_rights (workstation_id, employe_permissions)
    VALUES (@workstation_id, @employe_permission)
  END

-- REMOVE
GO
CREATE PROCEDURE removeWorkstationRights
  (@workstation_id     INT,
   @employe_permission TINYINT
  )
AS
  BEGIN
    DELETE FROM Workstation_rights
    WHERE workstation_id = @workstation_id AND employe_permissions = @employe_permission
  END
--------------------WAREHOUSE ORDERS--------------------
-- ADD
GO
CREATE PROCEDURE addWarehouseOrder
  (@employee_id   INT,
   @supplier_id   INT,
   @location_id   INT,
   @order_date    DATETIME,
   @required_date DATETIME,
   @delivery_date DATETIME
  )
AS
  BEGIN
    INSERT INTO Warehouse_orders (employee_id, supplier_id, location_id, order_date, required_date, delivery_date)
    VALUES (@employee_id, @supplier_id, @location_id, @order_date, @required_date, @delivery_date)

  END
-- REMOVE
GO
CREATE PROCEDURE removeWarehouseOrder
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Warehouse_orders
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWarehouseOrder
  (@id                INT,
   @new_employee_id   INT,
   @new_supplier_id   INT,
   @new_location_id   INT,
   @new_order_date    DATETIME,
   @new_required_date DATETIME,
   @new_delivery_date DATETIME
  )
AS
  BEGIN
    IF @new_employee_id > 0
      UPDATE Warehouse_orders
      SET employee_id = @new_employee_id
      WHERE id = @id
    IF @new_supplier_id > 0
      UPDATE Warehouse_orders
      SET supplier_id = @new_supplier_id
      WHERE id = @id
    IF @new_location_id > 0
      UPDATE Warehouse_orders
      SET location_id = @new_location_id
      WHERE id = @id
    IF @new_order_date IS NOT NULL
      UPDATE Warehouse_orders
      SET order_date = @new_order_date
      WHERE id = @id
    IF @new_required_date IS NOT NULL
      UPDATE Warehouse_orders
      SET required_date = @new_required_date
      WHERE id = @id
    IF @new_delivery_date IS NOT NULL
      UPDATE Warehouse_orders
      SET delivery_date = @new_delivery_date
      WHERE id = @id
  END

--------------------CLIENT ORDERS--------------------
-- ADD
GO
CREATE PROCEDURE addClientOrder
  (@spot_id      INT,
   @employee_id  INT,
   @order_time   DATETIME,
   @payment_time DATETIME
  )
AS
  BEGIN
    INSERT INTO Client_orders (spot_id, employee_id, order_time, payment_time)
    VALUES (@spot_id, @employee_id, @order_time, @payment_time)

  END
-- REMOVE
GO
CREATE PROCEDURE removeClientOrder
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Client_orders
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateClientOrder
  (@id               INT,
   @new_spot_id      INT,
   @new_employee_id  INT,
   @new_order_time   DATETIME,
   @new_payment_time DATETIME
  )
AS
  BEGIN
    IF @new_spot_id > 0
      UPDATE Client_orders
      SET spot_id = @new_spot_id
      WHERE id = @id
    IF @new_employee_id > 0
      UPDATE Client_orders
      SET employee_id = @new_employee_id
      WHERE id = @id
    IF @new_order_time IS NOT NULL
      UPDATE Client_orders
      SET order_time = @new_order_time
      WHERE id = @id
    IF @new_payment_time IS NOT NULL
      UPDATE Client_orders
      SET payment_time = @new_payment_time
      WHERE id = @id
  END

--------------------WAREHOUSE ORDER DETAILS--------------------
-- ADD
GO
CREATE PROCEDURE addWarehouseOrderDetail -- OK
  (@warehouse_order_id INT,
   @product_id         INT,
   @unit_price         MONEY,
   @quantity           SMALLINT
  )
AS
  BEGIN
    INSERT INTO Warehouse_order_details (warehouse_order_id, product_id, unit_price, quantity)
    VALUES (@warehouse_order_id, @product_id, @unit_price, @quantity)

  END
-- REMOVE
GO
CREATE PROCEDURE removeWarehouseOrderDetail --trigger do usuwania ordera jak nie ma order details�w -- OK
  (@warehouse_order_id INT,
   @product_id         INT
  )
AS
  BEGIN
    DELETE FROM Warehouse_order_details
    WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWarehouseOrderDetail
  (@warehouse_order_id INT,
   @product_id         INT,
   @new_unit_price     MONEY,
   @new_quantity       SMALLINT
  )
AS
  BEGIN
    IF @new_unit_price > 0
      UPDATE Warehouse_order_details
      SET unit_price = @new_unit_price
      WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id
    IF @new_quantity > 0
      UPDATE Warehouse_order_details
      SET quantity = @new_quantity
      WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id
  END

--------------------CLIENT ORDER DETAILS--------------------
-- ADD
GO
CREATE PROCEDURE addClientOrderDetail --trigger do pobierania aktualnej ceny produktu -- OK
  (@client_order_id  INT,
   @products_sold_id INT,
   @quantity         SMALLINT
  )
AS
  BEGIN
    INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity)
    VALUES (@client_order_id, @products_sold_id, @quantity)

  END
-- REMOVE
GO
CREATE PROCEDURE removeClientOrderDetail --trigger do usuwania ordera jak nie ma order details�w -- OK
  (@client_order_id  INT,
   @products_sold_id INT
  )
AS
  BEGIN
    DELETE FROM Client_order_details
    WHERE client_order_id = @client_order_id AND products_sold_id = @products_sold_id
  END
-- UPDATE
GO
CREATE PROCEDURE updateClientOrderDetail
  (@client_order_id  INT,
   @products_sold_id INT,
   @new_quantity     SMALLINT
  )
AS
  BEGIN
    IF @new_quantity > 0
      UPDATE Client_order_details
      SET quantity = @new_quantity
      WHERE client_order_id = @client_order_id AND products_sold_id = @products_sold_id
  END
