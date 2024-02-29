using System;
using System.Linq;

namespace PharoUtils
{
    public static class PharoNumber
    {
        public static long Max(this long first, long other)
        {
            return (first > other) ? first : other;
        }

        public static void From(int from, int to, Action<int> @do)
        {
            if (from <= to)
            {
                for (int i = from; i <= to; i++)
                {
                    @do(i);
                }
            }
            else
            {
                throw new ArgumentException("'from' should be less than or equal to 'to'");
            }
        }
    }
}
