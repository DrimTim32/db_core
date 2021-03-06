USE BarProject
GO

CREATE FUNCTION productsByCategory(@category_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             id,
                             name,
                             price
                           FROM Products
                             JOIN productsLastPrices ON id = product_id
                           WHERE category_id = @category_id)
GO


CREATE FUNCTION recipeDetails(@recipe_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             recipe_id,
                             ingredient_id,
                             name AS ingredient_name,
                             quantity
                           FROM Ingredients AS I
                             JOIN Recipes AS R ON I.recipe_id = R.id
                             JOIN Products AS P ON ingredient_id = P.id
                           WHERE recipe_id = @recipe_id)
GO

CREATE FUNCTION productDetails(@product_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             PR.id,
                             name,
                             category_id,
                             category_name,
                             unit_id,
                             unit_name,
                             tax_id,
                             tax_name,
                             tax_value
                           FROM Products AS PR
                             JOIN Categories AS C ON PR.category_id = C.id
                             JOIN Taxes AS T ON PR.tax_id = T.id
                             JOIN Units AS U ON PR.unit_id = U.id
                           WHERE PR.id = @product_id)
GO


CREATE FUNCTION soldProductDetails(@product_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             product_id,
                             name,
                             category_id,
                             category_name,
                             unit_id,
                             unit_name,
                             tax_id,
                             tax_name,
                             tax_value,
                             recipe_id,
                             period_start,
                             price
                           FROM ProductsSold AS PRS
                             JOIN Products AS PR ON PRS.id = PR.id
                             JOIN Categories AS C ON PR.category_id = C.id
                             JOIN Taxes AS T ON PR.tax_id = T.id
                             JOIN Units AS U ON PR.unit_id = U.id
                             JOIN (SELECT
                                     product_id,
                                     price,
                                     period_start
                                   FROM Prices
                                   WHERE period_start = (SELECT MAX(period_start)
                                                         FROM Prices AS P2
                                                         WHERE
                                                           P2.product_id = @product_id)) AS P
                               ON PRS.id = P.product_id
                           WHERE PRS.id = @product_id)
GO

CREATE FUNCTION pricesHistory(@product_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             price,
                             period_start
                           FROM Prices
                           WHERE product_id = @product_id)
GO


CREATE FUNCTION getLocation(
  @id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            name,
            address,
            city,
            postal_code,
            country,
            phone
          FROM Locations
          WHERE id = @id)


--WAREHOUSE
GO
CREATE FUNCTION getWarehouseProductQuantity(
  @location_id         INT,
  @product_in_stock_id INT
)
  RETURNS SMALLINT
AS
  BEGIN
    DECLARE @quantity SMALLINT
    SET @quantity = (SELECT quantity
                     FROM Warehouse
                     WHERE location_id = @location_id AND product_in_stock_id = @product_in_stock_id)
    RETURN @quantity
  END


GO
CREATE FUNCTION getWarehouseProduct(
  @product_in_stock_id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT *
          FROM Warehouse_pretty
          WHERE product_id = @product_in_stock_id)



--SUPPLIERS
GO
CREATE FUNCTION getSupplier(
  @id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            name,
            address,
            city,
            postal_code,
            country,
            contact_name,
            phone,
            fax,
            website
          FROM Suppliers
          WHERE id = @id)


--WAREHOUSE_ORDERS
GO
CREATE FUNCTION getWarehouseOrder(
  @id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            employee_id,
            supplier_id,
            location_id,
            order_date,
            required_date,
            delivery_date
          FROM Warehouse_orders
          WHERE id = @id)

GO
CREATE FUNCTION getWarehouseOrderPretty(
  @id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT *
          FROM Warehouse_orders_pretty
          WHERE id = @id)


--WAREHOUSE_ORDER_DETAILS
GO
CREATE FUNCTION getWarehouseOrderDetails(
  @warehouse_order_id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            product_id,
            unit_price,
            quantity
          FROM Warehouse_order_details
          WHERE warehouse_order_id = @warehouse_order_id)

GO
CREATE FUNCTION getWarehouseOrderDetailsPretty(
  @warehouse_order_id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            name,
            category_name,
            purchase_price,
            quantity
          FROM Warehouse_order_details_pretty
          WHERE id = @warehouse_order_id)


GO
CREATE FUNCTION getWarehouseOrderValue(
  @warehouse_order_id INT
)
  RETURNS MONEY
AS
  BEGIN
    DECLARE @result MONEY
    SET @result = (SELECT sum(unit_price * quantity) value
                   FROM Warehouse_order_details
                   WHERE warehouse_order_id = @warehouse_order_id)
    RETURN @result
  END

--SPOTS
GO
CREATE FUNCTION getSpot(
  @id INT
)
  RETURNS NVARCHAR(40)
AS
  BEGIN
    DECLARE @name NVARCHAR(40)
    SET @name = (SELECT name
                 FROM Spots
                 WHERE id = @id)
    RETURN @name
  END


--CLIENT_ORDERS
GO
CREATE FUNCTION getClientOrder(
  @id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            spot_id,
            employee_id,
            order_time,
            payment_time
          FROM Client_orders
          WHERE id = @id)


--CLIENT_ORDER_DETAILS
GO
CREATE FUNCTION getClientOrderDetails(
  @client_order_id INT
)
  RETURNS TABLE
AS
  RETURN (SELECT
            products_sold_id,
            quantity
          FROM Client_order_details
          WHERE client_order_id = @client_order_id)

GO
CREATE FUNCTION getClientOrderValue(
  @client_order_id INT
)
  RETURNS MONEY
AS
  BEGIN
    DECLARE @result MONEY
    SET @result = (SELECT sum(PLP.price * COD.quantity) value
                   FROM Client_order_details COD
                     JOIN productsLastPrices PLP ON COD.products_sold_id = PLP.product_id
                   WHERE COD.client_order_id = @client_order_id)
    RETURN @result
  END

--WORKSTATIONS
GO
CREATE FUNCTION getWorkstation(
  @id INT
)
  RETURNS NVARCHAR(40)
AS
  BEGIN
    DECLARE @name NVARCHAR(40)
    SET @name = (SELECT name
                 FROM Workstations
                 WHERE id = @id)
    RETURN @name
  END

--WORKSTATION_RIGHTS
GO
CREATE FUNCTION getWorkstationRights(
  @workstation_id INT
)
  RETURNS TABLE
AS

  RETURN (SELECT employe_permissions
          FROM Workstation_rights
          WHERE workstation_id = @workstation_id)