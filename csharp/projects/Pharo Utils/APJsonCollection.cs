using Microsoft.Diagnostics.Tracing.Parsers.MicrosoftWindowsWPF;
using PharoUtils;
using System;
using System.Collections.Generic;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace PharoUtils;

public class APJsonCollection : PdmObject, ICloneable
{
    bool propertyName;
    private List<object> _items = new List<object>();

    public void Add(object item)
    {
        _items.Add(item);
    }

    public object At(int index)
    {
        return _items[index - 1];
    }

    public APJsonObject JsonAt(int index)
    {
        return ((APJsonObject)_items[index - 1]);
    }

    public string StringAt(int index)
    {
        return ((JsonElement)_items[index - 1]).GetString();
    }

    public APJsonCollection AddAll(IEnumerable<object> items)
    {
        foreach (var item in items)
        {
            _items.Add(item);
        }
        return this;
    }

    public List<object> Items
    { 
        get => _items; 
        private set => _items = value; 
    }

    // Method to serialize this collection to JSON string
    public string ToJsonString()
    {
        var options = APJsonObject.SerializationOptions();
        return JsonSerializer.Serialize(this, options);
    }

    public static APJsonCollection WithAll(IEnumerable<object> items)
    {
        APJsonCollection collection = new APJsonCollection();
        collection.AddAll(items);
        return collection;
    }

    public List<string> AsStringArray()
    {
        List<string> stringList = new List<string>();
        foreach (var item in _items)
        {
            var jsonElement = (JsonElement)item;
            string stringValue = jsonElement.GetString();
            if (stringValue != null)
            {
                stringList.Add(stringValue);
            }
        }
        return stringList;
    }

    public static APJsonCollection Create()
    {
        return new APJsonCollection();
    }

    public long AddInteger(long value)
    {
        _items.Add(value);
        return value;
    }
    public object Clone()
    {
        return this.MemberwiseClone();
    }

    public APJsonCollection Copy()
    {
        return (APJsonCollection)this.Clone();
    }
}
