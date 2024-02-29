using System;

namespace PharoUtils
{
    public class Association<TKey, TValue>
    {
        protected TKey key;
        protected TValue value;

        public Association(TKey key, TValue value)
        {
            this.key = key;
            this.value = value;
        }

        public TKey Key()
        {
            return key;
        }

        public void Key(TKey newVal)
        {
            key = newVal;
        }

        public TValue Value()
        {
            return value;
        }

        public void Value(TValue newVal)
        {
            value = newVal;
        }
    }
}
