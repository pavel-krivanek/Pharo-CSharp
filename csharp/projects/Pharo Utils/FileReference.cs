using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Linq;
using Microsoft.VisualBasic;
using System.Text.RegularExpressions;

namespace PharoUtils;

public class FileReference
{
    public string FilePath { get; private set; }

    public FileReference(string filePath)
    {
        if (string.IsNullOrEmpty(filePath))
            throw new ArgumentException("filePath must not be null or empty", nameof(filePath));

        FilePath = filePath;
    }

    public FileReference()
    {
        FilePath = Environment.CurrentDirectory;
    }

    public FileReference Parent()
    {
        var directoryPath = Path.GetDirectoryName(FilePath);
        if (directoryPath == null)
            throw new InvalidOperationException("The file does not have a parent directory.");

        return new FileReference(directoryPath);
    }

    public FileStream WriteStreamEncoded(string encoding)
    {
        Encoding encoder = encoding.ToLower() switch
        {
            "utf8" => Encoding.UTF8,
            "ascii" => Encoding.ASCII,
            _ => throw new ArgumentException($"Unsupported encoding: {encoding}", nameof(encoding)),
        };

        // Ensure the directory exists before creating the file
        var directoryPath = Path.GetDirectoryName(FilePath);
        if (!string.IsNullOrEmpty(directoryPath) && !Directory.Exists(directoryPath))
        {
            Directory.CreateDirectory(directoryPath);
        }

        // Note: This opens or creates the file for writing with the specified encoding.
        // It's up to the caller to properly use the stream and dispose of it.
        return new FileStream(FilePath, FileMode.OpenOrCreate, FileAccess.Write);
    }

    public void EnsureCreateDirectory()
    {
        var directoryPath = Path.GetDirectoryName(FilePath);
        if (!string.IsNullOrEmpty(directoryPath))
        {
            Directory.CreateDirectory(directoryPath); // This will create the directory if it does not already exist
        }
    }

    public FileReference Slash(string addition)
    {
        var combinedPath = Path.Combine(FilePath, addition);
        return new FileReference(combinedPath);
    }
}