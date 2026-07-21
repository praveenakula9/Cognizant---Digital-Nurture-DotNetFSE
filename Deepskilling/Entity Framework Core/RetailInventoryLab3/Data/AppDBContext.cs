using Microsoft.EntityFrameworkCore;
using RetailInventoryLab3.Models;

namespace RetailInventoryLab3.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; }

        public DbSet<Category> Categories { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(
                "Server=.;Database=RetailInventoryDB;Trusted_Connection=True;");
        }
    }
}