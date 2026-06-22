using System;
using System.Collections.Generic;

interface IObserver
{
    void Update(string stockName, double price);
}

class MobileApp : IObserver
{
    public void Update(string stockName, double price)
    {
        Console.WriteLine("Mobile App: " +
                          stockName + " = " + price);
    }
}

class WebApp : IObserver
{
    public void Update(string stockName, double price)
    {
        Console.WriteLine("Web App: " +
                          stockName + " = " + price);
    }
}

class StockMarket
{
    private List<IObserver> observers =
        new List<IObserver>();

    public void Register(IObserver observer)
    {
        observers.Add(observer);
    }

    public void Remove(IObserver observer)
    {
        observers.Remove(observer);
    }

    public void SetPrice(string stockName, double price)
    {
        foreach (IObserver observer in observers)
        {
            observer.Update(stockName, price);
        }
    }
}

class Program
{
    static void Main()
    {
        StockMarket stockMarket =
            new StockMarket();

        MobileApp mobile =
            new MobileApp();

        WebApp web =
            new WebApp();

        stockMarket.Register(mobile);
        stockMarket.Register(web);

        Console.WriteLine("Price Update 1");
        stockMarket.SetPrice("AAPL", 192.35);

        Console.WriteLine();

        stockMarket.Remove(web);

        Console.WriteLine("Price Update 2");
        stockMarket.SetPrice("AAPL", 194.10);
    }
}