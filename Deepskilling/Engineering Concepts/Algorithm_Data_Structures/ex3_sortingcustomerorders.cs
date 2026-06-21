using System;

class Order
{
    public int OrderId;
    public string CustomerName;
    public double TotalPrice;

    public Order(int id, string name, double price)
    {
        OrderId = id;
        CustomerName = name;
        TotalPrice = price;
    }
}

class Program
{
    static void BubbleSort(Order[] orders)
    {
        int n = orders.Length;

        for (int i = 0; i < n - 1; i++)
        {
            for (int j = 0; j < n - i - 1; j++)
            {
                if (orders[j].TotalPrice > orders[j + 1].TotalPrice)
                {
                    Order temp = orders[j];
                    orders[j] = orders[j + 1];
                    orders[j + 1] = temp;
                }
            }
        }
    }

    static int Partition(Order[] orders, int low, int high)
    {
        double pivot = orders[high].TotalPrice;
        int i = low - 1;

        for (int j = low; j < high; j++)
        {
            if (orders[j].TotalPrice < pivot)
            {
                i++;

                Order temp = orders[i];
                orders[i] = orders[j];
                orders[j] = temp;
            }
        }

        Order temp1 = orders[i + 1];
        orders[i + 1] = orders[high];
        orders[high] = temp1;

        return i + 1;
    }

    static void QuickSort(Order[] orders, int low, int high)
    {
        if (low < high)
        {
            int pi = Partition(orders, low, high);

            QuickSort(orders, low, pi - 1);
            QuickSort(orders, pi + 1, high);
        }
    }

    static void Display(Order[] orders)
    {
        foreach (Order o in orders)
        {
            Console.WriteLine(
                o.OrderId + " " +
                o.CustomerName + " " +
                o.TotalPrice);
        }
    }

    static void Main()
    {
        Order[] orders =
        {
            new Order(1,"Praveen",250),
            new Order(2,"Kumar",100),
            new Order(3,"Pawan Kalyan",555),
            new Order(4,"Nageswara Rao",400),
            new Order(5,"Padma",320)
        };

        Order[] quickOrders = (Order[])orders.Clone();

        Console.WriteLine("Before Sorting:");
        Display(orders);

        BubbleSort(orders);

        Console.WriteLine("\nAfter Bubble Sort:");
        Display(orders);

        QuickSort(quickOrders, 0, quickOrders.Length - 1);

        Console.WriteLine("\nAfter Quick Sort:");
        Display(quickOrders);
    }
}

// Time Complexity Analysis

// Bubble sort - O(n)
// Quick sort - O(nlogn)