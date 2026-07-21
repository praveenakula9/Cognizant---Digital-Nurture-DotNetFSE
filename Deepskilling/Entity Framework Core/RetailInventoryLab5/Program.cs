using Microsoft.EntityFrameworkCore;
using RetailInventoryLab3Project.Data;

using var context = new AppDbContext();

Console.WriteLine("----- All Products -----");

var products = await context.Products.ToListAsync();

foreach (var p in products)
{
    Console.WriteLine($"{p.Name} - ₹{p.Price}");
}

Console.WriteLine();

Console.WriteLine("----- Find Product by ID -----");

var product = await context.Products.FindAsync(1);

Console.WriteLine($"Found: {product?.Name}");

Console.WriteLine();

Console.WriteLine("----- Expensive Product -----");

var expensive = await context.Products
    .FirstOrDefaultAsync(p => p.Price > 50000);

Console.WriteLine($"Expensive: {expensive?.Name}");