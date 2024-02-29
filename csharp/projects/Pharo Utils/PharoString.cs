using System;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;

namespace PharoUtils
{

    public static class StringExtensions
    {
        // Extension method for the string class.
        public static string AsSymbol(this string str)
        {
            return str; // Simply returns the original string.
        }
    }

    public static class PharoString
    {
        public static string StreamContents(Action<WriteStream> action)
        {
            WriteStream aStream = new WriteStream();
            action(aStream);
            return aStream.Contents();
        }

        public static bool Match(string pattern, string to)
        {
            // we need to check compatibility 
            return Regex.IsMatch(to, pattern);
        }
    }
}
