----------------------------------------------------------------------------------
-- Union
----------------------------------------------------------------------------------
/*
-- Setup
CREATE VIEW SalesLT.Customers
AS
     SELECT DISTINCT
            firstname,
            lastname
     FROM saleslt.customer
     WHERE lastname >= 'm'
           OR customerid = 3;
GO
CREATE VIEW SalesLT.Employees
AS
     SELECT DISTINCT
            firstname,
            lastname
     FROM saleslt.customer
     WHERE lastname <= 'm'
           OR customerid = 3;
GO
*/
-- Union example
SELECT FirstName,
       LastName
FROM SalesLT.Employees
UNION 
SELECT FirstName,
       LastName
FROM SalesLT.Customers
ORDER BY LastName;
----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
SELECT FirstName, LastName
FROM SalesLT.Customers
INTERSECT
SELECT FirstName, LastName
FROM SalesLT.Employees;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
SELECT FirstName, LastName
FROM SalesLT.Customers
EXCEPT
SELECT FirstName, LastName
FROM SalesLT.Employees;

