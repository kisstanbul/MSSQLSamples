----------------------------------------------------------------------------------------------------------------------------------------------------------
-- A. Using SELECT to retrieve rows and columns
----------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- This section shows three code examples. This first code example returns all rows (no WHERE clause is specified) and all columns (using the *) from the DimEmployee table.
--
SELECT *  
FROM Person.Person  
ORDER BY LastName;  
--
-- This next example using table aliasing to achieve the same result.
--
SELECT p.*  
FROM Person.Person AS p  
ORDER BY LastName;  
--
-- This example returns all rows (no WHERE clause is specified) and a subset of the columns
-- 
SELECT FirstName, LastName, MiddleName, AdditionalContactInfo AS Info 
FROM Person.Person   
ORDER BY LastName;  
--
-- This example returns only the rows for Customer that have an MiddleName that is not NULL and a Title of 'Mr.'.
--
SELECT FirstName, LastName,MiddleName, AdditionalContactInfo AS Info 
FROM Person.Person   
WHERE MiddleName IS NOT NULL AND Title = 'Mr.'
ORDER BY LastName;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- B. Using SELECT with column headings and calculations
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example returns all rows from the Product table, and calculates the new price for each product.

Select * from Production.Product

SELECT Name, Color, ListPrice, ListPrice * 40 AS NewPrice
FROM Production.Product  
ORDER BY Name;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- C. Using DISTINCT with SELECT
----------------------------------------------------------------------------------------------------------------------------------------------------------
--The following example uses DISTINCT to generate a list of all unique color in the Product table.
SELECT DISTINCT Color  
FROM Production.Product  
ORDER BY Color;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- D. Using GROUP BY
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds the total amount for all sales for each account.
SELECT AccountNumber, SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
GROUP BY AccountNumber;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- E. Using GROUP BY with multiple groups
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds the sales count and the sum of sales for each account shipment address.
-- ASC Default
SELECT AccountNumber, ShipToAddressID,Count(*) SalesCount,  SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
GROUP BY AccountNumber, ShipToAddressID 
ORDER BY AccountNumber ;    
-- DESC
SELECT AccountNumber, ShipToAddressID,Count(*) SalesCount,  SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
GROUP BY AccountNumber, ShipToAddressID 
ORDER BY AccountNumber DESC;    
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- F. Using GROUP BY and WHERE
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example puts the results into groups after retrieving only the rows with order dates later than December 31, 2001.
SELECT OrderDate,AccountNumber, SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
WHERE OrderDate > '20061231'
GROUP BY AccountNumber ,OrderDate
ORDER BY AccountNumber;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- G. Using GROUP BY with an expression
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example groups by an expression. You can group by an expression if the expression does not include aggregate functions.
SELECT SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader 
GROUP BY YEAR(OrderDate);  
--
GO
--
SELECT AVG(OrderQty) AS [Average Quantity], 
NonDiscountSales = (OrderQty * UnitPrice)
FROM Sales.SalesOrderDetail
GROUP BY (OrderQty * UnitPrice)
ORDER BY (OrderQty * UnitPrice) DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- H. Using GROUP BY with ORDER BY
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds the sum of sales per acount, and orders by the acount.
SELECT AccountNumber, SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
GROUP BY AccountNumber 
ORDER BY AccountNumber;    
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- I. Using the HAVING clause
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- This query uses the HAVING clause to restrict results.
SELECT AccountNumber, SUM(SubTotal) AS TotalSales  
FROM Sales.SalesOrderHeader  
GROUP BY AccountNumber 
HAVING SUM(SubTotal)>1000
ORDER BY AccountNumber;
--
GO
--
SELECT ProductID FROM Sales.SalesOrderDetail GROUP BY ProductID HAVING AVG(OrderQty) > 5 ORDER BY ProductID;
--
SELECT ProductID 
FROM Sales.SalesOrderDetail
WHERE UnitPrice < 25.00
GROUP BY ProductID
HAVING AVG(OrderQty) > 5
ORDER BY ProductID;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- J
----------------------------------------------------------------------------------------------------------------------------------------------------------
--Aliases are used also to specify names for the results of expressions, for example:
SELECT AccountNumber, SubTotal AS [Sales Total], SubTotal AS [totaL saLes]  
FROM Sales.SalesOrderHeader;
-- "column_alias" can be used in an ORDER BY clause. However, it cannot be used in a WHERE, GROUP BY, or HAVING clause
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- K
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- This is the query that calculates the revenue for each product in each sales order.
SELECT 'Total income is',
       (OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount),
       ' for ',
       p.Name AS ProductName,
       NonDiscountSales = OrderQty * UnitPrice,
       Discounts = (OrderQty * UnitPrice) * UnitPriceDiscount
