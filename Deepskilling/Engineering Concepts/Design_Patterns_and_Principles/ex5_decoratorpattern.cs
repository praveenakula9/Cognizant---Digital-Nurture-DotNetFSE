using System;

interface INotifier
{
    void Send(string message);
}

class EmailNotifier : INotifier
{
    public void Send(string message)
    {
        Console.WriteLine("Email: " + message);
    }
}

class SMSNotifier : INotifier
{
    private INotifier notifier;

    public SMSNotifier(INotifier notifier)
    {
        this.notifier = notifier;
    }

    public void Send(string message)
    {
        notifier.Send(message);
        Console.WriteLine("SMS: " + message);
    }
}

class SlackNotifier : INotifier
{
    private INotifier notifier;

    public SlackNotifier(INotifier notifier)
    {
        this.notifier = notifier;
    }

    public void Send(string message)
    {
        notifier.Send(message);
        Console.WriteLine("Slack: " + message);
    }
}

class Program
{
    static void Main()
    {
        INotifier notifier = new EmailNotifier();

        notifier = new SMSNotifier(notifier);
        notifier = new SlackNotifier(notifier);

        notifier.Send("Your order has shipped!");
    }
}