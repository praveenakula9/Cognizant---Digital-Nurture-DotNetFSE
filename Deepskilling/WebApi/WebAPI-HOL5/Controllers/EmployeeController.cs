using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WebApiLab5.Models;

namespace WebApiLab5.Controllers
{
    [ApiController]

    [Route("api/[controller]")]

    [Authorize(Roles = "Admin,POC")]

    public class EmployeeController : ControllerBase
    {
        [HttpGet]

        public IActionResult GetEmployees()
        {
            return Ok(new List<Employee>
            {
                new Employee
                {
                    Id = 1,
                    Name = "John",
                    Department = "IT",
                    Salary = 50000
                },

                new Employee
                {
                    Id = 2,
                    Name = "Alice",
                    Department = "HR",
                    Salary = 60000
                }
            });
        }
    }
}