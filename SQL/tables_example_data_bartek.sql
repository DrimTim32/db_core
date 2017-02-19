INSERT INTO Categories (slug, category_name, overriding_category) VALUES
  ('NAPOJE', 'NAPOJE', NULL),
  ('PIWO', 'PIWO', NULL),
  ('KAWA', 'KAWA', NULL),
  ('HERBATA', 'HERBATA', NULL)


INSERT INTO Categories (slug, category_name, overriding_category) VALUES
  ('NAP_SOK', 'SOKI', 1),
  ('PIWO_KEG', 'PIWO BECZKA', 2),
  ('PIWO_BUT', 'PIWO BUTELKA', 2),
  ('HER_ZIEL', 'HEBRATY ZIELONE', 4),
  ('HER_INNE', 'HEBRATY INNE', 4),
  ('HER_CZAR', 'HEBRATY CZARNE', 4)

-- soki-sprzedawane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (5, 5, 2, 'SOK JABLKOWY'),
  (5, 5, 2, 'SOK POMARANCZOWY')

INSERT INTO ProductsSold (id) VALUES
  (1),
  (2)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (1, '2016-12-9', 5.50),
  (2, '2016-12-10', 5.50)

--soki-magazynowane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (5, 5, 2, 'SOK MALINOWY')

INSERT INTO ProductsStored (id) VALUES
  (3)

--piwo-magazynowane-i-sprzedawane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (2, 5, 1, 'TYSKIE'),
  (2, 5, 1, 'IMPERIUM PRUNUM')

INSERT INTO ProductsSold (id) VALUES
  (4),
  (5)

INSERT INTO ProductsStored (id) VALUES
  (4)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (4, '2016-12-9', 7),
  (5, '2016-12-10', 50)

--piwo z sokiem

INSERT INTO Recipes (description) VALUES
  ('receptura na piwo z sokiem')

INSERT INTO Ingredients (recipe_id, ingredient_id, quantity) VALUES
  (1, 3, 1),
  (1, 4, 1)

INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (2, 5, 1, 'TYSKIE Z SOKIEM')

INSERT INTO ProductsSold (id, recipe_id) VALUES
  (6, 1)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (6, '2016-12-9', 9)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (6, '2017-01-31', 12)