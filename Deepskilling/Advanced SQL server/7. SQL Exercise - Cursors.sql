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
(3, 'Bob', 'Johnson', 3, 5500.00, '2021-07-30');

-- Exercise 1: Create a Cursor
GO
DECLARE @EmpID INT, @FirstName VARCHAR(50), @LastName VARCHAR(50), @DeptID INT, @Salary DECIMAL(10,2), @JoinDate DATE;
DECLARE emp_cursor CURSOR FOR 
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate 
FROM Employees;

OPEN emp_cursor;
FETCH NEXT FROM emp_cursor INTO @EmpID, @FirstName, @LastName, @DeptID, @Salary, @JoinDate;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Employee: ' + CAST(@EmpID AS VARCHAR) + ' - ' + @FirstName + ' ' + @LastName + ' | Salary: ' + CAST(@Salary AS VARCHAR);
    FETCH NEXT FROM emp_cursor INTO @EmpID, @FirstName, @LastName, @DeptID, @Salary, @JoinDate;
END

CLOSE emp_cursor;
DEALLOCATE emp_cursor;
GO

-- Exercise 2: Types of Cursors
GO
-- 1. Static cursor
DECLARE static_cursor CURSOR STATIC FOR SELECT * FROM Employees;
-- 2. Dynamic cursor
DECLARE dynamic_cursor CURSOR DYNAMIC FOR SELECT * FROM Employees;
-- 3. Forward-only cursor
DECLARE forward_only_cursor CURSOR FORWARD_ONLY FOR SELECT * FROM Employees;
-- 4. Keyset-driven cursor
DECLARE keyset_cursor CURSOR KEYSET FOR SELECT * FROM Employees;

-- Clean up
DEALLOCATE static_cursor;
DEALLOCATE dynamic_cursor;
DEALLOCATE forward_only_cursor;
DEALLOCATE keyset_cursor;
GO
