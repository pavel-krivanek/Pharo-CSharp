using System;
using System.Linq;

namespace PharoUtils
{
    public static class PharoDateAndTime
    {
        public static DateAndTime ApplyOffset(long offset, DateAndTime? to /* dateAndTime */)
        {
            // TODO: Fix this when DateAndTime is implemented
            DateAndTime time = to ?? DateAndTime.Now();
            //time.AddSeconds(offset);
            return time;
        }
    }
}
