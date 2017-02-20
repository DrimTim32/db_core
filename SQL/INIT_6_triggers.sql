USE BarProject
GO

CREATE TRIGGER logUsage
  ON Client_order_details
AFTER INSERT
AS
  BEGIN
    DECLARE @order_id INT
    DECLARE @product_id INT
    DECLARE @quantity SMALLINT
    DECLARE inserted_cur CURSOR FOR SELECT
                                      client_order_id,
                                      products_sold_id,
                                      quantity
                                    FROM inserted
      FOR READ ONLY
    OPEN inserted_cur
    FETCH inserted_cur
    INTO @order_id, @product_id, @quantity
    WHILE @@fetch_status = 0
      BEGIN
        DECLARE @order_date DATE
        SET @order_date = convert(DATE, (SELECT order_time
                                         FROM Client_orders
                                         WHERE @order_id = Client_orders.id))
        IF NOT exists(SELECT *
                      FROM ProductsUsage
                      WHERE product_id = @product_id AND date = @order_date)
          BEGIN
            INSERT INTO ProductsUsage (product_id, date, quantity) VALUES
              (@product_id, @order_date, 0)
          END
        UPDATE ProductsUsage
        SET quantity = quantity + @quantity
        WHERE product_id = @product_id AND date = @order_date
        FETCH inserted_cur
        INTO @order_id, @product_id, @quantity
      END
    CLOSE inserted_cur
    DEALLOCATE inserted_cur
  END
GO

CREATE TRIGGER addToWarehouseUpdate
  ON Warehouse_orders
AFTER UPDATE AS
  BEGIN
    DECLARE @order_id INT
    DECLARE @product_id INT
    DECLARE @location_id INT
    DECLARE @quantity SMALLINT
    SET @order_id = (SELECT id
                     FROM inserted)
    IF (SELECT delivery_date
        FROM inserted) IS NOT NULL AND (SELECT delivery_date
                                        FROM deleted) IS NULL
      BEGIN
        DECLARE delivered_prods CURSOR FOR (SELECT
                                              product_id,
                                              quantity,
                                              location_id
                                            FROM Warehouse_order_details AS OD
                                              JOIN inserted ON @order_id = OD.warehouse_order_id)
          FOR READ ONLY
        OPEN delivered_prods
        FETCH delivered_prods
        INTO @product_id, @quantity, @location_id
        WHILE @@fetch_status = 0
          BEGIN
            EXEC changeStock @product_id, @quantity, @location_id
            FETCH delivered_prods
            INTO @product_id, @quantity, @location_id
          END
        CLOSE delivered_prods
        DEALLOCATE delivered_prods
      END
  END
GO

CREATE TRIGGER getFromWarehouseUpdate
  ON Client_orders
AFTER UPDATE AS
  BEGIN
    DECLARE @order_id INT
    DECLARE @spot_id INT
    DECLARE @product_id INT
    DECLARE @location_id INT
    DECLARE @quantity SMALLINT
    SET @order_id = (SELECT id
                     FROM inserted)
    SET @spot_id = (SELECT spot_id
                    FROM inserted)
    IF (SELECT payment_time
        FROM inserted) IS NOT NULL AND (SELECT payment_time
                                        FROM deleted) IS NULL
      BEGIN
        DECLARE sold_prods CURSOR FOR (SELECT
                                         products_sold_id,
                                         quantity,
                                         location_id
                                       FROM Client_order_details AS OD
                                         JOIN inserted ON @order_id = OD.client_order_id
                                         JOIN Spots AS S ON S.id = @spot_id)
          FOR READ ONLY
        OPEN sold_prods
        FETCH sold_prods
        INTO @product_id, @quantity, @location_id
        WHILE @@fetch_status = 0
          BEGIN
            SET @quantity = -@quantity
            DECLARE @recipe_id INT
            SET @recipe_id = (SELECT recipe_id
                              FROM ProductsSold
                              WHERE id = @product_id)
            IF @recipe_id IS NULL
              BEGIN
                EXEC changeStock @product_id, @quantity, @location_id
              END
            ELSE
              BEGIN
                DECLARE @ingredient_id INT
                DECLARE @ingredient_quantity INT
                DECLARE @final_change INT
                DECLARE ingredients CURSOR FOR (SELECT
                                                  ingredient_id,
                                                  quantity
                                                FROM Ingredients
                                                WHERE recipe_id = @recipe_id)
                  FOR READ ONLY
                OPEN ingredients
                FETCH ingredients
                INTO @ingredient_id, @ingredient_quantity
                WHILE @@fetch_status = 0
                  BEGIN
                    SET @final_change = (@quantity) * (@ingredient_quantity)
                    EXEC changeStock @ingredient_id, @final_change, @location_id
                    FETCH ingredients
                    INTO @ingredient_id, @ingredient_quantity
                  END
                CLOSE ingredients
                DEALLOCATE ingredients
              END
            FETCH sold_prods
            INTO @product_id, @quantity, @location_id
          END
        CLOSE sold_prods
        DEALLOCATE sold_prods
      END
  END
GO

--trigger do usuwania wierszy, ktore po update maja quantity 0
CREATE TRIGGER checkQuantityAfterWarehouseUpdate
  ON Warehouse
AFTER UPDATE
AS
  BEGIN
    DELETE FROM Warehouse
    WHERE quantity = 0
  END
GO

--trigger do usuwania ordera jak nie ma order detailsow
CREATE TRIGGER checkNumberOfWarehouseOrderDetails
  ON Warehouse_order_details
AFTER DELETE
AS
  BEGIN
    DECLARE @warehouse_order_id INT
    SET @warehouse_order_id = (SELECT warehouse_order_id
                               FROM deleted)

    IF NOT exists(SELECT *
                  FROM Warehouse_order_details
                  WHERE warehouse_order_id = @warehouse_order_id)
      DELETE FROM Warehouse_orders
      WHERE id = @warehouse_order_id
  END

GO

--trigger do usuwania ordera jak nie ma order detailsow
CREATE TRIGGER checkNumberOfClientOrderDetails
  ON Client_order_details
AFTER DELETE
AS
  BEGIN
    DECLARE @client_order_id INT
    SET @client_order_id = (SELECT client_order_id
                            FROM deleted)

    IF NOT exists(SELECT *
                  FROM Client_order_details
                  WHERE client_order_id = @client_order_id)
      DELETE FROM Client_orders
      WHERE id = @client_order_id
  END