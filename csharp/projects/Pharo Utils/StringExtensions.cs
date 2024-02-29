using System;
using System.Reflection;

namespace PharoUtils
{
    public static class StringExtensionMethods
    {
        public static string Copy(this string source)
        {
            // Since strings are immutable, returning the original string is essentially a "copy"
            // But for demonstration, explicitly create a new string with the same content
            return new string(source);
        }

        public static string Format(this string format, List<string> args)
        {
            if (args == null) throw new ArgumentNullException(nameof(args));

            args.Insert(0, "");

            // Convert List<string> to an array because String.Format expects an array of objects
            object[] argsArray = args.ToArray();

            return string.Format(format, argsArray);
        }

        public static string AllButLast(this string source)
        {
            // Check if the string is null, empty, or consists of a single character.
            if (string.IsNullOrEmpty(source) || source.Length <= 1)
            {
                return string.Empty;
            }

            // Return the substring excluding the last character.
            return source.Substring(0, source.Length - 1);
        }

        public static long? AsInteger(this string str)
        {
            if (int.TryParse(str, out int result))
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        public static char At(this string str, long index)
        {
            // Adjust index for 0-based indexing as Smalltalk uses 1-based indexing
            int adjustedIndex = (int)index - 1;

            // Check if the index is within the bounds of the string
            if (adjustedIndex >= 0 && adjustedIndex < str.Length)
            {
                return str[adjustedIndex];
            }
            else
            {
                throw new ArgumentOutOfRangeException(nameof(index), "Index is out of range.");
            }
        }

        public static char First(this string str)
        {
           return str.At(1);
        }

        public static char Second(this string str)
        {
            return str.At(2);
        }

        public static char Third(this string str)
        {
            return str.At(3);
        }

        public static char Fourth(this string str)
        {
            return str.At(4);
        }

        public static bool BeginsWith(this string source, string anotherString)
        {
            return source.StartsWith(anotherString);
        }

        public static string AsUppercase(this string input)
        {
            // Check if the input is null to avoid NullReferenceException
            if (input == null)
            {
                throw new ArgumentNullException(nameof(input), "Input string cannot be null.");
            }

            return input.ToUpper();
        }

        public static bool IsAllDigits(this string input)
        {
            // Check if the input is null or an empty string
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }

            // Check each character to see if it is not a digit
            foreach (char c in input)
            {
                if (!char.IsDigit(c))
                {
                    return false; // Return false if any character is not a digit
                }
            }

            // All characters are digits
            return true;
        }

        public static List<string> FindTokens(this string source, params char[] delimiters)
        {
            // Use String.Split to split the string into an array based on the delimiters
            string[] tokens = source.Split(delimiters, StringSplitOptions.RemoveEmptyEntries);

            // Convert the array to a List<string> and return it
            return new List<string>(tokens);
        }

        public static List<string> FindTokens(this string source, string delimiters)
        {
            // Convert the string of delimiters into a character array
            char[] delimiterChars = delimiters.ToCharArray();

            // Use String.Split to split the string into an array based on the character array of delimiters
            string[] tokens = source.Split(delimiterChars, StringSplitOptions.RemoveEmptyEntries);

            // Convert the array to a List<string> and return it
            return new List<string>(tokens);
        }

        public static bool NotEmpty(this string value)
        {
            return !string.IsNullOrEmpty(value);
        }

        public static FileReference AsFileReference(this string path)
        {
            return new FileReference(path);
        }

    }

}
