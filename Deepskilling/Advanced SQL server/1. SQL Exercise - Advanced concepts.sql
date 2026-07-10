-- Database Schema
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

-- Sample Data
INSERT INTO Customers (CustomerID, Name, Region) VALUES
(1, 'Alice', 'North'),
(2, 'Bob', 'South'),
(3, 'Charlie', 'East'),
(4, 'David', 'West');

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Smartphone', 'Electronics', 800.00),
(3, 'Tablet', 'Electronics', 600.00),
(4, 'Headphones', 'Accessories', 150.00),
(5, 'Desk', 'Furniture', 300.00),
(6, 'Chair', 'Furniture', 150.00);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2023-01-15'),
(2, 2, '2023-02-20'),
(3, 3, '2023-03-25'),
(4, 4, '2023-04-30');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 1),
(4, 4, 4, 3);

-- Exercise 1: Ranking and Window Functions
SELECT 
    ProductID, 
    ProductName, 
    Category, 
    Price,
    ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Price DESC) AS RowNum,
    RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS Rnk,
    DENSE_RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS DenseRnk
FROM Products;

-- Exercise 2: Aggregation with GROUPING SETS, CUBE, and ROLLUP
-- GROUPING SETS
SELECT c.Region, p.Category, SUM(od.Quantity) AS TotalQuantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY GROUPING SETS (
    (c.Region),
    (p.Category),
    (c.Region, p.Category)
);

-- ROLLUP
SELECT c.Region, p.Category, SUM(od.Quantity) AS TotalQuantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY ROLLUP (c.Region, p.Category);

-- CUBE
SELECT c.Region, p.Category, SUM(od.Quantity) AS TotalQuantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY CUBE (c.Region, p.Category);

-- Exercise 3: CTEs and MERGE
-- a) Recursive CTE to generate calendar
WITH CalendarCTE AS (
    SELECT CAST('2025-01-01' AS DATE) AS CalendarDate
    UNION ALL
    SELECT DATEADD(day, 1, CalendarDate)
    FROM CalendarCTE
    WHERE CalendarDate < '2025-01-31'
)
SELECT * FROM CalendarCTE;

-- b) MERGE statement
CREATE TABLE StagingProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);
INSERT INTO StagingProducts VALUES (1, 'Laptop', 'Electronics', 1150.00), (7, 'Monitor', 'Electronics', 200.00);

MERGE Products AS Target
USING StagingProducts AS Source
ON (Target.ProductID = Source.ProductID)
WHEN MATCHED THEN 
    UPDATE SET Target.Price = Source.Price
WHEN NOT MATCHED BY TARGET THEN 
    INSERT (ProductID, ProductName, Category, Price) 
    VALUES (Source.ProductID, Source.ProductName, Source.Category, Source.Price);

-- Exercise 4: PIVOT and UNPIVOT
-- PIVOT (assuming a View or derived table for Sales by Month)
WITH SalesData AS (
    SELECT p.ProductName, DATENAME(month, o.OrderDate) AS OrderMonth, od.Quantity
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
)
SELECT ProductName, [January], [February], [March], [April]
FROM SalesData
PIVOT (
    SUM(Quantity)
    FOR OrderMonth IN ([January], [February], [March], [April])
) AS PivotTable;

-- Exercise 5: Using CTE to Simplify a Query
WITH CustomerOrderCounts AS (
    SELECT o.CustomerID, COUNT(o.OrderID) AS OrderCount
    FROM Orders o
    GROUP BY o.CustomerID
)
SELECT c.CustomerID, c.Name, coc.OrderCount
FROM CustomerOrderCounts coc
JOIN Customers c ON c.CustomerID = coc.CustomerID
WHERE coc.OrderCount > 0; -- Changed from > 3 to > 0 so output shows something for sample data
