using NUnit.Framework;
using UtilLib;
using System;

namespace UtilLib.Tests
{
    [TestFixture]
    public class UrlHostNameParserTests
    {
        private UrlHostNameParser _parser;

        [SetUp]
        public void SetUp()
        {
            _parser = new UrlHostNameParser();
        }

        [Test]
        public void ParseHostName_ValidHttpUrl_ReturnsHostName()
        {
            string url = "http://www.google.com/search?q=nunit";
            string actual = _parser.ParseHostName(url);
            Assert.That(actual, Is.EqualTo("www.google.com"));
        }

        [Test]
        public void ParseHostName_ValidHttpsUrl_ReturnsHostName()
        {
            string url = "https://www.example.com/page";
            string actual = _parser.ParseHostName(url);
            Assert.That(actual, Is.EqualTo("www.example.com"));
        }

        [Test]
        public void ParseHostName_InvalidProtocol_ThrowsFormatException()
        {
            string url = "ftp://files.example.com/data";

            Assert.That(
                () => _parser.ParseHostName(url),
                Throws.TypeOf<FormatException>()
            );
        }
    }
}