----------------------------------------------------------------------------------
-- INNER
----------------------------------------------------------------------------------
--Basic inner join
SELECT Production.Product.Name As ProductName, c.Name AS Category
FROM Production.Product 
JOIN Production.ProductSubcategory AS sc ON Production.Product.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID;

-- Table aliases
SELECT p.Name As ProductName, c.Name AS Category
FROM Production.Product AS p
JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID;

-- Joining more than 2 tables
SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name As ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
FROM Sales.SalesOrderHeader AS oh
JOIN Sales.SalesOrderDetail AS od ON od.SalesOrderID = oh.SalesOrderID
JOIN Production.Product AS p ON od.ProductID = p.ProductID
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

-- Multiple join predicates
SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name As ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
FROM Sales.SalesOrderHeader AS oh
JOIN Sales.SalesOrderDetail AS od ON od.SalesOrderID = oh.SalesOrderID
JOIN Production.Product AS p ON od.ProductID = p.ProductID AND od.UnitPrice = p.ListPrice --Note multiple predicates
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID; 
----------------------------------------------------------------------------------
-- OUTER
----------------------------------------------------------------------------------
--Get all customers, with sales orders for those who've bought anything
SELECT p.FirstName, p.LastName,Count(Distinct oh.SalesOrderNumber) OrderCount
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID=p.BusinessEntityID
LEFT OUTER JOIN Sales.SalesOrderHeader AS oh ON c.CustomerID = oh.CustomerID
GROUP BY p.FirstName, p.LastName
ORDER BY OrderCount DESC;

--Return only customers who haven't purchased anything
SELECT p.FirstName, p.LastName, oh.SalesOrderNumber,p.PersonType
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID=p.BusinessEntityID
LEFT OUTER JOIN Sales.SalesOrderHeader AS oh ON c.CustomerID = oh.CustomerID
WHERE oh.SalesOrderNumber IS NULL 
ORDER BY c.CustomerID;


--More than 2 tables
SELECT p.Name As ProductName, oh.SalesOrderNumber
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS od ON p.ProductID = od.ProductID
LEFT JOIN Sales.SalesOrderHeader AS oh --Additional tables added to the right must also use a left join
ON od.SalesOrderID = oh.SalesOrderID
ORDER BY p.ProductID;


SELECT p.Name As ProductName, c.Name AS Category, oh.SalesOrderNumber
FROM Production.Product AS p
LEFT OUTER JOIN Sales.SalesOrderDetail AS od
ON p.ProductID = od.ProductID
LEFT OUTER JOIN Sales.SalesOrderHeader AS oh
ON od.SalesOrderID = oh.SalesOrderID
 --Added to the left, so can use inner join
JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID=sc.ProductSubcategoryID
JOIN Production.ProductCategory AS c ON sc.ProductCategoryID = c.ProductcategoryID
ORDER BY p.ProductID;



----------------------------------------------------------------------------------
-- Cross
----------------------------------------------------------------------------------

--Call each customer once per product
SELECT p.Name, c.FirstName, c.LastName, c.PersonType
FROM Production.Product AS p
CROSS JOIN  Person.Person AS c
WHERE c.PersonType='SC';

----------------------------------------------------------------------------------
-- Self
----------------------------------------------------------------------------------
--note there's no self join employee table, so we'll create one for this example
CREATE TABLE Sales.Employee
(EmployeeID   INT PRIMARY KEY,
 EmployeeName NVARCHAR(256),
 ManagerID    INT
);
GO
CREATE PROCEDURE dbo.tmpGetEmployeeManagers
AS
     BEGIN
         WITH [EMP_cte](BusinessEntityID,
                        OrganizationNode,
                        FirstName,
                        LastName,
                        JobTitle,
                        RecursionLevel) -- CTE name and columns
              AS (
              SELECT e.BusinessEntityID,
                     e.OrganizationNode,
                     p.FirstName,
                     p.LastName,
                     e.JobTitle,
                     0 -- Get the initial Employee
              FROM HumanResources.Employee e
                   INNER JOIN Person.Person AS p ON p.BusinessEntityID = e.BusinessEntityID
              --WHERE e.[BusinessEntityID] = @BusinessEntityID
              UNION ALL
              SELECT e.BusinessEntityID,
                     e.OrganizationNode,
                     p.FirstName,
                     p.LastName,
                     e.JobTitle,
                     RecursionLevel + 1 -- Join recursive member to anchor
              FROM HumanResources.Employee e
                   INNER JOIN EMP_cte ON e.OrganizationNode = EMP_cte.OrganizationNode.GetAncestor(1)
                   INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID)
              -- Join back to Employee to return the manager name
              SELECT DISTINCT
                     EMP_cte.BusinessEntityID EmployeeID,
                     EMP_cte.FirstName+' '+EMP_cte.LastName EmployeeName,
                     p.BusinessEntityID ManagerID
              FROM EMP_cte
                   INNER JOIN HumanResources.Employee e ON EMP_cte.OrganizationNode.GetAncestor(1) = e.OrganizationNode
                   INNER JOIN Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
              WHERE p.PersonType = 'EM'
              OPTION(MAXRECURSION 25);
     END;
GO
INSERT INTO Sales.Employee
(EmployeeID,
 EmployeeName,
 ManagerID
)
EXEC tmpGetEmployeeManagers;
GO
-- Here's the actual self-join demo
SELECT e.EmployeeName, m.EmployeeName AS ManagerName
FROM Sales.Employee AS e
LEFT JOIN Sales.Employee AS m
ON e.ManagerID = m.EmployeeID
ORDER BY e.ManagerID;

/*
GO
DROP TABLE Sales.Employee;
GO
DROP PROCEDURE dbo.tmpGetEmployeeManagers;
GO
*/
