USE BarProject

CREATE TABLE Employees (
  id       INT PRIMARY KEY IDENTITY (1, 1),
  name     NVARCHAR(64) NOT NULL,
  surname  NVARCHAR(64) NOT NULL,
  phone    NVARCHAR(30) NOT NULL,
  position TINYINT      NOT NULL,
);
CREATE TABLE Users (
  user_id       INT FOREIGN KEY REFERENCES Employees (id),
  username      NVARCHAR(64)  NOT NULL,
  password      VARBINARY(20) NOT NULL,
  password_salt CHAR(25)      NOT NULL
);