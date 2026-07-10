-- Database Schema
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

-- Sample Data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'), (2, 'Finance'), (3, 'IT'), (4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2020-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2019-03-22'),
(3, 'Bob', 'Johnson', 3, 5500.00, '2021-07-01');

-- Exercise 1: Create a Simple View
GO
CREATE VIEW vw_EmployeeBasicInfo AS
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO

-- Exercise 2: Add Computed Column - Full Name
CREATE VIEW vw_EmployeeFullName AS
SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, DepartmentID
FROM Employees;
GO

-- Exercise 3: Add Computed Column - Annual Salary
CREATE VIEW vw_EmployeeAnnualSalary AS
SELECT EmployeeID, Salary, (Salary * 12) AS AnnualSalary
FROM Employees;
GO

-- Exercise 4: Add Multiple Computed Columns
CREATE VIEW vw_EmployeeReport AS
SELECT 
    e.EmployeeID, 
    e.FirstName + ' ' + e.LastName AS FullName, 
    d.DepartmentName,
    (e.Salary * 12) AS AnnualSalary,
    ((e.Salary * 12) * 0.10) AS Bonus
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;
GO