FROM Production.Product AS p
     INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
ORDER BY ProductName ASC;
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CAST and CONVERT 
----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT ProductID + ': ' + Name
FROM Production.Product; 
-- Implicit
Select '1' + 9.5
--Explicit
-- Cast
SELECT 9.5 AS Original, CAST(9.5 AS int) AS int, CAST(9.5 AS decimal(6,4)) AS decimal;
-- Convert
SELECT 9.5 AS Original, CONVERT(int, 9.5) AS int,  CONVERT(decimal(6,4), 9.5) AS decimal;
-- STR
SELECT STR(123.45, 6, 1) ;  
SELECT CONVERT(varchar,CONVERT(decimal(6,1), 123.45)) ;
-- PARSE
SELECT PARSE('€345,98' AS money USING 'de-DE') AS Result;
--
SELECT SellStartDate,
       CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
	   CONVERT(nvarchar(30), SellStartDate, 104) AS FormatedDate
FROM Production.Product;
-- TRY_
SELECT Name, CAST (Size AS Integer) AS NumericSize
FROM Production.Product; --(note error - some sizes are incompatible)

SELECT Name, TRY_CAST (Size AS Integer) AS NumericSize
FROM Production.Product; --(note incompatible sizes are returned as NULL)
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- NULL
----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT Name, Weight, Color  
FROM Production.Product  
WHERE Weight > 10.00 OR Color = NULL  
ORDER BY Name;  
-- IS NULL
SELECT Name, Weight, Color  
FROM Production.Product  
WHERE Weight > 10.00 OR Color IS NULL  
ORDER BY Name;  

--ISNULL
SELECT Name, Weight, ISNULL(Color,ProductID) AS Color 
FROM Production.Product  
WHERE Weight < 10.00 OR Color IS NULL  
ORDER BY Name;  
--COALESCE 
SELECT Name, COALESCE(Weight,1) Weight, ISNULL(Color,'N/A') AS Color  
FROM Production.Product  
WHERE Weight < 10.00 OR Color IS NULL  
ORDER BY Name;  
--NULLIF
SELECT ProductID, Color, NULLIF(Color,'Multi')AS 'Null if Equal'  
FROM Production.Product;  
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT Name, ISNULL(Size ,0) AS NumericSize
FROM Production.Product
where Size is not null
;
--
SELECT ProductNumber, ISNULL(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM Production.Product;
--
SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM Production.Product;
--
SELECT Name, COALESCE(DiscontinuedDate, SellEndDate, SellStartDate,getdate()) AS FirstNonNullDate,discontinuedDate, SellEndDate, SellStartDate
FROM Production.Product;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- CASE
----------------------------------------------------------------------------------------------------------------------------------------------------------
--Searched case
SELECT Name,
		CASE
			WHEN Name LIKE 'AWC%' THEN 'N/A'
			WHEN SellEndDate IS NULL THEN 'On Sale'
			ELSE 'Discontinued'
		END AS SalesStatus
FROM Production.Product;
--
--Simple case
SELECT Name,Size,
		CASE UPPER(SUBSTRING(Size,1,1) )
			WHEN 'S' THEN 'Small'
			WHEN 'M' THEN 'Medium'
			WHEN 'L' THEN 'Large'
			WHEN 'XL' THEN 'Extra-Large'
			WHEN 'XXL' THEN 'UltraExtra-Large'
			ELSE ISNULL(Size, 'N/A')
		END AS ProductSize
FROM Production.Product;