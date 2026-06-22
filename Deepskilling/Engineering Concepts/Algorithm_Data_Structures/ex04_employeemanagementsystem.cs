using System;

class Employee
{
    public int EmployeeId;
    public string Name;
    public string Position;
    public double Salary;

    public Employee(int id, string name, string position, double salary)
    {
        EmployeeId = id;
        Name = name;
        Position = position;
        Salary = salary;
    }
}

class Program
{
    static int count = 0;

    static void AddEmployee(Employee[] employees, Employee emp)
    {
        employees[count] = emp;
        count++;
    }

    static Employee SearchEmployee(Employee[] employees, int id)
    {
        for (int i = 0; i < count; i++)
        {
            if (employees[i].EmployeeId == id)
            {
                return employees[i];
            }
        }
        return null;
    }

    static void DeleteEmployee(Employee[] employees, int id)
    {
        for (int i = 0; i < count; i++)
        {
            if (employees[i].EmployeeId == id)
            {
                for (int j = i; j < count - 1; j++)
                {
                    employees[j] = employees[j + 1];
                }

                count--;
                Console.WriteLine("Employee Deleted");
                return;
            }
        }

        Console.WriteLine("Employee Not Found");
    }

    static void Display(Employee[] employees)
    {
        for (int i = 0; i < count; i++)
        {
            Console.WriteLine(
                employees[i].EmployeeId + " " +
                employees[i].Name + " " +
                employees[i].Position + " " +
                employees[i].Salary);
        }
    }

    static void Main()
    {
        Employee[] employees = new Employee[10];

        AddEmployee(employees,
            new Employee(1, "Praveen Kumar", "AI/ML Engineer", 95000));

        AddEmployee(employees,
            new Employee(2, "Krishna", "Product Manager", 78000));

        AddEmployee(employees,
            new Employee(3, "Shiva", "Software Engineer", 72000));

        Console.WriteLine("All Employees:");
        Display(employees);

        Console.WriteLine("\nSearch Employee 2:");

        Employee e = SearchEmployee(employees, 2);

        if (e != null)
        {
            Console.WriteLine(
                e.EmployeeId + " " +
                e.Name + " " +
                e.Position + " " +
                e.Salary);
        }

        Console.WriteLine("\nDeleting Employee 1");
        DeleteEmployee(employees, 1);

        Console.WriteLine("\nRemaining Employees:");
        Display(employees);
    }
}

// Time Complexity Analysis

// Add - O(1)
// Search, Traverse, Delete  - O(n)