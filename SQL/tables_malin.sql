USE BarProject

CREATE TABLE EmployePermissions(
  id TINYINT PRIMARY KEY IDENTITY (1, 1),
  value TINYINT UNIQUE,
  name NVARCHAR(64) NOT NULL,
);

CREATE TABLE Users (
  id       INT PRIMARY KEY IDENTITY (1, 1),
  username      NVARCHAR(64)  NOT NULL,
  password      VARBINARY(20) NOT NULL,
  password_salt CHAR(25)      NOT NULL,
  name     NVARCHAR(64) NOT NULL,
  surname  NVARCHAR(64) NOT NULL,
  permission TINYINT FOREIGN KEY REFERENCES EmployePermissions (id)
);

CREATE Table InternalErrors(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	error_name NVARCHAR(64) NOT NULL,
	error_time datetime NOT NULL,
	message NVARCHAR(3000),
	stack_trace NVARCHAR(1000) NOT NULL,
	context NVARCHAR(900) NOT NULL,
	inner_message NVARCHAR(400), 
)
