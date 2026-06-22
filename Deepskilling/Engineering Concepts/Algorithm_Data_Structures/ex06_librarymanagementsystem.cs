using System;
#nullable disable
class Book
{
    public int BookId;
    public string Title;
    public string Author;

    public Book(int id, string title, string author)
    {
        BookId = id;
        Title = title;
        Author = author;
    }
}

class Program
{
    static Book LinearSearch(Book[] books, string title)
    {
        for (int i = 0; i < books.Length; i++)
        {
            if (books[i].Title == title)
            {
                return books[i];
            }
        }

        return null;
    }

    static Book BinarySearch(Book[] books, string title)
    {
        int low = 0;
        int high = books.Length - 1;

        while (low <= high)
        {
            int mid = (low + high) / 2;

            int result = string.Compare(books[mid].Title, title);

            if (result == 0)
            {
                return books[mid];
            }
            else if (result < 0)
            {
                low = mid + 1;
            }
            else
            {
                high = mid - 1;
            }
        }

        return null;
    }

    static void Main()
    {
        // Sorted by Title for Binary Search
        Book[] books =
        {
            new Book(3,"Pro C# 10 with .NET 6","Andrew Troelsen and Phil Japikse"),
            new Book(1,"C# in Depth","Jon Skeet"),
            new Book(5,"Grokking Algorithms","Aditya Y. Bhargava"),
            new Book(4,"Artificial Intelligence: A Modern Approach (AIMA)","Stuart Russell and Peter Norvig"),
            new Book(2,"Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow","Aurélien Géron")
        };

        string target = "C# in Depth";

        Book linear = LinearSearch(books, target);

        if (linear != null)
        {
            Console.WriteLine("Linear Search Found:");
            Console.WriteLine(linear.Title);
        }

        Array.Sort(books, (a, b) => a.Title.CompareTo(b.Title));
        Book binary = BinarySearch(books, target);

        if (binary != null)
        {
            Console.WriteLine("Binary Search Found:");
            Console.WriteLine(binary.Title);
        }
    }
}


// Time Complexity Analysis

// Linear Search - O(n)
// Binary Search - O(logn)