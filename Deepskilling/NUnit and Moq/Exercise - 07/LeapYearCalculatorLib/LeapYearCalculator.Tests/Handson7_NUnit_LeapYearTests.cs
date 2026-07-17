using NUnit.Framework;
using LeapYearCalculatorLib;

namespace LeapYearCalculatorLib.Tests
{
    [TestFixture]
    public class LeapYearCalculatorTests
    {
        private LeapYearCalculator _calculator;

        [SetUp]
        public void SetUp()
        {
            _calculator = new LeapYearCalculator();
        }

        [TestCase(2000, 1)]
        [TestCase(2024, 1)]
        [TestCase(1756, 1)]
        public void IsLeapYear_LeapYear_ReturnsOne(int year, int expected)
        {
            int actual = _calculator.IsLeapYear(year);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(1900, 0)]
        [TestCase(2023, 0)]
        [TestCase(2019, 0)]
        public void IsLeapYear_NonLeapYear_ReturnsZero(int year, int expected)
        {
            int actual = _calculator.IsLeapYear(year);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(1752, -1)]
        [TestCase(10000, -1)]
        [TestCase(0, -1)]
        public void IsLeapYear_OutOfRange_ReturnsMinusOne(int year, int expected)
        {
            int actual = _calculator.IsLeapYear(year);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(1753, 0)]
        [TestCase(9999, 0)]
        public void IsLeapYear_BoundaryValues_ReturnsCorrectResult(int year, int expected)
        {
            int actual = _calculator.IsLeapYear(year);
            Assert.That(actual, Is.EqualTo(expected));
        }
    }
}
