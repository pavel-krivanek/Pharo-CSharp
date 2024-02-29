using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;

namespace PharoUtils
{
    public static class DictionaryExtensions
    {
        public static TValue At<TKey, TValue>(this Dictionary<TKey?, TValue> dictionary, TKey key)
        {
            if (dictionary.TryGetValue(key, out TValue value))
            {
                return value;
            }
            else
            {
                throw new KeyNotFoundException($"The given key '{key}' was not present in the dictionary.");
            }
        }

        public static TValue? AtOrNil<TKey, TValue>(this Dictionary<TKey, TValue?> dictionary, TKey key)
        {
            return dictionary.TryGetValue(key, out TValue value) ? value : default(TValue?);
        }
     

        public static TValue At<TKey, TValue>(this Dictionary<TKey, TValue> dictionary, TKey key, Func<TValue> ifAbsent)
        {
            // Check if the dictionary contains the key
            if (dictionary.TryGetValue(key, out TValue value))
            {
                return value;
            }
            else
            {
                // If the key is not found, invoke the ifAbsent function to get a default value
                return ifAbsent();
            }
        }

        public static TReturn? At<TKey, TValue, TReturn>(
            this Dictionary<TKey, TValue> dictionary,
            TKey key,
            Func<TValue, TReturn?> ifPresent,
            Func<TReturn?> ifAbsent = null) // ifAbsent is optional and can be null
            where TValue : class
            where TReturn : class
        {
            if (dictionary.TryGetValue(key, out TValue value))
            {
                return ifPresent(value);
            }
            else if (ifAbsent != null)
            {
                return ifAbsent();
            }
            return default;
        }

         public static List<TValue> Values<TKey, TValue>(this Dictionary<TKey, TValue> dictionary)
        {
            return dictionary.Values.ToList();
        }

        public static List<TKey> Keys<TKey, TValue>(this Dictionary<TKey, TValue> dictionary)
        {
            return dictionary.Keys.ToList();
        }

        public static TValue? _At<TKey, TValue>(this Dictionary<TKey, TValue?> dictionary, TKey key, Func<TValue?> ifAbsentPut)
            where TKey : notnull
        {
            // Check if the dictionary contains the key
            if (!dictionary.TryGetValue(key, out TValue? value))
            {
                // If the key is not found, invoke the ifAbsentPut function to get a value
                value = ifAbsentPut();
                // Insert the computed value into the dictionary
                dictionary[key] = value;
            }

            return value;
        }

        public static TValue At<TKey, TValue>(this Dictionary<TKey, TValue> dictionary, TKey key, TValue put)
        {
            if (dictionary == null) throw new ArgumentNullException(nameof(dictionary));
            dictionary[key] = put;
            return dictionary[key];
        }

        public static bool IncludesKey<TKey, TValue>(this Dictionary<TKey, TValue> dictionary, TKey aKey)
        {
            return dictionary.ContainsKey(aKey);
        }

        public static void RemoveKeyIgnoring<TKey, TValue>(this Dictionary<TKey, TValue> dict, TKey key)
        {
            dict.Remove(key);
        }

        public static TValue AddIfNotPresent<TKey, TValue>(this Dictionary<TKey, TValue> dictionary, TKey key, TValue value)
        {
            if (!dictionary.TryGetValue(key, out TValue existingValue))
            {
                dictionary[key] = value;
                return value;
            }

            return existingValue;
        }

    }
}
