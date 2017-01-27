USE BarProject

CREATE TABLE Users (
  id       INT PRIMARY KEY IDENTITY (1, 1),
  username      NVARCHAR(64)  NOT NULL,
  password      VARBINARY(20) NOT NULL,
  password_salt CHAR(25)      NOT NULL,
  name     NVARCHAR(64) NOT NULL,
  surname  NVARCHAR(64) NOT NULL,
  permission TINYINT FOREIGN KEY REFERENCES EmployePermissions (value)
);

CREATE TABLE EmployePermissions(
  id TINYINT PRIMARY KEY IDENTITY (1, 1),
  value TINYINT UNIQUE,
  name NVARCHAR(64) NOT NULL,
);
