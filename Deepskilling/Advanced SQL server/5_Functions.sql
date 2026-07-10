-- SQL Exercises - Functions
-- Answers to all exercise questions

-- Clean up existing functions and tables
IF OBJECT_ID('dbo.fn_CalculateTotalCompensation', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_CalculateTotalCompensation;
IF OBJECT_ID('dbo.fn_CalculateBonus', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_CalculateBonus;
IF OBJECT_ID('dbo.fn_CalculateAnnualSalary', 'FN') IS NOT NULL DROP FUNCTION dbo.fn_CalculateAnnualSalary;
IF OBJECT_ID('dbo.fn_GetEmployeesByDepartment', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_GetEmployeesByDepartment;
IF OBJECT_ID('dbo.fn_GetEmployeesByDepartment', 'TF') IS NOT NULL DROP FUNCTION dbo.fn_GetEmployeesByDepartment;
GO

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

-- Insert sample records with custom names: praveen, kumar, siva, durga
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'Praveen', 'Kumar', 1, 5000.00, '2020-01-15'),
(2, 'Siva', 'Kumar', 2, 6000.00, '2019-03-22'),
(3, 'Durga', 'Prasad', 3, 5500.00, '2021-07-01');
GO

-- Exercise 1: Create a Scalar Function
-- fn_CalculateAnnualSalary returns Salary * 12
CREATE FUNCTION fn_CalculateAnnualSalary
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 12;
END;
GO

-- Test function on all records
SELECT EmployeeID, FirstName, Salary, dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM Employees;
GO

-- Exercise 2: Create a Table-Valued Function
-- fn_GetEmployeesByDepartment returns a list of employees filtered by DepartmentID
CREATE FUNCTION fn_GetEmployeesByDepartment
(
    @DepartmentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate
    FROM Employees
    WHERE DepartmentID = @DepartmentID
);
GO

-- Test function for IT department (Siva Kumar, DepartmentID = 2)
SELECT * FROM dbo.fn_GetEmployeesByDepartment(2);
GO

-- Exercise 3: Create a User-Defined Function
-- fn_CalculateBonus returns 10% of salary
CREATE FUNCTION fn_CalculateBonus
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;
GO

-- Test bonus function
SELECT EmployeeID, FirstName, Salary, dbo.fn_CalculateBonus(Salary) AS BonusAmount
FROM Employees;
GO

-- Exercise 4: Modify a User-Defined Function
-- Altering fn_CalculateBonus to return 15% of salary
ALTER FUNCTION fn_CalculateBonus
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.15;
END;
GO

-- Test modified bonus function
SELECT EmployeeID, FirstName, Salary, dbo.fn_CalculateBonus(Salary) AS NewBonusAmount
FROM Employees;
GO

-- Exercise 5: Delete a User-Defined Function
-- Drop the bonus function
DROP FUNCTION dbo.fn_CalculateBonus;
GO

-- Verify deletion (check if exists in sys.objects)
IF OBJECT_ID('dbo.fn_CalculateBonus', 'FN') IS NULL
    PRINT 'Bonus function successfully dropped.';
ELSE
    PRINT 'Bonus function drop failed.';
GO

-- Exercise 6: Execute a User-Defined Function
-- Get annual salary for all employees using UDF
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateAnnualSalary(Salary) AS CalculatedAnnualSalary
FROM Employees;
GO

-- Exercise 7: Return Data from a Scalar Function
-- Get annual salary specifically for EmployeeID = 1
SELECT dbo.fn_CalculateAnnualSalary(Salary) AS Employee1AnnualSalary
FROM Employees
WHERE EmployeeID = 1;
GO

-- Exercise 8: Return Data from a Table-Valued Function
-- Get all records from TVF for DepartmentID = 3
SELECT * FROM dbo.fn_GetEmployeesByDepartment(3);
GO

-- Exercise 9: Create a Nested User-Defined Function
-- Note: Since fn_CalculateBonus was dropped in Exercise 5, we recreate it here to avoid compiler errors.
CREATE FUNCTION fn_CalculateBonus
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10; -- Standard 10% bonus
END;
GO

-- Nested function: calls both annual salary and bonus functions
CREATE FUNCTION fn_CalculateTotalCompensation
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Annual DECIMAL(10,2);
    DECLARE @Bonus DECIMAL(10,2);
    
    SET @Annual = dbo.fn_CalculateAnnualSalary(@Salary);
    SET @Bonus = dbo.fn_CalculateBonus(@Salary);
    
    RETURN @Annual + @Bonus;
END;
GO

-- Test nested function
SELECT EmployeeID, FirstName, Salary, dbo.fn_CalculateTotalCompensation(Salary) AS TotalCompensation
FROM Employees;
GO

-- Exercise 10: Modify a Nested User-Defined Function
-- Altering the bonus first to 15%, then updating nested compensation function
ALTER FUNCTION fn_CalculateBonus
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.15;
END;
GO

ALTER FUNCTION fn_CalculateTotalCompensation
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Annual DECIMAL(10,2);
    DECLARE @Bonus DECIMAL(10,2);
    
    SET @Annual = dbo.fn_CalculateAnnualSalary(@Salary);
    SET @Bonus = dbo.fn_CalculateBonus(@Salary);
    
    RETURN @Annual + @Bonus;
END;
GO

-- Test modified nested function
SELECT EmployeeID, FirstName, Salary, dbo.fn_CalculateTotalCompensation(Salary) AS NewTotalCompensation
FROM Employees;
GO
