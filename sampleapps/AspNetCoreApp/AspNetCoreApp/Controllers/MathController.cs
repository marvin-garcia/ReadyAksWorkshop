using System;
using System.Threading;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace AspNetCoreApp.Controllers
{
    [Route("[controller]")]
    [ApiController]

    public class MathController : ControllerBase
    {
        private int SecondsInterval { get; set; }

        public MathController(IConfiguration configuration)
        {
            this.SecondsInterval = Convert.ToInt32(configuration["SecondsInterval"]);
        }

        [HttpGet("operations")]
        public string[] GetOperations()
        {
            return new string[]
            {
                "add", "substract", "multiply", "power",
            };
        }

        [HttpGet("add/{a}/{b}")]
        public long Add(long a, long b)
        {
            for (int i = 0; i < b; i++)
            {
                a++;
                
                if (SecondsInterval > 0)
                    Thread.Sleep(SecondsInterval * 1000);
            }

            return a;
        }

        [HttpGet("substract/{a}/{b}")]
        public long Substract(long a, long b)
        {
            for (int i = 0; i < b; i++)
            {
                a--;

                if (SecondsInterval > 0)
                    Thread.Sleep(SecondsInterval * 1000);
            }

            return a;
        }

        [HttpGet("multiply/{a}/{b}")]
        public long Multiply(long a, long b)
        {
            long result = 0;
            for (int i = 0; i < b; i++)
            {
                result += a;

                if (SecondsInterval > 0)
                    Thread.Sleep(SecondsInterval * 1000);
            }

            return result;
        }

        [HttpGet("power/{a}/{b}")]
        public long Powe(long a, long b)
        {
            long result = a;
            for (int i = 0; i < b - 1; i++)
            {
                result *= a;

                if (SecondsInterval > 0)
                    Thread.Sleep(SecondsInterval * 1000);
            }

            return result;
        }
    }
}
