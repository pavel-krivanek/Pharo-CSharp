using PharoUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pharo_Utils_Tests
{
    internal class DictionaryExtensionsTests
    {
        [Test]
        public void At_KeyExists_ReturnsValue()
        {
            // Arrange
            var dictionary = new Dictionary<int, string>
            {
                { 1, "one" },
                { 2, "two" }
            };

            // Act
            var result = dictionary.At(1);

            // Assert
            Assert.That(result, Is.EqualTo("one"));
        }

        [Test]
        public void At_KeyDoesNotExist_ThrowsKeyNotFoundException()
        {
            // Arrange
            var dictionary = new Dictionary<int, string>
            {
                { 1, "one" },
                { 2, "two" }
            };

            // Assert
            Assert.Throws<KeyNotFoundException>(() => dictionary.At(3));
        }

        [Test]
        public void AtOrNil_WithExistingKey_ReturnsValue()
        {
            Dictionary<string, int> dictionary = new Dictionary<string, int> { { "one", 1 }, { "two", 2 } };
            int? result = dictionary.AtOrNil("two");
            Assert.That(result, Is.EqualTo(2));
        }

        [Test]
        public void AtOrNil_WithNonExistingKey_ReturnsDefault()
        {
            var dictionary = new Dictionary<string, int?> { { "one", 1 }, { "two", 2 } };
            int? result = dictionary.AtOrNil("three");
            Assert.That(result, Is.EqualTo(null));
        }


        [Test]
        public void AtOrNil_WithNonExistingKey_ReturnsDefault_With_Object()
        {
            var obj1 = new object();
            var obj2 = new object();

            var dictionary = new Dictionary<string, object> { { "one", obj1 }, { "two", obj2 } };
            object? result = dictionary.AtOrNil("three");
            Assert.That(result, Is.EqualTo(null));
        }

        [Test]
        public void AtOrNil_WithDefaultValueType_ReturnsDefault()
        {
            var dictionary = new Dictionary<string, int?>();
            int? result = dictionary.AtOrNil("three");
            Assert.That(result, Is.EqualTo(null));
        }

        [Test]
        public void AtIfAbsent_KeyExists_ReturnsValue()
        {
            var dictionary = new Dictionary<string, int>
            {
                { "a", 1 },
                { "b", 2 }
            };
            var result = dictionary.At("a", ifAbsent: () => 0);
            Assert.That(result, Is.EqualTo(1));
        }

        [Test]
        public void AtIfAbsent_KeyDoesNotExist_ReturnsDefaultValue()
        {
            var dictionary = new Dictionary<string, int>
            {
                { "a", 1 },
                { "b", 2 }
            };
            var result = dictionary.At("c", ifAbsent: () => 0);
            Assert.That(result, Is.EqualTo(0));
        }

        [Test]
        public void AtIfAbsent__ExistingKey_ReturnsValue()
        {
            // Arrange
            var key1 = new object();
            var key2 = new object();
            var dictionary = new Dictionary<object, int> { { key1, 1 }, { key2, 2 } };

            // Act
            var result = dictionary.At(key1, () => 0);

            // Assert
            Assert.That(result, Is.EqualTo(1));
        }

        [Test]
        public void AtIfAbsent__NonExistingKey_ReturnsIfAbsentValue()
        {
            // Arrange
            var key1 = new object();
            var key2 = new object();
            var dictionary = new Dictionary<object, int> { { key1, 1 }, { key2, 2 } };

            // Act
            var result = dictionary.At(new object(), () => 0);

            // Assert
            Assert.That(result, Is.EqualTo(0));
        }

        [Test]
        public void AtIfPresent_WithPresentKey_ReturnsValueFromIfPresentFunc()
        {
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" }
            };

            var result = dictionary.At("key1", ifPresent: val => val.ToUpper());

            Assert.That(result, Is.EqualTo("VALUE1"));
        }

        [Test]
        public void AtIfPresentIfAbsent_WithAbsentKeyAndIfAbsentFunc_ReturnsValueFromIfAbsentFunc()
        {
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" }
            };

            var result = dictionary.At("key2", ifPresent: val => val.ToUpper(), ifAbsent: () => "default");

            Assert.That(result, Is.EqualTo("default"));
        }

        [Test]
        public void AtIfPresent_WithAbsentKeyAndNoIfAbsentFunc_ReturnsDefault()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" }
            };

            // Act
            var result = dictionary.At("key2", val => val.ToUpper());

            // Assert
            Assert.IsNull(result);
        }


        [Test]
        public void AtIfPresent_WhenKeyExists_ReturnsValue()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key1", val => val.ToUpper());

            // Assert
            Assert.That(result, Is.EqualTo("VALUE1"));
        }

        [Test]
        public void AtWithPresent_WhenKeyDoesNotExist_ReturnsDefault()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key3", val => val.ToUpper(), () => "default");

            // Assert
            Assert.That(result, Is.EqualTo("default"));
        }

        [Test]
        public void AtWithPresent_WhenKeyDoesNotExistAndIfAbsentIsNull_ReturnsDefault()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key3", val => val.ToUpper());

            // Assert
            Assert.That(result, Is.EqualTo(default(string)));
        }


        [Test]
        public void AtIfPresentIfAbsent_WhenKeyDoesNotExist_ReturnsDefault()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key3", val => val.ToUpper(), () => "default");

            // Assert
            Assert.That(result, Is.EqualTo("default"));
        }

        [Test]
        public void tIfPresentIfAbsent_WhenKeyDoesNotExistAndIfAbsentIsNull_ReturnsDefault()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key3", val => val.ToUpper());

            // Assert
            Assert.That(result, Is.EqualTo(default(string)));
        }

        [Test]
        public void tIfPresentIfAbsent_WhenKeyDoesNotExistAndIfAbsentIsSet_ReturnsIfAbsentResult()
        {
            // Arrange
            var dictionary = new Dictionary<string, string>
            {
                { "key1", "value1" },
                { "key2", "value2" }
            };

            // Act
            var result = dictionary.At("key3", val => val.ToUpper(), () => "default");

            // Assert
            Assert.That(result, Is.EqualTo("default"));
        }


        [Test]
        public void Values_ShouldReturnAllDictionaryValues()
        {
            // Arrange
            var dictionary = new Dictionary<int, string>
            {
                { 1, "one" },
                { 2, "two" },
                { 3, "three" }
            };

            // Act
            var result = dictionary.Values();

            // Assert
            CollectionAssert.AreEqual(new List<string> { "one", "two", "three" }, result);
        }

        [Test]
        public void Keys_ReturnsEmptyList_WhenDictionaryIsEmpty()
        {
            // Arrange
            var dictionary = new Dictionary<string, int>();

            // Act
            var result = dictionary.Keys();

            // Assert
            Assert.IsEmpty(result);
        }

        [Test]
        public void Keys_ReturnsListOfKeys_WhenDictionaryIsNotEmpty()
        {
            // Arrange
            var dictionary = new Dictionary<string, int>
            {
                { "one", 1 },
                { "two", 2 }
            };

            // Act
            var result = dictionary.Keys();

            // Assert
            Assert.That(result.Count, Is.EqualTo(2));
            CollectionAssert.AreEquivalent(new List<string> { "one", "two" }, result);
        }


        [Test]
        public void AtifAbsentPut_KeyExists_ReturnsValue()
        {
            // Arrange
            var dictionary = new Dictionary<string, int?> { { "key1", 1 } };

            // Act
            var result = dictionary._At("key1", ifAbsentPut: () => 10);

            // Assert
            Assert.That(result, Is.EqualTo(1));
        }

        [Test]
        public void AtifAbsentPut_KeyDoesNotExist_ReturnsComputedValue()
        {
            // Arrange
            var dictionary = new Dictionary<string, int?>();

            // Act
            var result = dictionary._At("key2", ifAbsentPut: () => 20);

            // Assert
            Assert.That(result, Is.EqualTo(20));
            Assert.That(dictionary["key2"], Is.EqualTo(20));
        }
        

        [Test]
        public void AtPut_WhenDictionaryIsNull_ThrowsArgumentNullException()
        {
            // Arrange
            Dictionary<int, string> dictionary = null;

            // Act & Assert
            Assert.Throws<ArgumentNullException>(() => dictionary.At(1, put: "value"));
        }

        [Test]
        public void AtPut_WhenKeyExists_ReturnsUpdatedValue()
        {
            // Arrange
            var dictionary = new Dictionary<int, string> { { 1, "value1" } };

            // Act
            var result = dictionary.At(1, put: "updatedValue");

            // Assert
            Assert.That(result, Is.EqualTo("updatedValue"));
        }

        [Test]
        public void AtPut_WhenKeyDoesNotExist_AddsNewEntry()
        {
            // Arrange
            var dictionary = new Dictionary<int, string> { { 1, "value1" } };

            // Act
            var result = dictionary.At(2, put: "value2");

            // Assert
            Assert.That(result, Is.EqualTo("value2"));
            Assert.IsTrue(dictionary.ContainsKey(2));
        }

        [Test]
        public void IncludesKey_WhenKeyExists_ReturnsTrue()
        {
            // Arrange
            var dictionary = new Dictionary<int, string>
            {
                { 1, "one" },
                { 2, "two" }
            };

            // Act
            var result = dictionary.IncludesKey(1);

            // Assert
            Assert.IsTrue(result);
        }

        [Test]
        public void IncludesKey_WhenKeyDoesNotExist_ReturnsFalse()
        {
            // Arrange
            var dictionary = new Dictionary<int, string>
            {
                { 1, "one" },
                { 2, "two" }
            };

            // Act
            var result = dictionary.IncludesKey(3);

            // Assert
            Assert.IsFalse(result);
        }

        [Test]
        public void RemoveKeyIgnoring_RemovesKey_Successfully()
        {
            // Arrange
            var dict = new Dictionary<string, int>
            {
                { "a", 1 },
                { "b", 2 }
            };

            // Act
            dict.RemoveKeyIgnoring("a");

            // Assert
            Assert.IsFalse(dict.ContainsKey("a"));
        }

        [Test]
        public void RemoveKeyIgnoring_KeyNotPresent_NoChange()
        {
            // Arrange
            var dict = new Dictionary<string, int>
            {
                { "a", 1 },
                { "b", 2 }
            };

            // Act
            dict.RemoveKeyIgnoring("c");

            // Assert
            Assert.IsTrue(dict.ContainsKey("a"));
            Assert.IsTrue(dict.ContainsKey("b"));
        }

        [Test]
        public void AddIfNotPresent_KeyNotPresent_AddsValue()
        {
            var dictionary = new Dictionary<int, string>();
            dictionary.AddIfNotPresent(1, "one");
            Assert.That(dictionary[1], Is.EqualTo("one"));
        }

        [Test]
        public void AddIfNotPresent_KeyAlreadyPresent_ReturnsExistingValue()
        {
            var dictionary = new Dictionary<int, string> { { 1, "one" } };
            var result = dictionary.AddIfNotPresent(1, "newOne");
            Assert.That(result, Is.EqualTo("one"));
        }


    }

}


