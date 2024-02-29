using PharoUtils;
using System;
using System.Collections.Generic;
using System.Text.Json;

namespace PharoUtils
{
    public class APJsonObject : PdmObject, ICloneable
    {
        protected Dictionary<string, object> _data;

        public APJsonObject()
        {
            _data = new Dictionary<string, object>();
        }

        public Dictionary<string, object> Data()
        {
            return _data;
        }

        public APJsonObject(long size)
        {
            _data = new Dictionary<string, object>((int)size);
        }

        public void Add(string key, object value)
        {
            _data[key] = value;
        }
        public object At(string key)
        {
            return _data[key];
        }

        public object At(string key, Func<object?> ifAbsent)
        {
            return _data.At(key, ifAbsent);
        }

        public APJsonObject? JsonAtOrNil(string key)
        {
            return (APJsonObject)_data.At(key, ifAbsent: () => null);
        }

        public string? StringAtOrNil(string key)
        {
            return (string)_data.At(key, ifAbsent: () => null);
        }

        public long? IntegerAtOrNil(string key)
        {
            return (long)_data.At(key, ifAbsent: () => null);
        }

        public bool? BooleanAtOrNil(string key)
        {
            return (bool)_data.At(key, ifAbsent: () => null);
        }


        public APJsonObject JsonAt(string key)
        {
            return (APJsonObject)_data[key];
        }

        public string? StringAt(string key)
        {
            JsonElement? element = _data.ContainsKey(key) ? (JsonElement)_data[key] : null;
            if (element == null)
                return null;
            return ((JsonElement)element).GetString();
        }

        public string StringAt(string key, Func<string?> ifAbsent)
        {
            return (string)_data.At(key, ifAbsent);
        }


        public long IntegerAt(string key)
        {
            return ((JsonElement)_data[key]).GetInt64();
        }

        public bool BooleanAt(string key)
        {
            return ((JsonElement)_data[key]).GetBoolean();
        }

        public bool IsEmpty()
        {
            return _data.Count == 0;
        }

        public int Size()
        {
            return _data.Count;
        }

        public List<String> Keys()
        {
            return _data.Keys.ToList();
        }
        public object AnyOne()
        {
            return _data.Any();
        }

        public APJsonObject KeysAndValuesDo(Action<string, object> action)
        {
            foreach (var kvp in _data)
            {
                action(kvp.Key, kvp.Value);
            }
            return this;
        }

        public APJsonObject KeysAndStringValuesDo(Action<string, string> action)
        {
            foreach (var kvp in _data)
            {
                action(kvp.Key, ((JsonElement)kvp.Value).GetString());
            }
            return this;
        }


        public void KeysAndValuesDo(Func<string, object, object> func)
        {
            foreach (var kvp in _data)
            {
                func(kvp.Key, kvp.Value);
            }
        }


        public List<APJsonObject> Select(Func<APJsonObject, bool> func)
        {
            return _data.Values.OfType<APJsonObject>().Where(func).ToList();
        }

        public bool TryGetValue(string key, out object value)
        {
            return _data.TryGetValue(key, out value);
        }

        public List<object> Values()
        {
            return _data.Values.ToList();
        }

        public APJsonCollection CollectionAt(string key)
        {
            return ((APJsonCollection)_data[key]);
        }

        public void At(string key, object put /* value */)
        {
            object value = put;
            _data[key] = value;
        }

        public void At_(string key, object putIfNotNil /* value */)
        {
            object value = putIfNotNil;
            _data[key] = value;
        }

        // Method to serialize this object to JSON string
        public string JsonString()
        {
            var options = SerializationOptions();
            return JsonSerializer.Serialize(this, options);
        }

        public APJsonObject PrintJsonOn(WriteStream writeStream)
        {
            writeStream.NextPutAll(JsonString());
            return this;
        }

        public string PrintJson()
        {
            return JsonString();
        }

        public object Clone()
        {
            return this.MemberwiseClone();
        }

        public APJsonObject Copy()
        {
            return (APJsonObject)this.Clone();
        }

        //public TReturn? At<TReturn>(string key, Func<object, TReturn?> ifPresent) where TReturn : class
        //{
        //    return _data.At<string, object, TReturn>(key, ifPresent);
        //}

        //public void At<TValue>(string key, Action<TValue> ifPresent) where TValue : class
        //{
        //    if (_data.TryGetValue(key, out object value) && value is TValue typedValue)
        //    {
        //        ifPresent(typedValue);
        //    }
        //}

        //public TReturn? At<TReturn>(string key, Func<object, TReturn?> ifPresent) where TReturn : class
        //{
        //    return _data.At<string, object, TReturn>(key, ifPresent);
        //}

        //public void At<TValue>(string key, Action<TValue> ifPresent)
        //{
        //    if (_data.TryGetValue(key, out object value))
        //    {
        //        TValue casted = (TValue)value;
        //        ifPresent(casted);
        //    }
        //}

        public void StringAt(string key, Action<string> ifPresent)
        {
            if (_data.TryGetValue(key, out object element))
            {
                ifPresent(((JsonElement)element).GetString());
            }
        }

        public void JsonCollAt(string key, Action<List<string>> ifPresent)
        {
            if (_data.TryGetValue(key, out object element))
            { 
                // ERROR, NOT ACTUALLY WORKING
                ifPresent(new List<string>());
            }
        }

        public object? _At(string key, Func<object?> ifAbsentPut)
        {
            return _data._At(key, ifAbsentPut);
        }

        public static APJsonObject Create()
        {
            return new APJsonObject();
        }

        public void PrintJsonIncludingNilOn(WriteStream writeStream)
        {
            PrintJsonOn(writeStream);
        }

        public static JsonSerializerOptions SerializationOptions()
        {
            var options = new JsonSerializerOptions { WriteIndented = true };
            options.Converters.Add(new APJsonObjectConverter());
            options.Converters.Add(new APJsonCollectionConverter());
            options.Converters.Add(new DateAndTimeConverter());
            return options;
        }

    }
}
