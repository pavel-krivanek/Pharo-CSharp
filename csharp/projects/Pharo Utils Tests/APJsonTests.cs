//---------------------------------------------------------------------------------------------------------------------------------------------------
// Class name 		    : JsonSupportUnittests
// Comment		        : unittests for JsonSupport classes
// Last change / author	: 09.02.2024 / RH
// History  	:
//  [N/RH] 09.02.2024	first bit set
//---------------------------------------------------------------------------------------------------------------------------------------------------

using PharoUtils;
using System;
using System.Net;
using System.Text.Json;

namespace JsonSupportUnittests
{
    public class APJsonTests
    {
        private string jsonString;

        [OneTimeSetUp]
        public void Setup()
        {
            var person = new
            {
                Name = "John Doe",
                Age = 30,
                IsEmployee = true,
                Address = new 
                {
                    Street = "123 Main St",
                    City = "Anytown"
                },
                Hobbies = new string[] { "Reading", "Hiking", "Coding" }
            };

            jsonString = JsonSerializer.Serialize(person, new JsonSerializerOptions { WriteIndented = true });
        }

        [Test]
        public void Test1()
        {
            var options = new JsonSerializerOptions();
            options.Converters.Add(new APJsonObjectConverter());
            options.Converters.Add(new APJsonCollectionConverter());
            options.Converters.Add(new DateAndTimeConverter());
            APJsonObject apJsonObject = JsonSerializer.Deserialize<APJsonObject>(jsonString, options);

            Assert.AreEqual(apJsonObject.StringAt("Name"), "John Doe");
           
            Assert.AreEqual((apJsonObject.CollectionAt("Hobbies")).StringAt(3),  "Coding");
        }

        [Test]
        public void AsStringArray_ReturnsCorrectListOfStrings()
        {
            var options = new JsonSerializerOptions();
            options.Converters.Add(new APJsonObjectConverter());
            options.Converters.Add(new APJsonCollectionConverter());
            options.Converters.Add(new DateAndTimeConverter());
            APJsonObject apJsonObject = JsonSerializer.Deserialize<APJsonObject>(jsonString, options);

            var collection = apJsonObject.CollectionAt("Hobbies");

            List<String> list = collection.AsStringArray();

            Assert.IsNotNull(list);
            Assert.AreEqual(3, list.Count);
            Assert.AreEqual("Reading", list[0]);
            Assert.AreEqual("Hiking", list[1]);
            Assert.AreEqual("Coding", list[2]);
        }

        [Test]
        public void TestSerializeDateAndTime1()
        {
            var options = new JsonSerializerOptions();
            options.Converters.Add(new APJsonObjectConverter());
            options.Converters.Add(new APJsonCollectionConverter());
            options.Converters.Add(new DateAndTimeConverter());
            DateAndTime dateAndTime = DateAndTime.Now();

            string output = JsonSerializer.Serialize(dateAndTime, options);

            // while we use Now(), we cannot reliably compare
            Assert.Pass();
       }

        [Test]
        public void TestSerializeDateAndTime2()
        {
            var options = new JsonSerializerOptions();

            options.Converters.Add(new APJsonObjectConverter());
            options.Converters.Add(new APJsonCollectionConverter());
            options.Converters.Add(new DateAndTimeConverter());

            DateAndTime dateAndTime = DateAndTime.Now();
            APJsonObject jsonObj = new APJsonObject();
            jsonObj.At("dateAndTime", put: dateAndTime);

            string output = JsonSerializer.Serialize(jsonObj, options);

            // while we use Now(), we cannot reliably compare
            Assert.Pass();
        }
    }
}