-- SQL Exercises - Advanced Concepts
-- Answers to all PDF exercises

-- Clean up existing tables to start fresh
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.StagingProducts', 'U') IS NOT NULL DROP TABLE dbo.StagingProducts;
GO

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Insert sample data with custom names: praveen, kumar, siva, durga
INSERT INTO Customers (CustomerID, Name, Region) VALUES
(1, 'praveen', 'North'),
(2, 'kumar', 'South'),
(3, 'siva', 'East'),
(4, 'durga', 'West');

-- Adding products with some matching prices to show ranking ties
INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Elite', 'Electronics', 1200.00),
(2, 'Laptop Pro', 'Electronics', 1200.00), -- Tie price
(3, 'Smartphone X', 'Electronics', 800.00),
(4, 'Tablet Max', 'Electronics', 600.00),
(5, 'Wireless Mouse', 'Accessories', 50.00),
(6, 'Mechanical Keyboard', 'Accessories', 150.00),
(7, 'HD Monitor', 'Accessories', 300.00),
(8, 'Bluetooth Speaker', 'Accessories', 150.00);

-- Insert orders (need to give praveen > 3 orders to test CTE query later)
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2025-01-10'),
(2, 1, '2025-01-15'),
(3, 1, '2025-01-20'),
(4, 1, '2025-01-25'),
(5, 2, '2025-01-12'),
(6, 3, '2025-01-18'),
(7, 4, '2025-01-22');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 1),
(2, 2, 3, 2),
(3, 3, 4, 1),
(4, 4, 6, 3),
(5, 5, 2, 1),
(6, 6, 7, 2),
(7, 7, 5, 5);
GO

-- Exercise 1: Ranking and Window Functions
-- Finding top 3 expensive products per category using ROW_NUMBER, RANK, and DENSE_RANK
WITH RankedProducts AS (
    SELECT 
        ProductName,
        Category,
        Price,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Price DESC) AS RowNum,
        RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS PriceRank,
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS PriceDenseRank
    FROM Products
)
SELECT 
    Category,
    ProductName,
    Price,
    RowNum,
    PriceRank,
    PriceDenseRank
FROM RankedProducts
WHERE PriceDenseRank <= 3
ORDER BY Category, Price DESC;
GO

-- Exercise 2: Aggregation with GROUPING SETS, ROLLUP, and CUBE

-- 1. Using GROUPING SETS for specific dimensions: (Region, Category), (Region), (Category), and Grand Total
SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY GROUPING SETS (
    (c.Region, p.Category),
    (c.Region),
    (p.Category),
    ()
)
ORDER BY c.Region, p.Category;

-- 2. Using ROLLUP to get hierarchical subtotals
SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY ROLLUP (c.Region, p.Category)
ORDER BY c.Region, p.Category;

-- 3. Using CUBE for all grouping combinations
SELECT 
    c.Region,
    p.Category,
    SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY CUBE (c.Region, p.Category)
ORDER BY c.Region, p.Category;
GO

-- Exercise 3: CTEs and MERGE

-- a) Recursive CTE to generate dates from Jan 1st to Jan 31st, 2025
WITH CalendarDates AS (
    SELECT CAST('2025-01-01' AS DATE) AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM CalendarDates
    WHERE CalendarDate < '2025-01-31'
)
SELECT CalendarDate 
FROM CalendarDates
OPTION (MAXRECURSION 31);
GO

-- b) MERGE statement to update or insert product details from a staging table
CREATE TABLE StagingProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

INSERT INTO StagingProducts (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Elite v2', 'Electronics', 1250.00), -- Existing, price/name changed
(3, 'Smartphone X', 'Electronics', 780.00),       -- Existing, price reduced
(9, 'Gaming Mouse', 'Accessories', 80.00);        -- New product

-- Run MERGE
MERGE INTO Products AS Target
USING StagingProducts AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        Target.ProductName = Source.ProductName,
        Target.Category = Source.Category,
        Target.Price = Source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Category, Price)
    VALUES (Source.ProductID, Source.ProductName, Source.Category, Source.Price);

-- Check results
SELECT * FROM Products;
GO

-- Exercise 4: PIVOT and UNPIVOT

-- View to summarize sales by product and month
IF OBJECT_ID('dbo.vw_MonthlySalesSummary', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_MonthlySalesSummary;
GO

CREATE VIEW vw_MonthlySalesSummary AS
SELECT 
    p.ProductName,
    DATENAME(MONTH, o.OrderDate) AS OrderMonth,
    od.Quantity
FROM OrderDetails od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID;
GO

-- Pivot month rows into columns
SELECT ProductName, [January] AS Jan_Sales
FROM vw_MonthlySalesSummary
PIVOT (
    SUM(Quantity) 
    FOR OrderMonth IN ([January])
) AS PivotedSales;

-- Unpivoting the data back
WITH PivotedData AS (
    SELECT ProductName, ISNULL([January], 0) AS January
    FROM vw_MonthlySalesSummary
    PIVOT (
        SUM(Quantity) 
        FOR OrderMonth IN ([January])
    ) AS PivotedSalesTable
)
SELECT ProductName, OrderMonth, Quantity
FROM PivotedData
UNPIVOT (
    Quantity FOR OrderMonth IN (January)
) AS UnpivotedSalesTable;
GO

-- Exercise 5: Using CTE to Simplify a Query
-- Finding customers with more than 3 orders
WITH CustomerOrderCounts AS (
    SELECT 
        o.CustomerID,
        COUNT(o.OrderID) AS OrderCount
    FROM Orders o
    GROUP BY o.CustomerID
)
SELECT 
    c.CustomerID,
    c.Name,
    coc.OrderCount
FROM CustomerOrderCounts coc
JOIN Customers c ON c.CustomerID = coc.CustomerID
WHERE coc.OrderCount > 3; -- praveen has 4 orders
GO
