using System;
#nullable disable
interface IPayment
{
    void Pay(double amount);
}

class CreditCardPayment : IPayment
{
    public void Pay(double amount)
    {
        Console.WriteLine("Paid Rs." + amount +
                          " using Credit Card");
    }
}

class PayPalPayment : IPayment
{
    public void Pay(double amount)
    {
        Console.WriteLine("Paid Rs." + amount +
                          " using PayPal");
    }
}

class PaymentContext
{
    private IPayment paymentMethod;

    public void SetPaymentMethod(IPayment payment)
    {
        paymentMethod = payment;
    }

    public void MakePayment(double amount)
    {
        paymentMethod.Pay(amount);
    }
}

class Program
{
    static void Main()
    {
        PaymentContext context =
            new PaymentContext();

        context.SetPaymentMethod(
            new CreditCardPayment());

        context.MakePayment(1500);

        context.SetPaymentMethod(
            new PayPalPayment());

        context.MakePayment(2500);
    }
}