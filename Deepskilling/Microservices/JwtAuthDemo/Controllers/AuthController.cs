using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using JwtAuthDemo.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace JwtAuthDemo.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;

        public AuthController(IConfiguration config)
        {
            _config = config;
        }

        // POST api/auth/login
        // Body: { "username": "admin", "password": "admin123" }
        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel model)
        {
            if (!IsValidUser(model))
            {
                return Unauthorized(new { message = "Invalid username or password." });
            }

            var token = GenerateJwtToken(model.Username);
            return Ok(new { Token = token });
        }

        // Very simple hard-coded "database" just for this demo.
        // In a real project this would check a real users table with hashed passwords.
        private bool IsValidUser(LoginModel model)
        {
            if (model.Username == "admin" && model.Password == "admin123") return true;
            if (model.Username == "user" && model.Password == "user123") return true;
            return false;
        }

        private string GenerateJwtToken(string username)
        {
            // Exercise 3: give the "admin" user the Admin role claim,
            // everyone else just gets a normal user claim.
            var role = username == "admin" ? "Admin" : "User";

            var claims = new[]
            {
                new Claim(ClaimTypes.Name, username),
                new Claim(ClaimTypes.Role, role)
            };

            var jwtKey = _config["Jwt:Key"]!;
            var jwtIssuer = _config["Jwt:Issuer"]!;
            var jwtAudience = _config["Jwt:Audience"]!;
            var durationMinutes = double.Parse(_config["Jwt:DurationInMinutes"] ?? "60");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: jwtIssuer,
                audience: jwtAudience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(durationMinutes),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
