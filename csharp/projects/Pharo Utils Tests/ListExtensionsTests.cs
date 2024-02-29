using PharoUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Pharo_Utils_Tests
{
    internal class ListExtensionsTests
    {

        [Test]
        public void AnyOne_WithEmptyList_ReturnsNull()
        {
            List<string> emptyList = new List<string>();

            var result = emptyList.AnyOne();

            Assert.IsNull(result);
        }

        [Test]
        public void AnyOne_WithEmptyList_ReturnsNull_Unboxed()
        {
            var emptyList = new List<int?>();

            int? result = emptyList.AnyOne();

            Assert.IsNull(result);
        }

        [Test]
        public void AnyOne_WithNonEmptyList_ReturnsFirstElement()
        {
            // Value types must be boxed to allow usage of this method!
            var list = new List<int?> { 1, 2, 3 };

            int? result = list.AnyOne();

            Assert.That(result, Is.EqualTo(1));
        }

        public void AnyOne_WithNonEmptyList_ReturnsFirstElement_Unboxed()
        {
            // Value types must be boxed to allow usage of this method!
            var list = new List<int?> { 1, 2, 3 };

            var result = list.AnyOne();

            Assert.That(result, Is.EqualTo(1));
        }


        [Test]
        public void IsEmpty_ReturnsTrueForEmptyList()
        {
            var emptyList = new List<int>();

            var result = emptyList.IsEmpty();

            Assert.IsTrue(result);
        }

        [Test]
        public void IsEmpty_ReturnsFalseForNonEmptyList()
        {
            var nonEmptyList = new List<int> { 1, 2, 3 };

            var result = nonEmptyList.IsEmpty();

            Assert.That(result, Is.False);
        }

        [Test]
        public void IsEmpty_ReturnsTrueForEmptyReferenceTypeList()
        {
            var emptyList = new List<string>();

            var result = emptyList.IsEmpty();

            Assert.IsTrue(result);
        }

        [Test]
        public void IsEmpty_ReturnsFalseForNonEmptyReferenceTypeList()
        {
            var nonEmptyList = new List<string> { "apple", "banana", "cherry" };

            var result = nonEmptyList.IsEmpty();

            Assert.That(result, Is.False);
        }


        [Test]
        public void NotEmpty_ReturnsTrueForNonEmptyList()
        {
            var list = new List<int> { 1, 2, 3 };

            var result = list.NotEmpty();

            Assert.IsTrue(result);
        }

        [Test]
        public void NotEmpty_ReturnsFalseForEmptyList()
        {
            var list = new List<int>();

            var result = list.NotEmpty();

            Assert.IsFalse(result);
        }

        [Test]
        public void AddFirst_AddsItemToList_ReturnsCorrectCount()
        {
            var list = new List<int> { 1, 2, 3 };
            var item = 0;

            list.AddFirst(item);

            Assert.That(0, Is.EqualTo(list[0]));
            Assert.That(list.Count, Is.EqualTo(4));
        }

            [Test]
        public void Remove_RemovesItem_ReturnsNull()
        {
            var list = new List<int?> { 1, 2, 3 };

            int? result = list.Remove(2, () => null);

            Assert.IsNull(result);
            CollectionAssert.DoesNotContain(list, 2);
        }

        [Test]
        public void Remove_ItemNotFound_ReturnsIfAbsentValue()
        {
            var list = new List<int> { 1, 2, 3 };

            var result = list.Remove(4, () => 0);

            Assert.That(result, Is.EqualTo(0));
            CollectionAssert.Contains(list, 1);
        }

        [Test]
        public void AddAll_CollectionNotNull_AddsAllItems()
        {
            var list = new List<int> { 1, 2, 3 };
            var collection = new List<int> { 4, 5, 6 };

            list.AddAll(collection);

            CollectionAssert.AreEqual(new List<int> { 1, 2, 3, 4, 5, 6 }, list);
        }

        [Test]
        public void AddAll_CollectionNull_ThrowsArgumentNullException()
        {
            var list = new List<int> { 1, 2, 3 };
            List<int> collection = null;

            Assert.Throws<ArgumentNullException>(() => list.AddAll(collection));
        }

        [Test]
        public void AtPut_IndexWithinBounds_ReturnsNewValue()
        {
            var list = new List<int> { 1, 2, 3 };

            var result = list.At(2, put: 5);

            Assert.That(result, Is.EqualTo(5));
            Assert.That(list[1], Is.EqualTo(5));
        }

        [Test]
        public void AtPut_IndexOutOfBounds_ThrowsException()
        {
            var list = new List<int> { 1, 2, 3 };

            Assert.Throws<ArgumentOutOfRangeException>(() => list.At(4, put: 5));
        }


        [Test]
        public void At_ReturnsCorrectElement_WhenIndexWithinBounds()
        {
            var list = new List<int> { 1, 2, 3 };

            var result = list.At(2);

            Assert.That(result, Is.EqualTo(2));
        }

        [Test]
        public void At_ThrowsException_WhenIndexIsNegative()
        {
            var list = new List<int> { 1, 2, 3 };

            Assert.Throws<ArgumentOutOfRangeException>(() => list.At(-1));
        }

        [Test]
        public void At_ThrowsException_WhenIndexIsGreaterThanListCount()
        {
            var list = new List<int> { 1, 2, 3 };

            Assert.Throws<ArgumentOutOfRangeException>(() => list.At(4));
        }


        [Test]
        public void RemoveAt_RemovesElementAtIndex_ReturnsRemovedElement()
        {
            var list = new List<int> { 1, 2, 3, 4, 5 };

            var removed = list._RemoveAt(2);

            Assert.That(removed, Is.EqualTo(2));
            CollectionAssert.AreEqual(new List<int> { 1, 3, 4, 5 }, list);
        }

        [Test]
        public void RemoveAt_RemovesFirstElement_ReturnsRemovedElement()
        {
            var list = new List<int> { 1, 2, 3, 4, 5 };

            var removed = list._RemoveAt(1);

            Assert.That(removed, Is.EqualTo(1));
            CollectionAssert.AreEqual(new List<int> { 2, 3, 4, 5 }, list);
        }


        [Test]
        public void Sorted_ReturnsSortedIntegerList()
        {
            var input = new List<int> { 3, 1, 2 };

            var result = input.Sorted();

            Assert.That(result, Is.EqualTo(new List<int> { 1, 2, 3 }));
        }

        [Test]
        public void Sorted_ReturnsSortedStringList()
        {
            var input = new List<string> { "c", "a", "b" };

            var result = input.Sorted();

            Assert.That(result, Is.EqualTo(new List<string> { "a", "b", "c" }));
        }


        [Test]
        public void TestIndexOf_ItemInList_ReturnsCorrectIndex()
        {
            List<int?> list = new List<int?> { 1, 2, 3, null, 5 };

            long index = list._IndexOf(3);

            Assert.That(index, Is.EqualTo(3));
        }

        [Test]
        public void TestIndexOf_NullItemInList_ReturnsCorrectIndex()
        {
            List<string> list = new List<string> { "apple", "orange", null, "banana" };

            long index = list._IndexOf(null);

            Assert.That(index, Is.EqualTo(3));
        }

        [Test]
        public void TestIndexOf_ItemNotInList_ReturnsZero()
        {
            List<int> list = new List<int> { 1, 2, 3 };

            long index = list._IndexOf(4);

            Assert.That(index, Is.EqualTo(0));
        }

        
        [Test]
        public void AllSatisfy_ReturnsTrue_WhenAllItemsSatisfyPredicate()
        {
            var list = new List<int> { 2, 4, 6, 8 };

            var result = list.AllSatisfy((x) => x % 2 == 0);

            Assert.IsTrue(result);
        }

        [Test]
        public void AllSatisfy_ReturnsFalse_WhenAtLeastOneItemDoesNotSatisfyPredicate()
        {
            var list = new List<int> { 2, 4, 6, 7, 8 };

            var result = list.AllSatisfy((x) => x % 2 == 0);

            Assert.IsFalse(result);
        }

        [Test]
        public void AllSatisfy_ReturnsTrue_WhenListIsEmpty()
        {
            var list = new List<int>();

            var result = list.AllSatisfy((x) => x % 2 == 0);

            Assert.IsTrue(result);
        }
   
        [Test]
        public void AnySatisfy_ReturnsTrue_WhenAnyItemSatisfiesPredicate()
        {
            var list = new List<int> { 1, 2, 3, 4, 5 };

            var result = list.AnySatisfy(x => x > 3);

            Assert.IsTrue(result);
        }

        [Test]
        public void AnySatisfy_ReturnsFalse_WhenNoItemSatisfiesPredicate()
        {
            var list = new List<int> { 1, 2, 3, 4, 5 };

            var result = list.AnySatisfy(x => x > 5);

            Assert.IsFalse(result);
        }

        [Test]
        public void Reversed_ReturnsReversedList()
        {
            var originalList = new List<int> { 1, 2, 3 };

            var reversedList = originalList.Reversed();

            CollectionAssert.AreEqual(new List<int> { 3, 2, 1 }, reversedList);
        }

        [Test]
        public void Reversed_ReturnsEmptyList_WhenSourceListIsEmpty()
        {
            var originalList = new List<int>();

            var reversedList = originalList.Reversed();

            CollectionAssert.IsEmpty(reversedList);
        }


        [Test]
        public void AddIfNotPresent_ItemNotPresent_ItemAddedToList()
        {
            var list = new List<int> { 1, 2, 3 };
            var item = 4;

            var result = list.AddIfNotPresent(item);

            Assert.IsTrue(list.Contains(item));
            Assert.That(result, Is.EqualTo(item));
        }

        [Test]
        public void AddIfNotPresent_ItemPresent_ItemNotAddedToList()
        {
            var list = new List<int> { 1, 2, 3 };
            var item = 3;

            var result = list.AddIfNotPresent(item);

            Assert.That(list.Count, Is.EqualTo(3));
            Assert.IsTrue(list.Contains(item));
            Assert.That(result, Is.EqualTo(item));
        }
    }
}
   









