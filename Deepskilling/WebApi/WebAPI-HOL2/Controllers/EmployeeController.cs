using Microsoft.AspNetCore.Mvc;
using WebApiLab2.Models;

namespace WebApiLab2.Controllers
{
    [ApiController]

    [Route("api/[controller]")]

    public class EmployeeController : ControllerBase
    {
        private static List<Employee> employees = new List<Employee>
        {
            new Employee
            {
                Id = 1,
                Name = "John",
                Department = "HR"
            },

            new Employee
            {
                Id = 2,
                Name = "Alice",
                Department = "IT"
            }
        };

        [HttpGet]

        [ProducesResponseType(StatusCodes.Status200OK)]

        public IActionResult GetEmployees()
        {
            return Ok(employees);
        }

        [HttpPost]

        public IActionResult AddEmployee(Employee employee)
        {
            employees.Add(employee);

            return Ok("Employee Added Successfully");
        }
    }
}