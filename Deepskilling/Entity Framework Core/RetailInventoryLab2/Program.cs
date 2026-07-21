using RetailInventory.Data;

Console.WriteLine("Retail Inventory System");

using var db = new AppDbContext();

db.Database.EnsureCreated();

Console.WriteLine("Database Connected Successfully!");