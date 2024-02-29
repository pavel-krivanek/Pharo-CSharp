
namespace PharoUtils
{
    public class DateAndTime
    {
        protected DateTimeOffset dateTime { get; set; }

        public static int? FromString(string aString)
        {
            // Stub
            return 0;
        }

        public static DateAndTime Now()
        {
            var newInstance = new DateAndTime();
            newInstance.dateTime = DateTimeOffset.Now;
            return newInstance;
        }

        public static DateAndTime NowUTC()
        {
            // Stub
            return new DateAndTime();
        }

        public long Year()
        {
            return 2024;
        }    

        public string JsonString()
        {
            string iso8601WithTimeZone = dateTime.ToString("yyyy-MM-ddTHH:mm:ss.fffffffK");
            return iso8601WithTimeZone;
        }
    }

    public class Date
    {
        public static DateAndTime Today()
        {
            // Stub
            return new DateAndTime();
        }

    }
}
