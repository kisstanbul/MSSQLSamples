----------------------------------------------------------------------------------
-- Views
---------------------------------------------------------------------------------
-- Create a view
CREATE VIEW Sales.vCustomerAddress
AS
     SELECT C.CustomerID,
            FirstName,
            LastName,
            AddressLine1,
            City
     FROM Sales.Customer C
          JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
          JOIN Person.BusinessEntityAddress AS e ON e.BusinessEntityID = p.BusinessEntityID
          JOIN Person.Address a ON a.AddressID = e.AddressID;

-- Query the view
SELECT CustomerID,
       City
FROM Sales.vCustomerAddress;

-- Join the view to a table
SELECT c.City,
       ISNULL(SUM(s.TotalDue), 0.00) AS Revenue
FROM Sales.vCustomerAddress AS c
     LEFT JOIN Sales.SalesOrderHeader AS s ON s.CustomerID = c.CustomerID
GROUP BY c.City
ORDER BY Revenue DESC;
----------------------------------------------------------------------------------
-- CTE Commont Table Expressions
----------------------------------------------------------------------------------
--Using a CTE
WITH ProductsByCategory(ProductID,
                        ProductName,
                        Category)
     AS (SELECT p.ProductID,
                p.Name,
                c.Name AS Category
         FROM Production.Product p
              JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
              JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID)
     SELECT Category,
            COUNT(ProductID) AS Products
     FROM ProductsByCategory
     GROUP BY Category
     ORDER BY Category;


-- Recursive CTE
SELECT *
FROM Sales.Employee;

-- Using the CTE to perform recursion
WITH OrgReport(ManagerID,
               EmployeeID,
               EmployeeName,
               Level)
     AS (
     -- Anchor query
     SELECT e.ManagerID,
            e.EmployeeID,
            EmployeeName,
            0
     FROM Sales.Employee AS e
     WHERE ManagerID IS NULL
     UNION ALL
     -- Recursive query
     SELECT e.ManagerID,
            e.EmployeeID,
            e.EmployeeName,
            Level + 1
     FROM Sales.Employee AS e
          INNER JOIN OrgReport AS o ON e.ManagerID = o.EmployeeID)
     SELECT *
     FROM OrgReport
     OPTION(MAXRECURSION 3);


----------------------------------------------------------------------------------
-- Derived Tables
----------------------------------------------------------------------------------
SELECT Category,
       COUNT(ProductID) AS Products
FROM
(
    SELECT p.ProductID,
           p.Name,
           c.Name AS Category
    FROM Production.Product p
         JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
         JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID
) ProductsByCategory
GROUP BY Category
ORDER BY Category;
