using System;
#nullable disable
interface IDocument
{
    void Open();
}

class WordDocument : IDocument
{
    public void Open()
    {
        Console.WriteLine("Opening Word Document");
    }
}

class PdfDocument : IDocument
{
    public void Open()
    {
        Console.WriteLine("Opening PDF Document");
    }
}

class ExcelDocument : IDocument
{
    public void Open()
    {
        Console.WriteLine("Opening Excel Document");
    }
}

class DocumentFactory
{
    public static IDocument CreateDocument(string type)
    {
        if (type == "Word")
            return new WordDocument();

        if (type == "PDF")
            return new PdfDocument();

        if (type == "Excel")
            return new ExcelDocument();

        return null;
    }
}

class Program
{
    static void Main()
    {
        IDocument doc1 = DocumentFactory.CreateDocument("Word");
        doc1.Open();

        IDocument doc2 = DocumentFactory.CreateDocument("PDF");
        doc2.Open();

        IDocument doc3 = DocumentFactory.CreateDocument("Excel");
        doc3.Open();
    }
}