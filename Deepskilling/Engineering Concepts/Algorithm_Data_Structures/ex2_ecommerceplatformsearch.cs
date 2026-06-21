using System;

class Product
{
    public int ProductId;
    public string ProductName;
    public string Category;

    public Product(int id, string name, string category)
    {
        ProductId = id;
        ProductName = name;
        Category = category;
    }
}

class Program
{
    static Product LinearSearch(Product[] products, int targetId)
    {
        for (int i = 0; i < products.Length; i++)
        {
            if (products[i].ProductId == targetId)
            {
                return products[i];
            }
        }
        return null;
    }

    static Product BinarySearch(Product[] products, int targetId)
    {
        int low = 0;
        int high = products.Length - 1;

        while (low <= high)
        {
            int mid = (low + high) / 2;

            if (products[mid].ProductId == targetId)
            {
                return products[mid];
            }
            else if (products[mid].ProductId < targetId)
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
        // Sorted array for Binary Search
        Product[] products =
        {
            new Product(102, "Dumbbells", "Fitness"),
            new Product(150, "Running Shoes", "Fitness"),
            new Product(220, "Air Fryer", "Home"),
            new Product(305, "Mobile", "Electronics"),
            new Product(410, "Desk Lamp", "Home")
        };

        int targetId = 150;

        Product linearResult = LinearSearch(products, targetId);

        if (linearResult != null)
        {
            Console.WriteLine("Linear Search Found:");
            Console.WriteLine(linearResult.ProductName);
        }
        else
        {
            Console.WriteLine("Product Not Found");
        }

        Product binaryResult = BinarySearch(products, targetId);

        if (binaryResult != null)
        {
            Console.WriteLine("Binary Search Found:");
            Console.WriteLine(binaryResult.ProductName);
        }
        else
        {
            Console.WriteLine("Product Not Found");
        }
    }
}


// Time Complexity Analysis

// Linear Search - O(n)
// Binary Search - O(logn)