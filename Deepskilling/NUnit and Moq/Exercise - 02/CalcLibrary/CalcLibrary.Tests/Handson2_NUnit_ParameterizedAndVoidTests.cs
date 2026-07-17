using NUnit.Framework;
using CalcLibrary;
using System;

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

        [TestCase(10, 3, 7)]
        [TestCase(5, 5, 0)]
        [TestCase(0, 5, -5)]
        public void Subtraction_ValidNumbers_ReturnsCorrectDifference(double a, double b, double expected)
        {
            double actual = _calculator.Subtraction(a, b);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(4, 3, 12)]
        [TestCase(0, 100, 0)]
        [TestCase(-2, 5, -10)]
        public void Multiplication_ValidNumbers_ReturnsCorrectProduct(double a, double b, double expected)
        {
            double actual = _calculator.Multiplication(a, b);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(10, 2, 5)]
        [TestCase(9, 3, 3)]
        public void Division_ValidNumbers_ReturnsCorrectQuotient(double a, double b, double expected)
        {
            double actual = _calculator.Division(a, b);
            Assert.That(actual, Is.EqualTo(expected));
        }

        [TestCase(10, 0)]
        public void Division_DivisorIsZero_ThrowsArgumentException(double a, double b)
        {
            try
            {
                _calculator.Division(a, b);
                Assert.Fail("Division by zero");
            }
            catch (ArgumentException)
            {
            }
        }

        [Test]
        public void AllClear_AfterAddition_ResultBecomesZero()
        {
            _calculator.Addition(10, 5);
            Assert.That(_calculator.GetResult, Is.EqualTo(15));

            _calculator.AllClear();

            Assert.That(_calculator.GetResult, Is.EqualTo(0));
        }
    }
}
