-- SQL Exercises - Stored Procedures
-- Answers to all exercise questions

-- Clean up existing stored procedures and tables
IF OBJECT_ID('dbo.sp_GetEmployeesByDepartment', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetEmployeesByDepartment;
IF OBJECT_ID('dbo.sp_InsertEmployee', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_InsertEmployee;
IF OBJECT_ID('dbo.sp_GetEmployeeCountByDepartment', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetEmployeeCountByDepartment;
IF OBJECT_ID('dbo.sp_GetTotalSalaryByDepartment', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetTotalSalaryByDepartment;
IF OBJECT_ID('dbo.sp_UpdateEmployeeSalary', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_UpdateEmployeeSalary;
IF OBJECT_ID('dbo.sp_GiveBonus', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GiveBonus;
IF OBJECT_ID('dbo.sp_UpdateEmployeeSalaryWithTransaction', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_UpdateEmployeeSalaryWithTransaction;
IF OBJECT_ID('dbo.sp_GetEmployeesDynamic', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GetEmployeesDynamic;
IF OBJECT_ID('dbo.sp_UpdateEmployeeSalaryWithErrorHandling', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_UpdateEmployeeSalaryWithErrorHandling;
GO

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- Create tables
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- Note: We use IDENTITY(1,1) for EmployeeID so insertions are simple and don't conflict
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
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
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
('Praveen', 'Kumar', 1, 5000.00, '2020-01-15'),
('Siva', 'Kumar', 2, 6000.00, '2019-03-22'),
('Durga', 'Prasad', 3, 7000.00, '2018-07-30'),
('Kumar', 'Siva', 4, 5500.00, '2021-11-05');
GO

-- Exercise 1: Create a Stored Procedure
-- Part 1: Retrieve employee details based on DepartmentID
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Part 2: Insert a new employee
CREATE PROCEDURE sp_InsertEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoinDate DATE
AS
BEGIN
    INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, JoinDate)
    VALUES (@FirstName, @LastName, @DepartmentID, @Salary, @JoinDate);
END;
GO

-- Exercise 2: Modify a Stored Procedure
-- Modify sp_GetEmployeesByDepartment to include the Salary column
ALTER PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Exercise 4: Execute a Stored Procedure
-- Test running the modified stored procedure
EXEC sp_GetEmployeesByDepartment @DepartmentID = 3;
GO

-- Exercise 3: Delete a Stored Procedure
-- (Commented out so we can use the procedure in later steps)
-- DROP PROCEDURE sp_GetEmployeesByDepartment;
-- GO

-- Exercise 5: Return Data from a Stored Procedure
-- Returns count of employees in a department
CREATE PROCEDURE sp_GetEmployeeCountByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT COUNT(*) AS EmployeeCount
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Test count procedure
EXEC sp_GetEmployeeCountByDepartment @DepartmentID = 1;
GO

-- Exercise 6: Use Output Parameters in a Stored Procedure
-- Returns sum of salaries as an output parameter
CREATE PROCEDURE sp_GetTotalSalaryByDepartment
    @DepartmentID INT,
    @TotalSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalSalary = SUM(Salary)
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Test output parameters
DECLARE @TotalSalaryResult DECIMAL(10,2);
EXEC sp_GetTotalSalaryByDepartment @DepartmentID = 3, @TotalSalary = @TotalSalaryResult OUTPUT;
SELECT @TotalSalaryResult AS TotalITSalary;
GO

-- Exercise 7: Create a Stored Procedure with Multiple Parameters
-- Updates salary of an employee
CREATE PROCEDURE sp_UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- Test updating salary
EXEC sp_UpdateEmployeeSalary 1, 5500.00;
SELECT * FROM Employees WHERE EmployeeID = 1;
GO

-- Exercise 8: Create a Stored Procedure with Conditional Logic
-- Gives a bonus based on department rules
CREATE PROCEDURE sp_GiveBonus
    @EmployeeID INT,
    @BonusAmount DECIMAL(10,2)
AS
BEGIN
    DECLARE @DeptID INT;
    SELECT @DeptID = DepartmentID FROM Employees WHERE EmployeeID = @EmployeeID;

    IF @DeptID = 1 -- HR gets 10% extra
    BEGIN
        UPDATE Employees
        SET Salary = Salary + (@BonusAmount * 1.10)
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE IF @DeptID = 3 -- IT gets 20% extra
    BEGIN
        UPDATE Employees
        SET Salary = Salary + (@BonusAmount * 1.20)
        WHERE EmployeeID = @EmployeeID;
    END
    ELSE
    BEGIN
        UPDATE Employees
        SET Salary = Salary + @BonusAmount
        WHERE EmployeeID = @EmployeeID;
    END
END;
GO

-- Test conditional bonus
EXEC sp_GiveBonus 1, 500.00;
SELECT * FROM Employees WHERE EmployeeID = 1;
GO

-- Exercise 9: Use Transactions in a Stored Procedure
-- Wrap salary update inside a transaction to ensure integrity
CREATE PROCEDURE sp_UpdateEmployeeSalaryWithTransaction
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        COMMIT TRANSACTION;
        PRINT 'Update committed.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Update failed. Transaction rolled back.';
    END CATCH
END;
GO

-- Test transaction procedure
EXEC sp_UpdateEmployeeSalaryWithTransaction 2, 6500.00;
GO

-- Exercise 10: Use Dynamic SQL in a Stored Procedure
-- Dynamic column filtering
CREATE PROCEDURE sp_GetEmployeesDynamic
    @FilterColumn VARCHAR(50),
    @FilterValue VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Safe dynamic column concatenation using QUOTENAME
    SET @SQL = N'SELECT EmployeeID, FirstName, LastName, Salary 
                 FROM Employees 
                 WHERE ' + QUOTENAME(@FilterColumn) + N' = @Val';

    EXEC sp_executesql @SQL, N'@Val VARCHAR(100)', @Val = @FilterValue;
END;
GO

-- Test dynamic query
EXEC sp_GetEmployeesDynamic @FilterColumn = 'FirstName', @FilterValue = 'Siva';
GO

-- Exercise 11: Handle Errors in a Stored Procedure
-- Update salary with error checks and try/catch block
CREATE PROCEDURE sp_UpdateEmployeeSalaryWithErrorHandling
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        IF @NewSalary < 0
        BEGIN
            THROW 50000, 'Salary cannot be negative.', 1;
        END

        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;
        
        PRINT 'Salary updated.';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_MESSAGE() AS CustomErrorMessage;
    END CATCH
END;
GO

-- Test error handler with negative salary
EXEC sp_UpdateEmployeeSalaryWithErrorHandling @EmployeeID = 1, @NewSalary = -100.00;
GO
