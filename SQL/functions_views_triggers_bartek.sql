USE BarProject

CREATE FUNCTION productsByCategory(@category_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             name,
                             tax_id,
                             unit_id
                           FROM Products
                           WHERE category_id = @category_id)


CREATE FUNCTION receiptDetails(@receipt_id INT)
  RETURNS TABLE AS RETURN (SELECT
                             receipt_id,
                             ingredient_id,
                             quantity
                           FROM Ingredients AS I
                             JOIN Receipts AS R ON I.receipt_id = R.id
                           WHERE receipt_id = @receipt_id)

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
                             JOIN Prices AS P
                               ON PRS.id = P.product_id
                             JOIN Products AS PR ON PRS.id = PR.id
                             JOIN Categories AS C ON PR.category_id = C.id
                             JOIN Taxes AS T ON PR.tax_id = T.id
                             JOIN Units AS U ON PR.unit_id = U.id
                           WHERE PRS.id = @product_id)


SELECT *
FROM soldProductDetails(1)

SELECT *
FROM productsByCategory(2)