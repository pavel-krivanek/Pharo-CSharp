using PharoUtils;
using System;
using System.Collections;
using System.Linq;
using System.Reflection;

namespace PharoUtils
{
    public static class PharoCollection
    {
        public static T CopyFrom<T>(T aCollection, long from, long to) where T : IEnumerable, new()
        {
            // Adjust for index base difference between Smalltalk (1-based) and C# (0-based)
            long adjustedStartIndex = from - 1;
            long adjustedEndIndex = to - 1;

            // Instantiate a new collection of the same type as the source collection
            dynamic resultCollection = new T();

            // Check for valid range
            if (adjustedStartIndex < 0 || adjustedEndIndex < adjustedStartIndex)
            {
                throw new ArgumentOutOfRangeException("The start or end index is out of bounds.");
            }

            // Use reflection to find the Add method on the result collection
            MethodInfo addMethod = resultCollection.GetType().GetMethod("Add");

            // Ensure the Add method exists
            if (addMethod == null)
            {
                throw new InvalidOperationException("The collection type must have an Add method.");
            }

            // Iterate over the source collection and add elements to the result collection
            int currentIndex = 0;
            foreach (var item in aCollection)
            {
                if (currentIndex >= adjustedStartIndex && currentIndex <= adjustedEndIndex)
                {
                    addMethod.Invoke(resultCollection, new[] { item });
                }
                if (currentIndex > adjustedEndIndex) break;
                currentIndex++;
            }

            return resultCollection;
        }

        public static string CopyFrom(string sourceString, long from, long to)
        {
            // Adjust for index base difference between Smalltalk (1-based) and C# (0-based)
            int adjustedStartIndex = (int)from - 1;
            int adjustedEndIndex = (int)to - 1;

            // Calculate the length of the substring to extract
            int length = adjustedEndIndex - adjustedStartIndex + 1;

            // Check for valid range
            if (adjustedStartIndex < 0 || adjustedEndIndex >= sourceString.Length || length < 0)
            {
                throw new ArgumentOutOfRangeException("The start or end index is out of the string bounds.");
            }

            // Extract the substring based on the adjusted indices
            string result = sourceString.Substring(adjustedStartIndex, length);

            return result;
        }

        public static int SizeOf(string aString)
        {
            return aString.Length;
        }

        public static long SizeOf(APJsonObject apJsonObject)
        {
            return apJsonObject.Size();
        }

        

        public static long SizeOf<T>(IEnumerable<T> collection)
        {
            // Use LINQ's Count() method to count the elements in the collection
            return collection.Count();
        }

        public static bool Includes<T>(this IEnumerable<T> collection, T item)
        {
            return collection.Contains(item);
        }

        public static T Detect<T>(IEnumerable<T> collection, Func<T, bool> itemLike)
        {
            foreach (var item in collection)
            {
                if (itemLike(item))
                {
                    return item; // Item satisfying the predicate found, return it
                }
            }

            // If we reach this point, no item matching the predicate was found
            throw new InvalidOperationException("No item matching the condition was found.");
        }

        public static T Detect<T>(IEnumerable<T> collection, Func<T, bool> itemLike, Func<T> ifNone)
        {
            foreach (var item in collection)
            {
                if (itemLike(item))
                {
                    return item; // Item satisfying the predicate found, return it
                }
            }

            // If we reach this point, no item matching the predicate was found
            return ifNone();
        }

    }
}
