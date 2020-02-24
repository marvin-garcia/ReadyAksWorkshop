using System.Threading;
using Microsoft.AspNetCore.Mvc;

namespace AspNetCoreApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MathController : ControllerBase
    {
        private int _secondsInterval = 5;

        [HttpGet("add/{a}/{b}")]
        public long Add(long a, long b)
        {
            for (int i = 0; i < b; i++)
            {
                a++;
                Thread.Sleep(_secondsInterval * 1000);
            }

            return a;
        }

        [HttpGet("substract/{a}/{b}")]
        public long Substract(long a, long b)
        {
            for (int i = 0; i < b; i++)
            {
                a--;
                Thread.Sleep(_secondsInterval * 1000);
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
                Thread.Sleep(_secondsInterval * 1000);
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
                Thread.Sleep(_secondsInterval * 1000);
            }

            return result;
        }
    }
}
