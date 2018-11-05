-- Scalar
--Display a list of products whose list price is higher than the highest unit price of items that have sold
--
SELECT MAX(UnitPrice) FROM Sales.SalesOrderDetail;
--
SELECT *
FROM Production.Product
WHERE ListPrice > 50;
--
SELECT *
FROM Production.Product
WHERE ListPrice >
(
    SELECT MAX(UnitPrice)
    FROM Sales.SalesOrderDetail
);

-----------------------------------------------------------
-- Multi Valued
-- List products that have an order quantity greater than 20

SELECT Name
FROM Production.Product
WHERE ProductID IN
(
    SELECT ProductID
    FROM Sales.SalesOrderDetail
    WHERE OrderQty > 20
);
-----------------------------------------------------------
SELECT Name
FROM Production.Product P
     JOIN Sales.SalesOrderDetail SOD ON P.ProductID = SOD.ProductID
WHERE OrderQty > 20;
-----------------------------------------------------------
-- Correlated
-- For each customer list all sales on the last day that they made a sale
-----------------------------------------------------------
SELECT CustomerID,
       SalesOrderID,
       OrderDate
FROM Sales.SalesOrderHeader AS SO1
ORDER BY CustomerID,
         OrderDate;
-----------------------------------------------------------
SELECT CustomerID,
       SalesOrderID,
       OrderDate
FROM Sales.SalesOrderHeader AS SO1
WHERE orderdate =
(
    SELECT MAX(orderdate)
    FROM Sales.SalesOrderHeader
);
-----------------------------------------------------------
SELECT CustomerID,
       SalesOrderID,
       OrderDate
FROM Sales.SalesOrderHeader AS SO1
WHERE orderdate =
(
    SELECT MAX(orderdate)
    FROM Sales.SalesOrderHeader AS SO2
    WHERE SO2.CustomerID = SO1.CustomerID
)
ORDER BY CustomerID;
-----------------------------------------------------------