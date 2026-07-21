using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace WebApiLab3.Filters
{
    public class CustomExceptionFilter : IExceptionFilter
    {
        public void OnException(ExceptionContext context)
        {
            File.WriteAllText(
                "ErrorLog.txt",
                context.Exception.ToString());

            context.Result =
                new ObjectResult("Internal Server Error")
                {
                    StatusCode = 500
                };
        }
    }
}