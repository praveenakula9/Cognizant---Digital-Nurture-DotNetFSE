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
    JoinDate DATE,
    AnnualSalary DECIMAL(10, 2) -- Added for Exercise 6
);

CREATE TABLE EmployeeChanges (
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10, 2),
    NewSalary DECIMAL(10, 2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- Sample Data
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'), (2, 'Finance'), (3, 'IT'), (4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2022-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2021-03-22'),
(3, 'Michael', 'Johnson', 3, 7000.00, '2020-07-30'),
(4, 'Emily', 'Davis', 4, 5500.00, '2019-11-05');

-- Exercise 1: Create an After Trigger
GO
CREATE TRIGGER trg_AfterUpdateSalary
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO EmployeeChanges (EmployeeID, OldSalary, NewSalary)
        SELECT i.EmployeeID, d.Salary, i.Salary
        FROM inserted i
        JOIN deleted d ON i.EmployeeID = d.EmployeeID
        WHERE i.Salary <> d.Salary;
    END
END;
GO

-- Exercise 2: Create an Instead of Trigger
GO
CREATE TRIGGER trg_InsteadOfDeleteEmployee
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Deletions from the Employees table are not allowed.', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

-- Exercise 3: Create a Logon Trigger
-- Note: Logon triggers require server-level permissions
GO
-- CREATE TRIGGER trg_LogonMaintenance
-- ON ALL SERVER FOR LOGON
-- AS
-- BEGIN
--     DECLARE @CurrentHour INT = DATEPART(HOUR, GETDATE());
--     IF @CurrentHour >= 2 AND @CurrentHour < 3
--     BEGIN
--         ROLLBACK;
--     END
-- END;
GO

-- Exercise 4: Modify a Trigger using SSMS
GO
ALTER TRIGGER trg_AfterUpdateSalary
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO EmployeeChanges (EmployeeID, OldSalary, NewSalary)
        SELECT i.EmployeeID, d.Salary, i.Salary
        FROM inserted i
        JOIN deleted d ON i.EmployeeID = d.EmployeeID;
    END
END;
GO

-- Exercise 5: Delete a Trigger
-- DROP TRIGGER trg_AfterUpdateSalary;

-- Exercise 6: Create a Trigger to Update a Computed Column
GO
CREATE TRIGGER trg_UpdateAnnualSalary
ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(Salary) OR EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE e
        SET e.AnnualSalary = e.Salary * 12
        FROM Employees e
        JOIN inserted i ON e.EmployeeID = i.EmployeeID;
    END
END;
GO
