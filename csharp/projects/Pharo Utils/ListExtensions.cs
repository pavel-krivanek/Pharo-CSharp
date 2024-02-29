using System;
using System.Collections.Generic;
using System.Linq;

namespace PharoUtils
{
    public static class ListExtensions
    {
        public static T? AnyOne<T>(this List<T?> list) 
        {
            if (list == null || list.Count == 0)
            {
                return default(T?);
            }
            return list[0]; // Return the first element
        }

        public static bool IsEmpty<T>(this List<T> list) 
        {
            return list.Count == 0;
        }

        public static bool NotEmpty<T>(this List<T> list) 
        {
            return list.Count != 0;
        }

        public static void AddFirst<T>(this List<T> list, T item)
        {
            // Inserts the item at the beginning of the list
            list.Insert(0, item);
        }

        public static T? Remove<T>(this List<T> list, T item, Func<T?> ifAbsent)
        {
            bool isRemoved = list.Remove(item);

            // If the item was successfully removed, return default(T?) which can be null for reference and nullable value types.
            if (isRemoved)
            {
                return default;
            }
            else
            {
                // If the item was not found, return the value provided by ifAbsent.
                return ifAbsent();
            }
        }

        public static List<T> AddAll<T>(this List<T> list, List<T> collection)
        {
            if (collection == null)
            {
                throw new ArgumentNullException(nameof(collection), "The collection to add cannot be null.");
            }

            foreach (var item in collection)
            {
                list.Add(item);
            }

            return collection; // Return the added collection
        }

        public static T At<T>(this List<T> list, long index, T put /* aValue */)
        {
            // Adjust index for 0-based indexing as Smalltalk uses 1-based indexing
            int adjustedIndex = (int)index - 1;

            // Check if the index is within the bounds of the list
            if (adjustedIndex >= 0 && adjustedIndex < list.Count)
            {
                list[adjustedIndex] = put;
                return put;
            }
            else
            {
                throw new ArgumentOutOfRangeException(nameof(index), "Index is out of range.");
            }
        }

        public static T At<T>(this List<T> list, long index)
        {
            // Adjust index for 0-based indexing as Smalltalk uses 1-based indexing
            int adjustedIndex = (int)index - 1;

            // Check if the index is within the bounds of the list
            if (adjustedIndex >= 0 && adjustedIndex < list.Count)
            {
                return list[adjustedIndex];
            }
            else
            {
                throw new ArgumentOutOfRangeException(nameof(index), "Index is out of range.");
            }
        }

        public static T _RemoveAt<T>(this List<T> list, long index)
        {
            T removed = list.At(index);
            list.RemoveAt((int)index - 1);
            return removed;
        }

        public static List<T> Sorted<T>(this List<T> list) where T : IComparable<T>
        {
            return list.OrderBy(item => item).ToList();
        }

        public static List<T> AsOrderedCollection<T>(this List<T> list)
        {
            return list;
        }

        public static long _IndexOf<T>(this List<T?> list, T? item)
        {
            for (long i = 0; i < list.Count; i++)
            {
                if ((list[(int)i] == null && item == null) || (list[(int)i]?.Equals(item) == true))
                {
                    return i + 1; // Return 1-based index
                }
            }
            return 0; // Item not found, return 0
        }

        public static bool AllSatisfy<T>(this List<T> list, Func<T, bool> predicate)
        {
            foreach (var item in list)
            {
                if (!predicate(item))
                {
                    return false;
                }
            }
            return true;
        }

        public static bool AnySatisfy<T>(this List<T> list, Func<T, bool> predicate)
        {
            foreach (var item in list)
            {
                if (predicate(item))
                {
                    return true; // If any item satisfies the predicate, return true immediately
                }
            }
            return false; // If no items satisfy the predicate, return false
        }

        public static List<T> Reversed<T>(this List<T> source)
        {
            var reversedList = new List<T>(source); 
            reversedList.Reverse(); 
            return reversedList; 
        }

        public static T AddIfNotPresent<T>(this List<T> list, T item)
        {
            if (!list.Contains(item))
            {
                list.Add(item);
                return item; // Item was added
            }

            return item; // Item was not added because it was already present
        }

        public static List<T> RemoveDuplicates<T>(this List<T> list)
        {
            var uniqueItems = new HashSet<T>();
            int index = 0;
            while (index < list.Count)
            {
                if (!uniqueItems.Add(list[index]))
                {
                    list.RemoveAt(index);
                }
                else
                {
                    index++;
                }
            }
            return list;
        }
    }
}
