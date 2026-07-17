using NUnit.Framework;
using ConverterLib;
using CurrencyConverterApp;
using Moq;

namespace ConverterLib.Tests
{
    [TestFixture]
    public class ConverterTests
    {
        private Mock<IDollarToEuroExchangeRateFeed> _mockExchangeRateFeed;
        private Converter _converter;

        [SetUp]
        public void SetUp()
        {
            _mockExchangeRateFeed = new Mock<IDollarToEuroExchangeRateFeed>();
            _converter = new Converter(_mockExchangeRateFeed.Object);
        }

        [Test]
        public void USDToEuro_GivenDollarAmount_ReturnsCorrectEuroAmount()
        {
            _mockExchangeRateFeed
                .Setup(feed => feed.GetActualUSDollarValue())
                .Returns(0.85);

            double actual = _converter.USDToEuro(100);

            Assert.That(actual, Is.EqualTo(85));
        }

        [Test]
        public void USDToEuro_ZeroDollars_ReturnsZeroEuros()
        {
            _mockExchangeRateFeed
                .Setup(feed => feed.GetActualUSDollarValue())
                .Returns(0.85);

            double actual = _converter.USDToEuro(0);

            Assert.That(actual, Is.EqualTo(0));
        }

        [TestCase(0, 273.15)]
        [TestCase(100, 373.15)]
        public void CelsiusToKelvin_ValidTemperature_ReturnsCorrectKelvin(
            double celsius, double expectedKelvin)
        {
            double actual = _converter.CelsiusToKelvin(celsius);
            Assert.That(actual, Is.EqualTo(expectedKelvin).Within(0.001));
        }

        [TestCase(1, 2.205)]
        [TestCase(10, 22.05)]
        public void KilogramToPound_ValidWeight_ReturnsCorrectPounds(
            double kg, double expectedPounds)
        {
            double actual = _converter.KilogramToPound(kg);
            Assert.That(actual, Is.EqualTo(expectedPounds).Within(0.001));
        }
    }
}
