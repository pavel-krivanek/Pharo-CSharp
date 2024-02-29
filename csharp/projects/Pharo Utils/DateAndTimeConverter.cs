using System.Text.Json.Serialization;
using System.Text.Json;

namespace PharoUtils
{

    public class DateAndTimeConverter : JsonConverter<DateAndTime>
    {
        public override DateAndTime Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            // Implement deserialization if necessary, for now, just throw an exception
            throw new NotImplementedException();
        }

        public override void Write(Utf8JsonWriter writer, DateAndTime value, JsonSerializerOptions options)
        {
            // Use the JsonString method for serialization
            writer.WriteStringValue(value.JsonString());
        }
    }
}
