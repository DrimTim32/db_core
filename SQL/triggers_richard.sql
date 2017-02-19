USE BarProject

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