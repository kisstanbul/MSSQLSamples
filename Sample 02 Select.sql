----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- A - Eliminating Duplicates and Sorting Results
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

--Display a list of product colors
SELECT Color FROM Production.Product;

--Display a list of product colors with the word 'None' if the value is null
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM Production.Product;

--Display a list of product colors with the word 'None' if the value is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM Production.Product ORDER BY Color;

--Display a list of product colors with the word 'None' if the value is null and a dash if the size is null sorted by color
SELECT DISTINCT ISNULL(Color, 'None') AS Color, ISNULL(Size, '-') AS Size FROM Production.Product ORDER BY Color;
----------------------------------------------------------------------------------------------------------------------------------------------------------

--Display the top 100 products by list price
SELECT TOP 100 Name, ListPrice FROM Production.Product ORDER BY ListPrice DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
--Display the first ten products by product number
SELECT Name, ListPrice FROM Production.Product ORDER BY ProductNumber OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; 

--Display the next ten products by product number
SELECT Name, ListPrice FROM Production.Product ORDER BY ProductNumber OFFSET 10 ROWS FETCH FIRST 15 ROW ONLY;
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Filtering with Predicates.sql
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
--List information about product model 6
SELECT Name, Color, Size FROM Production.Product WHERE ProductModelID = 6;

--List information about products that have a product number beginning FR
SELECT productnumber,Name, ListPrice FROM Production.Product WHERE ProductNumber LIKE 'FR%';

--Filter the previous query to ensure that the product number contains two sets of two didgets
SELECT Name, ListPrice, ProductNumber 
FROM Production.Product 
WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

--Find products that have no sell end date
SELECT Name FROM Production.Product WHERE SellEndDate IS NOT NULL;

--Find products that have a sell end date in 2006
SELECT Name FROM Production.Product WHERE SellEndDate BETWEEN '2001/1/1' AND '2006/12/31';

--Find products that have a color of black ,red or blue.
SELECT Color, Name, ListPrice 
FROM Production.Product 
WHERE Color IN ('Black', 'Red', 'Blue');


--Find products that have a color of black ,red or blue and have a sell end date
SELECT Color, Name, ListPrice, SellEndDate 
FROM Production.Product 
WHERE Color IN ('Black', 'Red', 'Blue') 
  AND SellEndDate IS NULL;

--Select products that have a color of black ,red or blue and a product number that begins FR
SELECT Name, Color, ProductNumber 
FROM Production.Product 
WHERE ProductNumber LIKE 'FR%' OR Color IN ('Black', 'Red', 'Blue');
