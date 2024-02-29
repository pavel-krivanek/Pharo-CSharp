using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Linq;

namespace PharoUtils
{
    public class PdmObject
    {
        public PdmObject()
        {
            Initialize();
        }
        public virtual PdmObject Initialize()
        {
            return this;
        }

        public virtual T? Copy<T>() where T : PdmObject, new()
        {
            T copy = (T)this.MemberwiseClone();
            return copy.PostCopy<T>();
        }

        public virtual T PostCopy<T>() where T : PdmObject, new()
        {
            return (T)this;
        }

        public virtual PdmObject PrintOn(WriteStream writeStream)
        {
            writeStream.NextPutAll(this.ToString());
            return this;
        }

        public static void PdmError(object aString, object? attribute = null)
        {
        }

        public static void PdmDeveloperHalt(object? attribute = null)
        {
        }
        public static string PdmTranslateDeferred(string aString)
        {
            return aString;
        }

        public void Assert(bool aBoolean, string? description)
        {
            if (!aBoolean)
            { 
                throw new ArgumentException(description);
            }
        }

        public void Assert(bool aBoolean)
        {
            if (!aBoolean)
            {
                throw new ArgumentException();
            }
        }

        public void Perform(string aSelector)
        {
            // Get the MethodInfo object for the method named 'aSelector'
            MethodInfo methodInfo = this.GetType().GetMethod(aSelector, BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);

            // If the method exists, invoke it
            if (methodInfo != null)
            {
                methodInfo.Invoke(this, null);
            }
            else
            {
                throw new Exception($"Method '{aSelector}' not found.");
            }
        }

    }
}
