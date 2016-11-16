USE MCGYVER

INSERT INTO UnitTypes (type_name) VALUES
  ('vol'),
  ('mass')

INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
  ('kilogram', 1, 2),
  ('dekagram', 100, 2),
  ('litr', 1, 1),
  ('mililitr', 1000, 1)

