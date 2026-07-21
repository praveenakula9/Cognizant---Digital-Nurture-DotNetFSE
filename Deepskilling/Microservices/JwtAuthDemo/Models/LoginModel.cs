namespace JwtAuthDemo.Models
{
    // This is the shape of the JSON body the client sends to /api/auth/login
    public class LoginModel
    {
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
