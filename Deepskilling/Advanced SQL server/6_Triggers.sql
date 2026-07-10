-- SQL Exercises - Triggers
-- Answers to all exercise questions

-- Clean up logon triggers, table triggers, and tables
IF EXISTS (SELECT * FROM sys.server_triggers WHERE name = 'trg_LogonMaintenance')
    DROP TRIGGER trg_LogonMaintenance ON ALL SERVER;
GO

IF OBJECT_ID('dbo.trg_LogSalaryChanges', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_LogSalaryChanges;
IF OBJECT_ID('dbo.trg_PreventDelete', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_PreventDelete;
IF OBJECT_ID('dbo.trg_UpdateAnnualSalary', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_UpdateAnnualSalary;
GO

IF OBJECT_ID('dbo.EmployeeChanges', 'U') IS NOT NULL DROP TABLE dbo.EmployeeChanges;
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
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'Praveen', 'Kumar', 1, 5000.00, '2022-01-15'),
(2, 'Siva', 'Kumar', 2, 6000.00, '2021-03-22'),
(3, 'Durga', 'Prasad', 3, 7000.00, '2020-07-30'),
(4, 'Kumar', 'Siva', 4, 5500.00, '2019-11-05');
GO

-- Exercise 1: Create an After Trigger

-- Create table to hold salary changes
CREATE TABLE EmployeeChanges (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO

-- Create trigger to log salary updates
CREATE TRIGGER trg_LogSalaryChanges
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO EmployeeChanges (EmployeeID, OldSalary, NewSalary)
        SELECT 
            i.EmployeeID,
            d.Salary AS OldSalary,
            i.Salary AS NewSalary
        FROM inserted i
        JOIN deleted d ON i.EmployeeID = d.EmployeeID
        WHERE i.Salary <> d.Salary;
    END
END;
GO

-- Test updates (Durga Prasad)
UPDATE Employees
SET Salary = 7500.00
WHERE EmployeeID = 3;

-- Check changes table
SELECT * FROM EmployeeChanges;
GO

-- Exercise 2: Create an Instead of Trigger
-- Prevents deletions on Employees table directly
CREATE TRIGGER trg_PreventDelete
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deletions are not allowed on the Employees table directly.', 16, 1);
END;
GO

-- Test deleting employee
BEGIN TRY
    DELETE FROM Employees WHERE EmployeeID = 1;
END TRY
BEGIN CATCH
    PRINT 'Delete blocked: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Exercise 3: Create a Logon Trigger
-- Restricts server-wide logins during maintenance hours (e.g. 2 AM to 3 AM)
CREATE TRIGGER trg_LogonMaintenance
ON ALL SERVER
FOR LOGON
AS
BEGIN
    DECLARE @CurrentHour INT = DATEPART(HOUR, GETDATE());
    IF @CurrentHour = 2
    BEGIN
        ROLLBACK; -- Denies logon attempt
    END
END;
GO

-- Note: We disable it immediately to avoid locking ourselves out during local development.
DISABLE TRIGGER trg_LogonMaintenance ON ALL SERVER;
PRINT 'Logon trigger created and disabled for safety.';
GO

-- Exercise 4: Modify a Trigger using SSMS
-- (Simulated using ALTER TRIGGER SQL statements)
ALTER TRIGGER trg_PreventDelete
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @EmpName VARCHAR(100);
    SELECT @EmpName = FirstName + ' ' + LastName FROM deleted;
    
    DECLARE @ErrMsg VARCHAR(250) = 'Cannot delete employee ' + ISNULL(@EmpName, '') + '. Action blocked.';
    RAISERROR (@ErrMsg, 16, 1);
END;
GO

-- Test modified trigger
BEGIN TRY
    DELETE FROM Employees WHERE EmployeeID = 1;
END TRY
BEGIN CATCH
    PRINT 'Modified delete blocked: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Exercise 5: Delete a Trigger
-- Drop the prevent delete trigger
DROP TRIGGER dbo.trg_PreventDelete;
PRINT 'Trigger dropped.';
GO

-- Exercise 6: Create a Trigger to Update a Computed Column
-- Automatically updates AnnualSalary column when Salary is inserted or updated

-- Add AnnualSalary column
ALTER TABLE Employees ADD AnnualSalary DECIMAL(10,2);
GO

-- Create trigger
CREATE TRIGGER trg_UpdateAnnualSalary
ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        UPDATE Employees
        SET AnnualSalary = Salary * 12
        FROM Employees e
        JOIN inserted i ON e.EmployeeID = i.EmployeeID;
    END
END;
GO

-- Test update on Praveen (EmployeeID = 1)
UPDATE Employees SET Salary = 5500.00 WHERE EmployeeID = 1;

-- Test insert (new employee Durga Kumar)
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate)
VALUES (5, 'Durga', 'Kumar', 3, 4000.00, '2023-05-10');

-- Query to verify calculations
SELECT EmployeeID, FirstName, Salary, AnnualSalary FROM Employees WHERE EmployeeID IN (1, 5);
GO
