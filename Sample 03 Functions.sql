----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT * FROM Production.Product
----------------------------------------------------------------------------------------------------------------------------------------
-- A. LIKE
----------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds all product numbers that have begin with CA in the Product table.
----------------------------------------------------------------------------------------------------------------------------------------
SELECT p.Name, p.ProductNumber  
FROM Production.Product AS p
WHERE p.ProductNumber LIKE 'CA%'  
ORDER by p.Name; 
----------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds all product numbers that have second letter is A in the Product table.
----------------------------------------------------------------------------------------------------------------------------------------
SELECT p.Name, p.ProductNumber  
FROM Production.Product AS p
WHERE p.ProductNumber LIKE '_A%'  
ORDER by p.Name; 
----------------------------------------------------------------------------------------------------------------------------------------
-- B. NOT LIKE
----------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds all product numbers that have first letter is not F in the Product table.
SELECT p.Name, p.ProductNumber  
FROM Production.Product AS p
WHERE p.ProductNumber NOT LIKE 'F%'  
ORDER by p.Name; 

----------------------------------------------------------------------------------------------------------------------------------------
-- C. Escape character
----------------------------------------------------------------------------------------------------------------------------------------
-- The following example uses the ESCAPE clause and the escape character to find the exact character string 10-15% in column c1 of the mytbl2 table.
GO  
CREATE TABLE mytbl2  ( c1 sysname  );  
GO  
INSERT mytbl2 VALUES ('Discount is 10-15% off'), ('Discount is .10-.15 off'),('Discount is 10-15. off'); 
GO  
select * from mytbl2 

SELECT c1   
FROM mytbl2  
WHERE c1 LIKE '%10-15@% off%' ESCAPE '@';  
GO
DROP TABLE mytbl2 ;
----------------------------------------------------------------------------------------------------------------------------------------
-- D. Using the [ ] wildcard characters
----------------------------------------------------------------------------------------------------------------------------------------
-- The following example finds all product numbers that have first letter is C or H in the Product table.
SELECT p.Name, p.ProductNumber  
FROM Production.Product AS p
WHERE p.ProductNumber LIKE '[CH]%'  
ORDER by p.Name; 
----------------------------------------------------------------------------------------------------------------------------------------
--
--
-- Scalar functions
SELECT YEAR(SellStartDate) SellStartYear, SellStartDate, ProductID, Name
FROM Production.Product
ORDER BY SellStartYear;
/*
SELECT * FROM Production.Product where ProductNumber  IN ('LJ-0192-M','LJ-0192-L')
begin tran
update Production.Product  set SellStartDate = dateadd(d,5,sellstartdate) where ProductNumber  IN ('LJ-0192-M','LJ-0192-L')
commit
rollback
*/
SELECT YEAR(SellStartDate) SellStartYear, count(*) ProductCount
FROM Production.Product
GROUP BY YEAR(SellStartDate)
ORDER BY SellStartYear;


SELECT YEAR(SellStartDate) SellStartYear,
       DATENAME(mm, SellStartDate) SellStartMonth,
       DATEPART(dw, p.SellStartDate) WeekDay,
       DAY(SellStartDate) SellStartDay,
       DATENAME(dw, SellStartDate) SellStartWeekday,
       ProductID,
       Name
FROM Production.Product p
ORDER BY SellStartYear;


SELECT DATEDIFF(yy,SellStartDate, GETDATE()) YearsSold, ProductID, Name
FROM Production.Product
ORDER BY ProductID;

SELECT UPPER(Name) AS ProductName
FROM Production.Product;

SELECT CONCAT(FirstName + ' ', LastName) AS FullName
FROM Person.Person;

SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType, 'X'+REPLACE(RTRIM(LTRIM('   AAAAAA    ')),'A','B')+'X'
FROM Production.Product;

Select '1234567' , REVERSE('1234567')

SELECT Name, ProductNumber, 
LEFT(ProductNumber, 2) AS ProductType,
SUBSTRING(ProductNumber,CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode,
SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode
FROM Production.Product;


-- Logical functions
SELECT Name, Size AS NumericSize
FROM Production.Product
WHERE ISNUMERIC(Size) = 1;

SELECT Name, IIF(Size IN ('XXL','XL','L'), 'BIG', 'Other') ProductType
FROM Production.Product;

SELECT Name, IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Non-Numeric') SizeType
FROM Production.Product;

SELECT prd.Name AS ProductName, prd.Size
    --, CHOOSE (prd.Size, 'M','Medium','S','Small') AS ProductType
FROM Production.Product AS prd
;

-- SELECT * FROM Production.Product
-- Window functions
SELECT TOP(100) ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM Production.Product AS p
ORDER BY RankByPrice;

SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK() OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) AS RankByPrice
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID
ORDER BY Category, RankByPrice;


-- Aggregate Functions
SELECT COUNT(*) AS Products
, COUNT(DISTINCT c.ProductCategoryID) AS Categories
, AVG(ListPrice) AS AveragePrice
FROM Production.Product p
JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID;

SELECT COUNT(p.ProductID) BikeModels, AVG(p.ListPrice) AveragePrice
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID
WHERE c.Name LIKE '%Bikes';
