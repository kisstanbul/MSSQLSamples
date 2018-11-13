----------------------------------------------------------------------------------
-- Union
----------------------------------------------------------------------------------
-- Setup
CREATE VIEW Sales.Customers
AS
     SELECT DISTINCT
            firstname,
            lastname
     FROM Person.Person
     WHERE lastname like '[MK]%';
GO
CREATE VIEW Sales.Employees
AS
     SELECT DISTINCT
            firstname,
            lastname
     FROM Person.Person
     WHERE lastname like '[KS]%';
GO

-- Union example
SELECT FirstName,
       LastName
FROM Sales.Employees
UNION
SELECT FirstName,
       LastName
FROM Sales.Customers
ORDER BY LastName;
----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
SELECT FirstName,
       LastName
FROM Sales.Customers
INTERSECT
SELECT FirstName,
       LastName
FROM Sales.Employees;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
SELECT FirstName,
       LastName
FROM Sales.Customers
EXCEPT
SELECT FirstName,
       LastName
FROM Sales.Employees;
