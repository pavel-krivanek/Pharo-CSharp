using System;
using System.Linq;

namespace PharoUtils
{
    public static class PharoObject
    {
        public static bool IsInteger(object anObject)
        {
            return anObject is long;
        }

        public static bool IsNil(this object obj)
        {
            return obj == null;
        }

        public static bool NotNil(this object obj)
        {
            return obj != null;
        }
    }
}
