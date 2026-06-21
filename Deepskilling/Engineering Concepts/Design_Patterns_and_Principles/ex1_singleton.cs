using System;
#nullable disable
class Logger
{
    private static Logger instance;

    private Logger()
    {
        Console.WriteLine("Logger Created");
    }

    public static Logger GetInstance()
    {
        if (instance == null)
        {
            instance = new Logger();
        }

        return instance;
    }

    public void Log(string message)
    {
        Console.WriteLine(message);
    }
}

class Program
{
    static void Main()
    {
        Logger logger1 = Logger.GetInstance();
        logger1.Log("Application Started");

        Logger logger2 = Logger.GetInstance();
        logger2.Log("Processing Request");

        Console.WriteLine(
            "Same Instance: " +
            Object.ReferenceEquals(logger1, logger2));
    }
}