----------------------------------------------------------------------------------
-- Views
---------------------------------------------------------------------------------
-- Create a view
CREATE VIEW SalesLT.vCustomerAddress
AS
SELECT C.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince 
FROM
SalesLT.Customer C JOIN SalesLT.CustomerAddress CA
ON C.CustomerID=CA.CustomerID
JOIN SalesLT.Address A
ON CA.AddressID=A.AddressID

-- Query the view
SELECT CustomerID, City
FROM SalesLT.vCustomerAddress

-- Join the view to a table
SELECT c.StateProvince, c.City, ISNULL(SUM(s.TotalDue), 0.00) AS Revenue
FROM SalesLT.vCustomerAddress AS c
LEFT JOIN SalesLT.SalesOrderHeader AS s
ON s.CustomerID = c.CustomerID
GROUP BY c.StateProvince, c.City
ORDER BY c.StateProvince, Revenue DESC;
----------------------------------------------------------------------------------
-- CTE Commont Table Expressions
----------------------------------------------------------------------------------
--Using a CTE
WITH ProductsByCategory (ProductID, ProductName, Category)
AS
(
	SELECT p.ProductID, p.Name, c.Name AS Category
	 FROM SalesLT.Product AS p
	 JOIN SalesLT.ProductCategory AS c
	 ON p.ProductCategoryID = c.ProductCategoryID
)

SELECT Category, COUNT(ProductID) AS Products
FROM ProductsByCategory
GROUP BY Category
ORDER BY Category;


-- Recursive CTE
SELECT * FROM SalesLT.Employee

-- Using the CTE to perform recursion
WITH OrgReport (ManagerID, EmployeeID, EmployeeName, Level)
AS
(
	-- Anchor query
	SELECT e.ManagerID, e.EmployeeID, EmployeeName, 0
	FROM SalesLT.Employee AS e
	WHERE ManagerID IS NULL

	UNION ALL

	-- Recursive query
	SELECT e.ManagerID, e.EmployeeID, e.EmployeeName, Level + 1
	FROM SalesLT.Employee AS e
	INNER JOIN OrgReport AS o ON e.ManagerID = o.EmployeeID
)

SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);


----------------------------------------------------------------------------------
-- Derived Tables
----------------------------------------------------------------------------------

SELECT Category, COUNT(ProductID) AS Products
FROM
	(SELECT p.ProductID, p.Name AS Product, c.Name AS Category
	 FROM SalesLT.Product AS p
	 JOIN SalesLT.ProductCategory AS c
	 ON p.ProductCategoryID = c.ProductCategoryID) AS ProdCats
GROUP BY Category
ORDER BY Category;
