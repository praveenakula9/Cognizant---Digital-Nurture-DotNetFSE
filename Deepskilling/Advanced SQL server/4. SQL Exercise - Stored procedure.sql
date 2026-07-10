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
(3, 'Michael', 'Johnson', 3, 7000.00, '2018-07-30'),
(4, 'Emily', 'Davis', 4, 5500.00, '2021-11-05');

-- Exercise 1: Create a Stored Procedure
GO
CREATE PROCEDURE sp_InsertEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoinDate DATE
AS
BEGIN
    -- Providing a manual EmployeeID since the schema doesn't use IDENTITY
    DECLARE @NewEmployeeID INT;
    SELECT @NewEmployeeID = ISNULL(MAX(EmployeeID), 0) + 1 FROM Employees;
    
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate)
    VALUES (@NewEmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate);
END;
GO

-- Exercise 2: Modify a Stored Procedure
-- Note: The PDF asked to retrieve employee details by department, so we create one for retrieval.
GO
CREATE PROCEDURE sp_GetEmployeesByDept
    @DepartmentID INT
AS
BEGIN
    SELECT FirstName, LastName, DepartmentID, Salary
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Exercise 3: Delete a Stored Procedure
-- DROP PROCEDURE sp_InsertEmployee;

-- Exercise 4: Execute a Stored Procedure
EXEC sp_GetEmployeesByDept @DepartmentID = 1;

-- Exercise 5: Return Data from a Stored Procedure
GO
CREATE PROCEDURE sp_CountEmployeesByDept
    @DepartmentID INT
AS
BEGIN
    SELECT COUNT(*) AS EmployeeCount 
    FROM Employees 
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Exercise 6: Use Output Parameters in a Stored Procedure
GO
CREATE PROCEDURE sp_GetTotalSalaryByDept
    @DepartmentID INT,
    @TotalSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalSalary = SUM(Salary)
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;
GO

-- Exercise 7: Create a Stored Procedure with Multiple Parameters
GO
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
EXEC sp_UpdateEmployeeSalary 1, 5500.00;

-- Exercise 8: Create a Stored Procedure with Conditional Logic
GO
CREATE PROCEDURE sp_GiveBonus
    @DepartmentID INT,
    @BonusAmount DECIMAL(10,2)
AS
BEGIN
    IF @DepartmentID = 3 
    BEGIN
        UPDATE Employees
        SET Salary = Salary + @BonusAmount
        WHERE DepartmentID = @DepartmentID;
    END
END;
GO
EXEC sp_GiveBonus 1, 500.00;

-- Exercise 9: Use Transactions in a Stored Procedure
GO
CREATE PROCEDURE sp_UpdateEmployeeSalaryWithTran
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
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- Exercise 10: Use Dynamic SQL in a Stored Procedure
GO
CREATE PROCEDURE sp_GetEmployeesDynamic
    @FilterColumn VARCHAR(50),
    @FilterValue VARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'SELECT * FROM Employees WHERE ' + QUOTENAME(@FilterColumn) + ' = @Value';
    EXEC sp_executesql @SQL, N'@Value VARCHAR(100)', @Value = @FilterValue;
END;
GO

-- Exercise 11: Handle Errors in a Stored Procedure
GO
CREATE PROCEDURE sp_UpdateEmployeeSalaryWithErrorHandling
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
            RAISERROR('Employee not found.', 16, 1);
            
        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('An error occurred: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
