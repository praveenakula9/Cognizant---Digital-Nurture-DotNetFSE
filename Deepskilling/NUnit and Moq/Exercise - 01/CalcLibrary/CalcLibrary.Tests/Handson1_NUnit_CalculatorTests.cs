using NUnit.Framework;
using CalcLibrary;

namespace CalcLibrary.Tests
{
    [TestFixture]
    public class CalculatorTests
    {
        private SimpleCalculator _calculator;

        [SetUp]
        public void SetUp()
        {
            _calculator = new SimpleCalculator();
        }

        [TearDown]
        public void TearDown()
        {
            _calculator = null;
        }

        [TestCase(10, 5, 15)]
        [TestCase(0, 0, 0)]
        [TestCase(-3, 7, 4)]
        public void Addition_ValidNumbers_ReturnsCorrectSum(double a, double b, double expected)
        {
            double actual = _calculator.Addition(a, b);
            Assert.That(actual, Is.EqualTo(expected));
        }
    }
}
