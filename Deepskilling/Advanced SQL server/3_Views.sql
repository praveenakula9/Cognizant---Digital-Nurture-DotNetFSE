-- SQL Exercises - Views
-- Answers to all exercise questions

-- Clean up views first, then tables
IF OBJECT_ID('dbo.vw_EmployeeReport', 'V') IS NOT NULL DROP VIEW dbo.vw_EmployeeReport;
IF OBJECT_ID('dbo.vw_EmployeeAnnualSalary', 'V') IS NOT NULL DROP VIEW dbo.vw_EmployeeAnnualSalary;
IF OBJECT_ID('dbo.vw_EmployeeFullName', 'V') IS NOT NULL DROP VIEW dbo.vw_EmployeeFullName;
IF OBJECT_ID('dbo.vw_EmployeeBasicInfo', 'V') IS NOT NULL DROP VIEW dbo.vw_EmployeeBasicInfo;
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
    Salary DECIMAL(10, 2),
    JoinDate DATE
);
GO

-- Insert sample records with custom names: praveen, kumar, siva, durga
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'Praveen', 'Kumar', 3, 5000.00, '2020-01-15'),
(2, 'Siva', 'Kumar', 2, 6000.00, '2019-03-22'),
(3, 'Durga', 'Prasad', 1, 7000.00, '2018-07-30'),
(4, 'Kumar', 'Siva', 4, 5500.00, '2021-11-05');
GO

-- Exercise 1: Create a Simple View
-- vw_EmployeeBasicInfo shows EmployeeID, FirstName, LastName, DepartmentName
CREATE VIEW vw_EmployeeBasicInfo AS
SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- Select from view
SELECT * FROM vw_EmployeeBasicInfo;
GO

-- Exercise 2: Add Computed Column - Full Name
-- vw_EmployeeFullName includes computed FullName (concatenation)
CREATE OR ALTER VIEW vw_EmployeeFullName AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName
FROM Employees;
GO

-- Select from view
SELECT * FROM vw_EmployeeFullName;
GO

-- Exercise 3: Add Computed Column - Annual Salary
-- vw_EmployeeAnnualSalary includes computed AnnualSalary (Salary * 12)
CREATE VIEW vw_EmployeeAnnualSalary AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM Employees;
GO

-- Select from view
SELECT * FROM vw_EmployeeAnnualSalary;
GO

-- Exercise 4: Add Multiple Computed Columns
-- vw_EmployeeReport with EmployeeID, FullName, DepartmentName, AnnualSalary, Bonus (10%)
CREATE VIEW vw_EmployeeReport AS
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    e.Salary * 12 AS AnnualSalary,
    (e.Salary * 12) * 0.10 AS Bonus
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- Select from view
SELECT * FROM vw_EmployeeReport;
GO
