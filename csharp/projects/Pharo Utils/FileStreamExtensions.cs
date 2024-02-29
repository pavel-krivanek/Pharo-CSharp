using System;
using System.IO;
using System.Text;

namespace PharoUtils
{
    public static class FileStreamExtensions
    {
        public static void Space(this FileStream fileStream)
        {
            byte[] buffer = Encoding.UTF8.GetBytes(" ");
            fileStream.Write(buffer, 0, buffer.Length);
        }

        public static void NextPutAll(this FileStream fileStream, string text)
        {
            if (text == null) throw new ArgumentNullException(nameof(text), "Text cannot be null.");
            byte[] buffer = Encoding.UTF8.GetBytes(text);
            fileStream.Write(buffer, 0, buffer.Length);
        }

        public static void Cr(this FileStream fileStream)
        {
            byte[] buffer = Encoding.UTF8.GetBytes(Environment.NewLine);
            fileStream.Write(buffer, 0, buffer.Length);
        }
    }
}