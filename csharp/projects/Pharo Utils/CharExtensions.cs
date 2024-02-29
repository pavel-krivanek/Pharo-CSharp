using System;

public static class CharExtensions
{
    public static bool IsDigit(this char c)
    {
        return char.IsDigit(c);
    }

    // Extension method to convert a char to its integer value
    public static int AsInteger(this char c)
    {
        if (char.IsDigit(c))
        {
            // Convert digit char to its numeric value
            return c - '0';
        }
        else
        {
            throw new ArgumentException("The character is not a digit.");
        }
    }
}