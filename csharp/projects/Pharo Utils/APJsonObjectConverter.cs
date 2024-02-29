using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace PharoUtils
{
    public class APJsonObjectConverter : JsonConverter<APJsonObject>
    {
        public override APJsonObject Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            var jsonObject = new APJsonObject();
            if (reader.TokenType != JsonTokenType.StartObject)
            {
                throw new JsonException("Expected StartObject token");
            }

            while (reader.Read())
            {
                if (reader.TokenType == JsonTokenType.EndObject)
                {
                    return jsonObject;
                }

                if (reader.TokenType != JsonTokenType.PropertyName)
                {
                    throw new JsonException("Expected PropertyName token");
                }

                string propertyName = reader.GetString();
                reader.Read(); // Move to the value token

                // Assuming that the value can be a simple type, APJsonObject, or APJsonCollection
                object value;
                switch (reader.TokenType)
                {
                    case JsonTokenType.StartObject:
                        value = JsonSerializer.Deserialize<APJsonObject>(ref reader, options);
                        break;
                    case JsonTokenType.StartArray:
                        value = JsonSerializer.Deserialize<APJsonCollection>(ref reader, options);
                        break;
                    default:
                        value = JsonSerializer.Deserialize<object>(ref reader, options);
                        break;
                }

                jsonObject.Add(propertyName, value);
            }

            throw new JsonException("Unexpected end when reading JSON.");
        }

        public override void Write(Utf8JsonWriter writer, APJsonObject value, JsonSerializerOptions options)
        {
            writer.WriteStartObject(); // Start the object
            foreach (var kvp in value.Data())
            {
                writer.WritePropertyName(kvp.Key);
                if (kvp.Value is APJsonCollection collection)
                {
                    // Serialize the collection directly as an array
                    JsonSerializer.Serialize(writer, collection.Items, options);
                }
                else
                {
                    JsonSerializer.Serialize(writer, kvp.Value, options);
                }
            }
            writer.WriteEndObject(); // End the object
        }
    }
}

