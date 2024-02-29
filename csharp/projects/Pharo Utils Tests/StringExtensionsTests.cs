using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PharoUtils;

namespace Pharo_Utils_Tests
{
    internal class StringExtensionsTests
    {

        [Test]
        public void Copy_ReturnsSameString()
        {
            string original = "test";

            string copied = original.Copy();

            Assert.That(copied, Is.EqualTo(original));
            Assert.IsFalse(object.ReferenceEquals(original, copied));
        }

        [Test]
        public void Format_NullArgs_ThrowsArgumentNullException()
        {
            string format = "{0} {1}";
            List<string> args = null;

            Assert.Throws<ArgumentNullException>(() => format.Format(args));
        }

        [Test]
        public void Format_EmptyFormat_ReturnsEmptyString()
        {
            string format = "";
            List<string> args = new List<string>() { "arg1", "arg2" };

            string result = format.Format(args);

            Assert.That(result, Is.EqualTo(""));
        }

        [Test]
        public void Format_ValidFormatAndArgs_ReturnsFormattedString()
        {
            string format = "{1} {2}";
            List<string> args = new List<string>() { "arg1", "arg2" };

            string result = format.Format(args);

            Assert.That(result, Is.EqualTo("arg1 arg2"));
        }
    

        [Test]
        public void AllButLast_NullString_ReturnsEmptyString()
        {
            string input = null;
            string result = input.AllButLast();
            Assert.That(result, Is.EqualTo(string.Empty));
        }

        [Test]
        public void AllButLast_EmptyString_ReturnsEmptyString()
        {
            string input = string.Empty;
            string result = input.AllButLast();
            Assert.That(result, Is.EqualTo(string.Empty));
        }

        [Test]
        public void AllButLast_SingleCharacterString_ReturnsEmptyString()
        {
            string input = "a";
            string result = input.AllButLast();
            Assert.That(result, Is.EqualTo(string.Empty));
        }

        [Test]
        public void AllButLast_MultiCharacterString_ReturnsSubstringExcludingLastCharacter()
        {
            string input = "hello";
            string result = input.AllButLast();
            Assert.That(result, Is.EqualTo("hell"));
        }


        [Test]
        public void AsInteger_ValidIntegerString_ReturnsIntegerValue()
        {
            string input = "123";
        
            long? result = input.AsInteger();
        
            Assert.That(result, Is.EqualTo(123));
        }

        [Test]
        public void AsInteger_InvalidIntegerString_ReturnsNull()
        {
            string input = "abc";
        
            long? result = input.AsInteger();
        
            Assert.IsNull(result);
        }

        [Test]
        public void At_ReturnsCorrectCharacter_WhenIndexIsWithinBounds()
        {
            string str = "Hello";

            char result = str.At(3);

            Assert.That(result, Is.EqualTo('l'));
        }

        [Test]
        public void At_ThrowsException_WhenIndexIsNegative()
        {
            string str = "Hello";

            Assert.Throws<ArgumentOutOfRangeException>(() => str.At(-1));
        }

        [Test]
        public void At_ThrowsException_WhenIndexIsOutOfRange()
        {
            string str = "Hello";

            Assert.Throws<ArgumentOutOfRangeException>(() => str.At(6));
        }


        [Test]
        public void BeginsWith_WhenStringBeginsWithAnotherString_ReturnsTrue()
        {
            string source = "hello";
            string anotherString = "he";

            bool result = source.BeginsWith(anotherString);

            Assert.IsTrue(result);
        }

        [Test]
        public void BeginsWith_WhenStringDoesNotBeginWithAnotherString_ReturnsFalse()
        {
            // Arrange
            string source = "hello";
            string anotherString = "hi";

            bool result = source.BeginsWith(anotherString);

            Assert.IsFalse(result);
        }

        [Test]
        public void IsDigit_WhenInputIsDigit_ReturnsTrue()
        {
            char digit = '5';

            bool result = digit.IsDigit();

            Assert.IsTrue(result);
        }

        [Test]
        public void IsDigit_WhenInputIsNotDigit_ReturnsFalse()
        {
            char nonDigit = 'a';

            bool result = nonDigit.IsDigit();

            Assert.IsFalse(result);
        }
    }
}

