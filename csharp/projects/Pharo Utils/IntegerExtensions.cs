namespace PharoUtils
{
    public static class IntegerExtensions
    {
        public static long Max(this long first, long other)
        {
            return (first > other) ? first : other;
        }

        public static long Min(this long first, long other)
        {
             return (first < other) ? first : other;
        }

        public static bool Between(this long number, long from, long and)
        {
            return number >= from && number <= and;
        }

        public static List<long> To(this long start, long to)
        {
            // only for small intervals!
            var list = new List<long>();

            if (to < start)
                return list;

            for (long i = start; i <= to; i++)
            {
                list.Add(i);
            }

            return list;
        }

        public static long PrintOn(this long number, WriteStream writeStream)
        {
            writeStream.NextPutAll(number.ToString());
            return number;
        }

        public static void TimesRepeat(this long times, Action action)
        {
            if (action == null)
                throw new ArgumentNullException(nameof(action), "Action cannot be null.");

            for (int i = 0; i < (int)times; i++)
            {
                action();
            }
        }

    }
}
