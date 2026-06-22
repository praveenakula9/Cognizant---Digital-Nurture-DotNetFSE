using System;
using System.Collections.Generic;

class Product
{
    public int ProductId;
    public string ProductName;
    public int Quantity;
    public double Price;

    public Product(int id, string name, int qty, double price)
    {
        ProductId = id;
        ProductName = name;
        Quantity = qty;
        Price = price;
    }
}

class Program
{
    static void Main(string[] args)
    {
        List<Product> inventory = new List<Product>();

        // Add Products
        inventory.Add(new Product(101, "Wireless Mouse", 50, 19.99));
        inventory.Add(new Product(102, "Mechanical Keyboard", 30, 49.99));
        inventory.Add(new Product(103, "USB-C Hub", 80, 24.50));

        Console.WriteLine("Initial Inventory:");
        DisplayProducts(inventory);

        // Update Product 102
        foreach (Product p in inventory)
        {
            if (p.ProductId == 102)
            {
                p.Quantity = 25;
                p.Price = 44.99;
            }
        }

        // Delete Product 101 
        for (int i = 0; i < inventory.Count; i++)
        {
            if (inventory[i].ProductId == 101)
            {
                inventory.RemoveAt(i);
                break;
            }
        }

        Console.WriteLine("\nFinal Inventory:");
        DisplayProducts(inventory);
    }

    static void DisplayProducts(List<Product> inventory)
    {
        foreach (Product p in inventory)
        {
            Console.WriteLine(
                "ID: " + p.ProductId +
                ", Name: " + p.ProductName +
                ", Quantity: " + p.Quantity +
                ", Price: $" + p.Price
            );
        }
    }
}


// Time Complexity Analysis

// Add - O(1)
// Update, Delete, Search, Display - O(n)