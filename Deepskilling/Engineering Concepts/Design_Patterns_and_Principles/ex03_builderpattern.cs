using System;
#nullable disable
class Computer
{
    public string CPU;
    public string RAM;
    public string Storage;
    public string GPU;

    public void ShowDetails()
    {
        Console.WriteLine("CPU: " + CPU);
        Console.WriteLine("RAM: " + RAM);
        Console.WriteLine("Storage: " + Storage);
        Console.WriteLine("GPU: " + GPU);
        Console.WriteLine();
    }
}

class ComputerBuilder
{
    private Computer computer = new Computer();

    public void SetCPU(string cpu)
    {
        computer.CPU = cpu;
    }

    public void SetRAM(string ram)
    {
        computer.RAM = ram;
    }

    public void SetStorage(string storage)
    {
        computer.Storage = storage;
    }

    public void SetGPU(string gpu)
    {
        computer.GPU = gpu;
    }

    public Computer GetComputer()
    {
        return computer;
    }
}

class Program
{
    static void Main()
    {
        ComputerBuilder builder = new ComputerBuilder();

        builder.SetCPU("Intel i5");
        builder.SetRAM("8GB");
        builder.SetStorage("512GB SSD");
        builder.SetGPU("Integrated");

        Computer officePC = builder.GetComputer();

        Console.WriteLine("Office PC");
        officePC.ShowDetails();

        builder = new ComputerBuilder();

        builder.SetCPU("Intel i9");
        builder.SetRAM("32GB");
        builder.SetStorage("2TB SSD");
        builder.SetGPU("RTX 4080");

        Computer gamingPC = builder.GetComputer();

        Console.WriteLine("Gaming PC");
        gamingPC.ShowDetails();
    }
}