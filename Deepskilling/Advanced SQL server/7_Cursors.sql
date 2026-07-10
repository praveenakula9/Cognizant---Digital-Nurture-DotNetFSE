-- SQL Exercises - Cursors
-- Answers to all exercise questions

-- Clean up existing tables
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- Create tables
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10,2),
    JoinDate DATE
);
GO

-- Populate tables with custom names: praveen, kumar, siva, durga
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'Praveen', 'Kumar', 1, 5000.00, '2020-01-15'),
(2, 'Siva', 'Kumar', 2, 6000.00, '2019-03-22'),
(3, 'Durga', 'Prasad', 3, 5500.00, '2021-07-30');
GO

-- Exercise 1: Create a Cursor
-- Declare cursor, fetch and print employee details, then close/deallocate cursor

-- Variables for fetched records
DECLARE @EmpID INT;
DECLARE @FirstName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @Salary DECIMAL(10,2);

-- Declare
DECLARE emp_cursor CURSOR FOR
SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees;

-- Open
OPEN emp_cursor;

-- First fetch
FETCH NEXT FROM emp_cursor 
INTO @EmpID, @FirstName, @LastName, @Salary;

-- Loop
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Employee: ' + CAST(@EmpID AS VARCHAR(10)) + ' | ' + @FirstName + ' ' + @LastName + ' | Salary: ' + CAST(@Salary AS VARCHAR(12));
    
    FETCH NEXT FROM emp_cursor 
    INTO @EmpID, @FirstName, @LastName, @Salary;
END;

-- Close and cleanup
CLOSE emp_cursor;
DEALLOCATE emp_cursor;
GO

-- Exercise 2: Types of Cursors
-- Demonstration of different cursor types syntax in SQL Server

-- 1. Static Cursor (copies result set to tempdb, read-only copy of data)
DECLARE static_cursor CURSOR STATIC FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN static_cursor;
CLOSE static_cursor;
DEALLOCATE static_cursor;

-- 2. Dynamic Cursor (reflects all modifications by other processes live)
DECLARE dynamic_cursor CURSOR DYNAMIC FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN dynamic_cursor;
CLOSE dynamic_cursor;
DEALLOCATE dynamic_cursor;

-- 3. Forward-Only Cursor (sequential iteration from start to end only, lightweight)
DECLARE forward_cursor CURSOR FORWARD_ONLY FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN forward_cursor;
CLOSE forward_cursor;
DEALLOCATE forward_cursor;

-- 4. Keyset-driven Cursor (keyset of primary keys is built, membership is frozen, but non-keys update dynamically)
DECLARE keyset_cursor CURSOR KEYSET FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN keyset_cursor;
CLOSE keyset_cursor;
DEALLOCATE keyset_cursor;
GO
