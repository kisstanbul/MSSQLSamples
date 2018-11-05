----------------------------------------------------------------------------------
-- Grouping
----------------------------------------------------------------------------------
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, count(prd.ProductID) AS Products
FROM SalesLT.vGetAllCategories as cat
LEFT JOIN SalesLT.Product AS prd
ON prd.ProductCategoryID = cat.ProductcategoryID
GROUP BY cat.ParentProductCategoryName, cat.ProductCategoryName
--GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
--GROUP BY ROLLUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
--GROUP BY CUBE (cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;
-- CUBE provides shortcut for defining grouping sets given a list of columns
SELECT Status, CustomerID, SUM(TotalDue) AS TotalAmountDue
FROM SalesLT.SalesOrderHeader
GROUP BY CUBE(Status, CustomerID)
ORDER BY Status, CustomerID;
-- ROLLUP provides shortcut for defining grouping sets, creates combinations assuming input columns form a hierarchy
SELECT Status, CustomerID, SUM(TotalDue) AS TotalAmountDue
FROM SalesLT.SalesOrderHeader
GROUP BY ROLLUP(Status, CustomerID)
ORDER BY Status, CustomerID;

----------------------------------------------------------------------------------
-- Pivot
----------------------------------------------------------------------------------
SELECT * FROM
(SELECT P.ProductID, PC.Name,ISNULL(P.Color, 'Uncolored') AS Color
 FROM saleslt.productcategory AS PC
 JOIN SalesLT.Product AS P
 ON PC.ProductCategoryID=P.ProductCategoryID
 ) AS PPC
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as pvt
ORDER BY Name;

-- Unpivot
CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int , multi int, uncolored int);

INSERT INTO #ProductColorPivot
SELECT * FROM
(SELECT P.ProductID, PC.Name,ISNULL(P.Color, 'Uncolored') AS Color
 FROM saleslt.productcategory AS PC
 JOIN SalesLT.Product AS P
 ON PC.ProductCategoryID=P.ProductCategoryID
 ) AS PPC
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])) as pvt
ORDER BY Name;

SELECT Name, Color, ProductCount
FROM
(SELECT Name,
[Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored]
FROM #ProductColorPivot) pcp
UNPIVOT
(ProductCount FOR Color IN ([Red],[Blue],[Black],[Silver],[Yellow],[Grey], [Multi], [Uncolored])
) AS ProductCounts







-- Unpivot
CREATE TABLE #SalesByQuarter
(ProductID int,
 Q1 money,
 Q2 money,
 Q3 money,
 Q4 money);

INSERT INTO #SalesByQuarter
VALUES
(1, 19999.00, 21567.00, 23340.00, 25876.00),
(2, 10997.00, 12465.00, 13367.00, 14365.00),
(3, 21900.00, 21999.00, 23376.00, 23676.00);

SELECT * FROM #SalesByQuarter;

SELECT ProductID, Period, Revenue
FROM
(SELECT ProductID,
Q1, Q2, Q3, Q4
FROM #SalesByQuarter) sbq
UNPIVOT
(Revenue FOR Period IN (Q1, Q2, Q3, Q4)
) AS RevenueReport
