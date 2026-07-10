-- Database Schema
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

-- Sample Data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'), (2, 'Finance'), (3, 'IT'), (4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 5000.00, 1),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 6000.00, 2);

-- Question 1: Basic TRY...CATCH for Error Logging
-- Question 2: Using THROW to Re-raise Errors
-- Question 3: Custom Error with RAISERROR
-- Question 6: Dynamic RAISERROR with Severity and State
GO
CREATE PROCEDURE AddEmployee (
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10, 2),
    @DepartmentID INT
)
AS
BEGIN
    BEGIN TRY
        -- Q3: RAISERROR for custom business rule
        IF @Salary <= 0
        BEGIN
            RAISERROR('Salary must be greater than zero.', 16, 1);
        END
        
        -- Q6: Dynamic RAISERROR based on different conditions
        IF @Salary < 1000 AND @Salary > 0
        BEGIN
            RAISERROR('Warning: Salary is very low.', 10, 1); -- Severity 10 is just a warning
        END
        
        -- Q1: Try to insert
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);
    END TRY
    BEGIN CATCH
        -- Q1: Log the error
        INSERT INTO AuditLog (Action, ErrorMessage)
        VALUES ('AddEmployee', ERROR_MESSAGE());
        
        -- Q2: Use THROW to re-raise
        THROW;
    END CATCH
END;
GO

-- Question 4: Nested TRY...CATCH with RAISERROR
GO
CREATE PROCEDURE TransferEmployee (
    @EmployeeID INT,
    @NewDepartmentID INT
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @NewDepartmentID)
        BEGIN
            RAISERROR('Department does not exist.', 16, 1);
        END
        
        UPDATE Employees
        SET DepartmentID = @NewDepartmentID
        WHERE EmployeeID = @EmployeeID;
    END TRY
    BEGIN CATCH
        BEGIN TRY
            INSERT INTO AuditLog (Action, ErrorMessage)
            VALUES ('TransferEmployee', ERROR_MESSAGE());
        END TRY
        BEGIN CATCH
            -- In case logging fails
            PRINT 'Failed to log error.';
        END CATCH
        
        THROW;
    END CATCH
END;
GO

-- Question 5: Logging All Errors in a Transaction
GO
CREATE TYPE EmployeeTableType AS TABLE (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Salary DECIMAL(10, 2),
    DepartmentID INT
);
GO
CREATE PROCEDURE BatchInsertEmployees (
    @Employees EmployeeTableType READONLY
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        SELECT EmployeeID, FirstName, LastName, Email, Salary, DepartmentID
        FROM @Employees;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        INSERT INTO AuditLog (Action, ErrorMessage)
        VALUES ('BatchInsertEmployees', ERROR_MESSAGE());
        
        THROW;
    END CATCH
END;
GO
