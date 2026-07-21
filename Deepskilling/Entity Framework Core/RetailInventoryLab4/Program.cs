using RetailInventoryLab3Project.Data;
using RetailInventoryLab3Project.Models;

using var context = new AppDbContext();

// Create Categories
var electronics = new Category
{
    Name = "Electronics"
};

var groceries = new Category
{
    Name = "Groceries"
};

// Insert Categories
await context.Categories.AddRangeAsync(electronics, groceries);

// Create Products
var product1 = new Product
{
    Name = "Laptop",
    Price = 75000,
    Category = electronics
};

var product2 = new Product
{
    Name = "Rice Bag",
    Price = 1200,
    Category = groceries
};

// Insert Products
await context.Products.AddRangeAsync(product1, product2);

// Save Changes
await context.SaveChangesAsync();

Console.WriteLine("Data Inserted Successfully!");