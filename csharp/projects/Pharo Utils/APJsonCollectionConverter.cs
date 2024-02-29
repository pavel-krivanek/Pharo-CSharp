using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace PharoUtils
{
    public class APJsonCollectionConverter : JsonConverter<APJsonCollection>
    {
        public override APJsonCollection Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType != JsonTokenType.StartArray)
            {
                throw new JsonException("Expected StartArray token");
            }

            var jsonCollection = new APJsonCollection();
            while (reader.Read() && reader.TokenType != JsonTokenType.EndArray)
            {
                // Deserialize each item in the array and add it to the collection
                object item = JsonSerializer.Deserialize<object>(ref reader, options);
                jsonCollection.Add(item);
            }

            if (reader.TokenType != JsonTokenType.EndArray)
            {
                throw new JsonException("Unexpected end when reading JSON array.");
            }

            return jsonCollection;
        }


        public override void Write(Utf8JsonWriter writer, APJsonCollection value, JsonSerializerOptions options)
        {
            JsonSerializer.Serialize(writer, value.Items, options);
        }
    }
}