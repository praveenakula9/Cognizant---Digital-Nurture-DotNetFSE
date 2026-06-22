using System;
#nullable disable
class Student
{
    public string Name;
    public string Id;
    public string Grade;
}

class StudentView
{
    public void Display(Student student)
    {
        Console.WriteLine("Student Details");
        Console.WriteLine("Name  : " + student.Name);
        Console.WriteLine("ID    : " + student.Id);
        Console.WriteLine("Grade : " + student.Grade);
    }
}

class StudentController
{
    private Student student;
    private StudentView view;

    public StudentController(Student student,
                             StudentView view)
    {
        this.student = student;
        this.view = view;
    }

    public void SetGrade(string grade)
    {
        student.Grade = grade;
    }

    public void UpdateView()
    {
        view.Display(student);
    }
}

class Program
{
    static void Main()
    {
        Student student = new Student();

        student.Name = "Praveen Kumar";
        student.Id = "101";
        student.Grade = "B+";

        StudentView view = new StudentView();

        StudentController controller =
            new StudentController(student, view);

        Console.WriteLine("Initial Record");
        controller.UpdateView();

        Console.WriteLine();

        controller.SetGrade("A");

        Console.WriteLine("Updated Record");
        controller.UpdateView();
    }
}