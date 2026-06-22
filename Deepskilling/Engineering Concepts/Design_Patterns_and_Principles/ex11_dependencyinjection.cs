using System;

interface ICustomerRepository
{
    string GetCustomer();
}

class CustomerRepository : ICustomerRepository
{
    public string GetCustomer()
    {
        return "Praveen Kumar";
    }
}

class CustomerService
{
    private ICustomerRepository repository;

    public CustomerService(ICustomerRepository repository)
    {
        this.repository = repository;
    }

    public void DisplayCustomer()
    {
        Console.WriteLine(repository.GetCustomer());
    }
}

class Program
{
    static void Main()
    {
        ICustomerRepository repo =
            new CustomerRepository();

        CustomerService service =
            new CustomerService(repo);

        service.DisplayCustomer();
    }
}