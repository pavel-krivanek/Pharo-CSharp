using System;
using System.Linq;
using System.Reflection;
using System.Text;

namespace PharoUtils
{
    public class WriteStream
    {
        private StringBuilder stringBuilder = new StringBuilder();

        public WriteStream NextPutAll(string aString)
        {
            stringBuilder.Append(aString);
            return this;
        }
        public WriteStream NextPutAll(char aCharacter)
        {
            stringBuilder.Append(aCharacter);
            return this;
        }

        public WriteStream NextPut(char? aCharacter)
        {
            stringBuilder.Append(aCharacter);
            return this;
        }
        public WriteStream Cr()
        {
            stringBuilder.AppendLine();
            return this;
        }
        public WriteStream Lf()
        {
            stringBuilder.AppendLine();
            return this;
        }
        public WriteStream Tab()
        {
            stringBuilder.Append("\t");
            return this;
        }
        public void Print(Object anObject)
        {
            // Check if the object has a method named 'PrintOn' that accepts a WriteStream parameter
            MethodInfo printOnMethod = anObject.GetType().GetMethod("PrintOn", new Type[] { typeof(WriteStream) });
            if (printOnMethod != null)
            {
                // If such a method exists, create a WriteStream instance (assuming it's defined somewhere in your code)
                WriteStream writeStream = new WriteStream(); // You need to define WriteStream according to your application

                // Invoke the PrintOn method on anObject, passing the writeStream as a parameter
                printOnMethod.Invoke(anObject, new object[] { writeStream });

                // Assuming WriteStream has a way to convert its contents to string, append that to stringBuilder
                stringBuilder.AppendLine(writeStream.ToString()); // This line assumes your WriteStream has a ToString or similar method to get its contents
            }
            else
            {
                // If the object does not have a PrintOn method, fall back to using ToString
                stringBuilder.AppendLine(anObject.ToString());
            }
        }

        public WriteStream Space()
        {
            stringBuilder.Append(" ");
            return this;
        }

        public string Contents()
        {
            return stringBuilder.ToString();
        }
    }
}
