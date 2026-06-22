using System;
#nullable disable
interface IImage
{
    void Display();
}

class RealImage : IImage
{
    private string fileName;

    public RealImage(string fileName)
    {
        this.fileName = fileName;
        Console.WriteLine("Loading Image: " + fileName);
    }

    public void Display()
    {
        Console.WriteLine("Displaying Image: " + fileName);
    }
}

class ProxyImage : IImage
{
    private string fileName;
    private RealImage realImage;

    public ProxyImage(string fileName)
    {
        this.fileName = fileName;
    }

    public void Display()
    {
        if (realImage == null)
        {
            realImage = new RealImage(fileName);
        }

        realImage.Display();
    }
}

class Program
{
    static void Main()
    {
        IImage image = new ProxyImage("photo.jpg");

        Console.WriteLine("First Call:");
        image.Display();

        Console.WriteLine();

        Console.WriteLine("Second Call:");
        image.Display();
    }
}