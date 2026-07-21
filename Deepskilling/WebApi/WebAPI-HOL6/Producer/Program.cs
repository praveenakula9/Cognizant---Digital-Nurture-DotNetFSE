using Confluent.Kafka;

var config = new ProducerConfig
{
    BootstrapServers = "localhost:9092"
};

using var producer =
    new ProducerBuilder<Null, string>(config).Build();

Console.WriteLine("Kafka Producer Started");

while (true)
{
    Console.Write("Enter Message : ");

    string message = Console.ReadLine();

    producer.Produce(
        "chat-topic",
        new Message<Null, string>
        {
            Value = message
        });

    Console.WriteLine("Message Sent");
}