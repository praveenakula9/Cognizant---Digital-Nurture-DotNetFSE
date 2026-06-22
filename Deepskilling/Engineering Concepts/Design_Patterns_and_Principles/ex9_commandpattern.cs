using System;

class Light
{
    public void On()
    {
        Console.WriteLine("Light ON");
    }

    public void Off()
    {
        Console.WriteLine("Light OFF");
    }
}

interface ICommand
{
    void Execute();
}

class LightOnCommand : ICommand
{
    private Light light;

    public LightOnCommand(Light light)
    {
        this.light = light;
    }

    public void Execute()
    {
        light.On();
    }
}

class LightOffCommand : ICommand
{
    private Light light;

    public LightOffCommand(Light light)
    {
        this.light = light;
    }

    public void Execute()
    {
        light.Off();
    }
}

class RemoteControl
{
    public void PressButton(ICommand command)
    {
        command.Execute();
    }
}

class Program
{
    static void Main()
    {
        Light light = new Light();

        ICommand onCommand =
            new LightOnCommand(light);

        ICommand offCommand =
            new LightOffCommand(light);

        RemoteControl remote =
            new RemoteControl();

        remote.PressButton(onCommand);

        remote.PressButton(offCommand);
    }
}