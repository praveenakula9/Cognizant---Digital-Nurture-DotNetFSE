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

-- Exercise 1: Create a Scalar Function
GO
CREATE FUNCTION fn_CalculateAnnualSalary (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 12;
END;
GO
SELECT EmployeeID, FirstName, dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary FROM Employees;

-- Exercise 2: Create a Table-Valued Function
GO
CREATE FUNCTION fn_GetEmployeesByDepartment (@DepartmentID INT)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Employees WHERE DepartmentID = @DepartmentID
);
GO
SELECT * FROM dbo.fn_GetEmployeesByDepartment(3);

-- Exercise 3: Create a User-Defined Function
GO
CREATE FUNCTION fn_CalculateBonus (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;
GO
SELECT EmployeeID, FirstName, dbo.fn_CalculateBonus(Salary) AS Bonus FROM Employees;

-- Exercise 4: Modify a User-Defined Function
GO
ALTER FUNCTION fn_CalculateBonus (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.15;
END;
GO
SELECT EmployeeID, FirstName, dbo.fn_CalculateBonus(Salary) AS Bonus FROM Employees;

-- Exercise 5: Delete a User-Defined Function
-- DROP FUNCTION fn_CalculateBonus;

-- Exercise 6: Execute a User-Defined Function
SELECT EmployeeID, FirstName, dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary FROM Employees;

-- Exercise 7: Return Data from a Scalar Function
SELECT dbo.fn_CalculateAnnualSalary((SELECT Salary FROM Employees WHERE EmployeeID = 1)) AS Employee1AnnualSalary;

-- Exercise 8: Return Data from a Table-Valued Function
SELECT * FROM dbo.fn_GetEmployeesByDepartment(3);

-- Exercise 9: Create a Nested User-Defined Function
GO
-- Recreate the bonus function if it was dropped in Exercise 5
CREATE OR ALTER FUNCTION fn_CalculateBonus (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;
GO
CREATE FUNCTION fn_CalculateTotalCompensation (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN dbo.fn_CalculateAnnualSalary(@Salary) + dbo.fn_CalculateBonus(@Salary);
END;
GO
SELECT EmployeeID, FirstName, dbo.fn_CalculateTotalCompensation(Salary) AS TotalCompensation FROM Employees;

-- Exercise 10: Modify a Nested User-Defined Function
GO
ALTER FUNCTION fn_CalculateTotalCompensation (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    -- Using the modified bonus calculation for demonstration directly inside or changing the nested function
    RETURN dbo.fn_CalculateAnnualSalary(@Salary) + (dbo.fn_CalculateBonus(@Salary) * 1.5);
END;
GO
SELECT EmployeeID, FirstName, dbo.fn_CalculateTotalCompensation(Salary) AS TotalCompensation FROM Employees;
