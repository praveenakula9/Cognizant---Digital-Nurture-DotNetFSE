using System;

class Program
{
    static double PredictFutureValue(double amount, double growthRate, int years)
    {
        if (years == 0)
        {
            return amount;
        }

        return PredictFutureValue(amount, growthRate, years - 1)
               * (1 + growthRate);
    }

    static void Main()
    {
        double currentRevenue = 100000;
        double growthRate = 0.12;
        int years = 5;

        double futureValue =
            PredictFutureValue(currentRevenue, growthRate, years);

        Console.WriteLine("Future Value after "
                          + years + " years = "
                          + futureValue);
    }
}

// Time Complexity Analysis

// TC - O(n)
// SC - O(n) - recursive stack