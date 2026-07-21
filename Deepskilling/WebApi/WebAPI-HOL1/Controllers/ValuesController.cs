using Microsoft.AspNetCore.Mvc;

namespace FirstWebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ValuesController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new string[]
        {
            "Value 1",
            "Value 2",
            "Value 3"
        });
    }

    [HttpGet("{id}")]
    public IActionResult Get(int id)
    {
        return Ok($"Value = {id}");
    }

    [HttpPost]
    public IActionResult Post([FromBody] string value)
    {
        return Ok("Value Added Successfully");
    }

    [HttpPut("{id}")]
    public IActionResult Put(int id, [FromBody] string value)
    {
        return Ok($"Value {id} Updated");
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        return Ok($"Value {id} Deleted");
    }
}