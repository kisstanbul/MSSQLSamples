-- Create a table for the demo
DROP TABLE Sales.CallLog;
CREATE TABLE Sales.CallLog
(
	CallID int IDENTITY PRIMARY KEY NOT NULL,
	CallTime datetime NOT NULL DEFAULT GETDATE(),
	SalesPerson nvarchar(256) NOT NULL,
	CustomerID int NOT NULL REFERENCES Sales.Customer(CustomerID),
	PhoneNumber nvarchar(25) NOT NULL,
	Notes nvarchar(max) NULL,
);
GO

-- Insert a row
INSERT INTO Sales.CallLog VALUES ('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, '245-555-0173', 'Returning call re: enquiry about delivery');

SELECT * FROM Sales.CallLog;

-- Insert defaults and nulls
INSERT INTO Sales.CallLog VALUES (DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);

SELECT * FROM Sales.CallLog;

-- Insert a row with explicit columns
INSERT INTO Sales.CallLog (SalesPerson, CustomerID, PhoneNumber) VALUES ('adventure-works\jillian0', 3, '279-555-0130');

SELECT * FROM Sales.CallLog;

-- Insert multiple rows
INSERT INTO Sales.CallLog VALUES(DATEADD(mi,-2, GETDATE()), 'adventure-works\jillian0', 4, '710-555-0173', NULL),
(DEFAULT, 'adventure-works\shu0', 5, '828-555-0186', 'Called to arrange deliver of order 10987');

SELECT * FROM Sales.CallLog;

-- Insert the results of a query
INSERT INTO Sales.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT p.FirstName+ ' '+p.LastName , CustomerID, pp.PhoneNumber, 'Sales promotion call'
FROM [Sales].[SalesPerson] sp 
INNER JOIN [Sales].[SalesOrderHeader] soh ON sp.[BusinessEntityID] = soh.[SalesPersonID]
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = sp.[BusinessEntityID]
LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.[BusinessEntityID] = p.[BusinessEntityID]
WHERE pp.PhoneNumber IS NOT NULL;

SELECT * FROM Sales.CallLog;

-- Retrieving inserted identity
INSERT INTO Sales.CallLog (SalesPerson, CustomerID, PhoneNumber) VALUES ('adventure-works\josé1', 10, '150-555-0127');
SELECT SCOPE_IDENTITY();
SELECT * FROM Sales.CallLog;

--Overriding Identity
SET IDENTITY_INSERT Sales.CallLog ON;
INSERT INTO Sales.CallLog (CallID, SalesPerson, CustomerID, PhoneNumber) VALUES (9, 'adventure-works\josé1', 11, '926-555-0159');
SET IDENTITY_INSERT Sales.CallLog OFF;
SELECT * FROM Sales.CallLog;


-- Update a table
UPDATE Sales.CallLog  
SET Notes = 'No notes' 
WHERE Notes IS NULL;

SELECT * FROM Sales.CallLog;

-- Update multiple columns
UPDATE Sales.CallLog
SET SalesPerson = '', PhoneNumber = ''

SELECT * FROM Sales.CallLog;

-- Update from results of a query
UPDATE Sales.CallLog
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM [Sales].[SalesPerson] sp 
INNER JOIN [Sales].[SalesOrderHeader] soh ON sp.[BusinessEntityID] = soh.[SalesPersonID]
INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = sp.[BusinessEntityID]
LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.[BusinessEntityID] = p.[BusinessEntityID]
WHERE soh.CustomerID = Sales.CallLog.CustomerID;

SELECT * FROM Sales.CallLog;

-- Delete rows
DELETE FROM Sales.CallLog
WHERE CallTime < DATEADD(dd, -7, GETDATE());

SELECT * FROM Sales.CallLog;

-- Truncate the table
TRUNCATE TABLE Sales.CallLog;

SELECT * FROM Sales.CallLog;
