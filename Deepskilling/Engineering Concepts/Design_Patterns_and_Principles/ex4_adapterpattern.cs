using System;
#nullable disable
interface IPaymentProcessor
{
    void ProcessPayment(double amount);
}

class PhonepeGateway
{
    public void MakePayment(double amount)
    {
        Console.WriteLine("Payment done using Phonepe: $" + amount);
    }
}

class PaytmGateway
{
    public void SendPayment(double amount)
    {
        Console.WriteLine("Payment done using Paytm: $" + amount);
    }
}

class PhonepeAdapter : IPaymentProcessor
{
    private PhonepeGateway phonepe = new PhonepeGateway();

    public void ProcessPayment(double amount)
    {
        phonepe.MakePayment(amount);
    }
}

class PaytmAdapter : IPaymentProcessor
{
    private PaytmGateway paytm = new PaytmGateway();

    public void ProcessPayment(double amount)
    {
        paytm.SendPayment(amount);
    }
}

class Program
{
    static void Main()
    {
        IPaymentProcessor phonepe =
            new PhonepeAdapter();

        phonepe.ProcessPayment(500);

        IPaymentProcessor paytm =
            new PaytmAdapter();

        paytm.ProcessPayment(1000);
    }
}