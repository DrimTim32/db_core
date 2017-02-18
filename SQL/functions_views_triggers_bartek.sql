USE BarProject
GO

CREATE FUNCTION productsByCategory(@category_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             name,
                             tax_id,
                             unit_id
                           FROM Products
                           WHERE category_id = @category_id)
GO


CREATE FUNCTION receiptDetails(@receipt_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             receipt_id,
                             ingredient_id,
                             quantity
                           FROM Ingredients AS I
                             JOIN Receipts AS R ON I.receipt_id = R.id
                           WHERE receipt_id = @receipt_id)
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
                             receipt_id,
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

CREATE VIEW productSimple AS
  SELECT
    P.id,
    name,
    category_name,
    (SELECT CAST(COUNT(*) AS BIT)
     FROM ProductsSold
     WHERE (id = P.id)) AS sold,
    (SELECT CAST(COUNT(*) AS BIT)
     FROM ProductsStored
     WHERE (id = P.id)) AS stored
  FROM Products P
    JOIN Categories C ON P.category_id = C.id


CREATE VIEW productsLastPrices AS
  SELECT
    product_id,
    price,
    period_start
  FROM ProductsSold AS P
    JOIN Prices ON P.id = Prices.product_id
  WHERE period_start = (SELECT MAX(period_start)
                        FROM Prices AS P2
                        WHERE
                          P2.product_id = Prices.product_id)

CREATE VIEW productsLastPricesWithName AS
  SELECT
    product_id,
    name,
    price,
    period_start
  FROM ProductsSold AS P
    JOIN Prices ON P.id = Prices.product_id
    JOIN Products ON P.id = Products.id
  WHERE period_start = (SELECT MAX(period_start)
                        FROM Prices AS P2
                        WHERE
                          P2.product_id = Prices.product_id)

SELECT *
FROM productsLastPrices