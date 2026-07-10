-- SQL Exercises - Exception Handling
-- Answers to all exercise questions

-- Clean up existing procedures and tables
IF OBJECT_ID('dbo.AddEmployee', 'P') IS NOT NULL DROP PROCEDURE dbo.AddEmployee;
IF OBJECT_ID('dbo.TransferEmployee', 'P') IS NOT NULL DROP PROCEDURE dbo.TransferEmployee;
IF OBJECT_ID('dbo.BatchInsertEmployees', 'P') IS NOT NULL DROP PROCEDURE dbo.BatchInsertEmployees;
GO

IF OBJECT_ID('dbo.AuditLog', 'U') IS NOT NULL DROP TABLE dbo.AuditLog;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- Create tables
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10, 2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    Action VARCHAR(100),
    ErrorMessage VARCHAR(4000),
    ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- Populate tables with custom names: praveen, kumar, siva, durga
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID) VALUES
(1, 'Praveen', 'Kumar', 'praveen@company.com', 5000.00, 1),
(2, 'Siva', 'Kumar', 'siva@company.com', 6000.00, 2),
(3, 'Durga', 'Prasad', 'durga@company.com', 7000.00, 3);
GO

-- Question 1: Basic TRY...CATCH for Error Logging
-- Question 2: Using THROW to Re-raise Errors
-- Question 3: Custom Error with RAISERROR
-- Question 6: Dynamic RAISERROR with Severity and State
-- We implement a comprehensive AddEmployee stored procedure demonstrating these concepts.
CREATE PROCEDURE AddEmployee
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10,2),
    @DepartmentID INT
AS
BEGIN
    BEGIN TRY
        -- Check for negative salary (severity 16 error, halts execution)
        IF @Salary < 0
        BEGIN
            RAISERROR('Salary cannot be negative.', 16, 1);
        END

        -- Check for zero salary (severity 16 error, halts execution)
        IF @Salary = 0
        BEGIN
            RAISERROR('Salary must be greater than zero.', 16, 1);
        END

        -- Warning for low salary (severity 10 warning, does NOT halt execution or go to CATCH block)
        IF @Salary > 0 AND @Salary < 1000
        BEGIN
            RAISERROR('Warning: Salary is less than $1000.', 10, 1);
        END

        -- Insert statement
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);
        
        PRINT 'Employee added.';
    END TRY
    BEGIN CATCH
        -- Log error to AuditLog
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        INSERT INTO AuditLog (Action, ErrorMessage)
        VALUES ('INSERT Employee ID: ' + CAST(@EmployeeID AS VARCHAR(10)), @ErrorMessage);

        -- Re-raise error to client application using THROW
        THROW;
    END CATCH
END;
GO

-- Test unique constraint failure (siva@company.com already exists)
PRINT '--- Testing duplicate email insertion (should log and throw) ---';
BEGIN TRY
    EXEC AddEmployee 4, 'Kumar', 'Siva', 'siva@company.com', 5500.00, 2;
END TRY
BEGIN CATCH
    PRINT 'Caught Re-thrown Error: ' + ERROR_MESSAGE();
END CATCH;

-- Test negative salary error
PRINT '--- Testing negative salary error ---';
BEGIN TRY
    EXEC AddEmployee 4, 'Kumar', 'Siva', 'kumar.siva@company.com', -500.00, 2;
END TRY
BEGIN CATCH
    PRINT 'Caught Re-thrown Error: ' + ERROR_MESSAGE();
END CATCH;

-- Test warning-level salary insertion (warning displays, insert succeeds)
PRINT '--- Testing warning-level salary insert ---';
EXEC AddEmployee 4, 'Kumar', 'Siva', 'kumar.siva@company.com', 800.00, 2;

-- Check employees
SELECT * FROM Employees WHERE EmployeeID = 4;

-- Check audit logs
SELECT * FROM AuditLog;
GO

-- Question 4: Nested TRY...CATCH with RAISERROR
-- TransferEmployee uses nested try/catch blocks to log and propagate errors.
CREATE PROCEDURE TransferEmployee
    @EmployeeID INT,
    @NewDepartmentID INT
AS
BEGIN
    BEGIN TRY
        -- Inner try/catch block
        BEGIN TRY
            -- Check if department ID is valid
            IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @NewDepartmentID)
            BEGIN
                RAISERROR('Department ID %d does not exist.', 16, 1, @NewDepartmentID);
            END

            -- Update
            UPDATE Employees
            SET DepartmentID = @NewDepartmentID
            WHERE EmployeeID = @EmployeeID;
            
            PRINT 'Department updated in inner block.';
        END TRY
        BEGIN CATCH
            -- Inner catch logs exception, then re-raises
            INSERT INTO AuditLog (Action, ErrorMessage)
            VALUES ('TRANSFER: Inner Exception', ERROR_MESSAGE());
            
            THROW;
        END CATCH
    END TRY
    BEGIN CATCH
        -- Outer catch does final processing and re-raises a custom error
        DECLARE @OuterMsg VARCHAR(4000) = 'Transfer failed for EmployeeID: ' + CAST(@EmployeeID AS VARCHAR(10)) + 
                                          '. Reason: ' + ERROR_MESSAGE();
        
        INSERT INTO AuditLog (Action, ErrorMessage)
        VALUES ('TRANSFER: Outer Exception', @OuterMsg);

        THROW 50001, @OuterMsg, 1;
    END CATCH
END;
GO

-- Test nested exception logic (invalid DepartmentID = 99)
PRINT '--- Testing TransferEmployee with invalid DepartmentID 99 ---';
BEGIN TRY
    EXEC TransferEmployee @EmployeeID = 1, @NewDepartmentID = 99;
END TRY
BEGIN CATCH
    PRINT 'Caught Nested Final Error: ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM AuditLog;
GO

-- Question 5: Logging All Errors in a Transaction
-- BatchInsertEmployees wraps multiple operations and rolls back all if any fail.
CREATE PROCEDURE BatchInsertEmployees
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insert 1: Valid
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (5, 'Durga', 'Kumar', 'durga.k@company.com', 4500.00, 1);

        -- Insert 2: Invalid (Duplicate Email 'praveen@company.com' already exists for Employee 1)
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (6, 'Test', 'User', 'praveen@company.com', 3000.00, 2);

        COMMIT TRANSACTION;
        PRINT 'Batch insert success.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        INSERT INTO AuditLog (Action, ErrorMessage)
        VALUES ('BATCH INSERT Rollback', ERROR_MESSAGE());
        
        THROW;
    END CATCH
END;
GO

-- Test batch transaction rollback
PRINT '--- Testing batch inserts with rollback ---';
BEGIN TRY
    EXEC BatchInsertEmployees;
END TRY
BEGIN CATCH
    PRINT 'Caught Batch Insert Error: ' + ERROR_MESSAGE();
END CATCH;

-- Confirm Employee 5 was NOT inserted due to rollback:
SELECT * FROM Employees WHERE EmployeeID = 5;

-- Confirm logs updated
SELECT * FROM AuditLog;
GO
