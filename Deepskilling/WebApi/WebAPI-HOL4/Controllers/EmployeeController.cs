using Microsoft.AspNetCore.Mvc;
using WebApiLab4.Models;

namespace WebApiLab4.Controllers
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
                Department = "HR",
                Salary = 50000
            },

            new Employee
            {
                Id = 2,
                Name = "Alice",
                Department = "IT",
                Salary = 60000
            }
        };

        [HttpGet]

        public ActionResult<List<Employee>> Get()
        {
            return Ok(employees);
        }

        [HttpPut("{id}")]

        public ActionResult<Employee> UpdateEmployee(
            int id,
            [FromBody] Employee employee)
        {
            if (id <= 0)
            {
                return BadRequest("Invalid employee id");
            }

            var existing =
                employees.FirstOrDefault(e => e.Id == id);

            if (existing == null)
            {
                return BadRequest("Invalid employee id");
            }

            existing.Name = employee.Name;
            existing.Department = employee.Department;
            existing.Salary = employee.Salary;

            return Ok(existing);
        }
    }
}