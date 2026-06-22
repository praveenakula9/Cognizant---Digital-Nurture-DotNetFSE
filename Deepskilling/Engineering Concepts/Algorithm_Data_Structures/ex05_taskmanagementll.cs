using System;

class Task
{
    public int TaskId;
    public string TaskName;
    public string Status;

    public Task(int id, string name, string status)
    {
        TaskId = id;
        TaskName = name;
        Status = status;
    }
}

class Node
{
    public Task Data;
    public Node Next;

    public Node(Task task)
    {
        Data = task;
        Next = null;
    }
}

class LinkedList
{
    Node head = null;

    public void Add(Task task)
    {
        Node newNode = new Node(task);

        if (head == null)
        {
            head = newNode;
            return;
        }

        Node current = head;

        while (current.Next != null)
        {
            current = current.Next;
        }

        current.Next = newNode;
    }

    public void Display()
    {
        Node current = head;

        while (current != null)
        {
            Console.WriteLine(
                current.Data.TaskId + " " +
                current.Data.TaskName + " " +
                current.Data.Status);

            current = current.Next;
        }
    }

    public void Search(int id)
    {
        Node current = head;

        while (current != null)
        {
            if (current.Data.TaskId == id)
            {
                Console.WriteLine("Task Found:");
                Console.WriteLine(
                    current.Data.TaskId + " " +
                    current.Data.TaskName + " " +
                    current.Data.Status);
                return;
            }

            current = current.Next;
        }

        Console.WriteLine("Task Not Found");
    }

    public void Delete(int id)
    {
        if (head == null)
            return;

        if (head.Data.TaskId == id)
        {
            head = head.Next;
            return;
        }

        Node current = head;

        while (current.Next != null)
        {
            if (current.Next.Data.TaskId == id)
            {
                current.Next = current.Next.Next;
                return;
            }

            current = current.Next;
        }
    }
}

class Program
{
    static void Main()
    {
        LinkedList tasks = new LinkedList();

        tasks.Add(new Task(1, "Design Database", "Pending"));
        tasks.Add(new Task(2, "Build APP", "In Progress"));
        tasks.Add(new Task(3, "Write Tests", "Pending"));

        Console.WriteLine("All Tasks:");
        tasks.Display();

        Console.WriteLine("\nSearch Task 2:");
        tasks.Search(2);

        Console.WriteLine("\nDelete Task 1");
        tasks.Delete(1);

        Console.WriteLine("\nRemaining Tasks:");
        tasks.Display();
    }
}

// Time Complexity Analysis

// Add - O(1)
// Search, Traverse, Delete  - O(n)