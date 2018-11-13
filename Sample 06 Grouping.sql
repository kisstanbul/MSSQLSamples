----------------------------------------------------------------------------------
-- Grouping
----------------------------------------------------------------------------------
-- A) Use a simple GROUP BY clause
SELECT SalesOrderID,
       SUM(LineTotal) AS SubTotal
FROM Sales.SalesOrderDetail AS sod
GROUP BY SalesOrderID
ORDER BY SalesOrderID;  
-- B) Use a GROUP BY clause with multiple tables
SELECT a.City,
       COUNT(bea.AddressID) EmployeeCount
FROM Person.BusinessEntityAddress AS bea
     INNER JOIN Person.Address AS a ON bea.AddressID = a.AddressID
GROUP BY a.City
ORDER BY a.City;  
-- C) Use a GROUP BY clause with a HAVING clause
SELECT DATEPART(yyyy, OrderDate) AS N'Year',
       SUM(TotalDue) AS N'Total Order Amount'
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(yyyy, OrderDate)
HAVING DATEPART(yyyy, OrderDate) >= N'2003'
ORDER BY DATEPART(yyyy, OrderDate); 
--

CREATE TABLE Sales
(Country VARCHAR(50),
 Region  VARCHAR(50),
 Sales   INT
);
INSERT INTO sales
VALUES
(N'Canada',
 N'Alberta',
 100
);
INSERT INTO sales
VALUES
(N'Canada',
 N'British Columbia',
 200
);
INSERT INTO sales
VALUES
(N'Canada',
 N'British Columbia',
 300
);
INSERT INTO sales
VALUES
(N'United States',
 N'Montana',
 100
);
--
SELECT Country,
       Region,
       SUM(sales) AS TotalSales
FROM Sales
GROUP BY Country,
         Region;
--
SELECT Country,
       Region,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY ROLLUP(Country, Region);
--
SELECT Country,
       Region,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY CUBE(Country, Region);
--
SELECT Country,
       Region,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY GROUPING SETS(ROLLUP(Country, Region), CUBE(Country, Region));
--
----------------------------------------------------------------------------------
-- Pivot
----------------------------------------------------------------------------------
-- Select 
SELECT PS.Name,
       P.Color,
       PIn.Quantity
FROM Production.Product P
     INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = P.ProductSubcategoryID
     LEFT JOIN Production.ProductInventory PIn ON P.ProductID = PIn.ProductID;
--Pivot
SELECT *
FROM
(
    SELECT PS.Name,
           P.Color,
           PIn.Quantity
    FROM Production.Product P
         INNER JOIN Production.ProductSubcategory PS ON PS.ProductSubcategoryID = P.ProductSubcategoryID
         LEFT JOIN Production.ProductInventory PIn ON P.ProductID = PIn.ProductID
) DataTable PIVOT(SUM(Quantity) FOR Color IN(Black,
                                             Blue,
                                             Grey,
                                             Multi,
                                             Red,
                                             Silver,
                                             [Silver/Black],
                                             White,
                                             Yellow)) PivotTable;
-- Pivot2
SELECT *
FROM
(
    SELECT YEAR(OrderDate) [Year],
           MONTH(OrderDate) [Month],
           SubTotal
    FROM Sales.SalesOrderHeader
) TableDate PIVOT(SUM(SubTotal) FOR [Month] IN([1],
                                               [2],
                                               [3],
                                               [4],
                                               [5],
                                               [6],
                                               [7],
                                               [8],
                                               [9],
                                               [10],
                                               [11],
                                               [12])) PivotTable;
-- UnPivot
CREATE TABLE pvt (VendorID int, Emp1 int, Emp2 int,
Emp3 int, Emp4 int, Emp5 int)
GO
INSERT INTO pvt VALUES (1,4,3,5,4,4)
INSERT INTO pvt VALUES (2,4,1,5,5,5)
INSERT INTO pvt VALUES (3,4,3,5,4,4)
INSERT INTO pvt VALUES (4,4,2,5,5,4)
INSERT INTO pvt VALUES (5,5,1,5,5,5)
GO
--Unpivot the table.
SELECT VendorID, Employee, Orders
FROM
(SELECT VendorID, Emp1, Emp2, Emp3, Emp4, Emp5
FROM pvt) p
UNPIVOT
(Orders FOR Employee IN
(Emp1, Emp2, Emp3, Emp4, Emp5)
)AS unpvt
GO
