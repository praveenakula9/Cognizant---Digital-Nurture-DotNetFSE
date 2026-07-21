using Microsoft.AspNetCore.Mvc;
using WebApiLab3.Models;
using WebApiLab3.Filters;

namespace WebApiLab3.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [CustomAuthFilter]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]

        [ProducesResponseType(StatusCodes.Status200OK)]

        [ProducesResponseType(StatusCodes.Status500InternalServerError)]

        public ActionResult<List<Employee>> GetStandard()
        {
            return GetStandardEmployeeList();
        }

        [HttpPost]

        public IActionResult Post([FromBody] Employee employee)
        {
            return Ok(employee);
        }

        private List<Employee> GetStandardEmployeeList()
        {
            return new List<Employee>()
            {
                new Employee
                {
                    Id = 1,
                    Name = "John",
                    Salary = 50000,
                    Permanent = true,
                    Department = new Department
                    {
                        Id = 1,
                        Name = "IT"
                    },
                    Skills = new List<Skill>
                    {
                        new Skill{Id=1,Name="C#"},
                        new Skill{Id=2,Name="SQL"}
                    },
                    DateOfBirth = new DateTime(1998,5,10)
                }
            };
        }
    }
}