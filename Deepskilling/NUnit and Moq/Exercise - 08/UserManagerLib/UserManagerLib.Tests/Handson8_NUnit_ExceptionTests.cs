using NUnit.Framework;
using UserManagerLib;
using System;

namespace UserManagerLib.Tests
{
    [TestFixture]
    public class UserTests
    {
        private User _user;

        [SetUp]
        public void SetUp()
        {
            _user = new User();
        }

        [Test]
        public void ValidatePANCardNumber_ValidPan_ReturnsValid()
        {
            string result = _user.ValidatePANCardNumber("ABCDE1234F");
            Assert.That(result, Is.EqualTo("Valid"));
        }

        [TestCase(null)]
        [TestCase("")]
        public void ValidatePANCardNumber_NullOrEmpty_ThrowsNullReferenceException(string? panCard)
        {
            Assert.That(
                () => _user.ValidatePANCardNumber(panCard!),
                Throws.TypeOf<NullReferenceException>()
            );
        }

        [TestCase("ABC")]
        [TestCase("ABCDE1234FXYZ")]
        public void ValidatePANCardNumber_WrongLength_ThrowsFormatException(string panCard)
        {
            Assert.That(
                () => _user.ValidatePANCardNumber(panCard),
                Throws.TypeOf<FormatException>()
            );
        }

        [Test]
        public void CreateUser_ValidPanCard_DoesNotThrowException()
        {
            User userToCreate = new User
            {
                FirstName = "John",
                LastName = "Doe",
                EmailId = "john@example.com",
                PANCardNo = "ABCDE1234F"
            };

            Assert.That(() => _user.CreateUser(userToCreate), Throws.Nothing);
        }

        [Test]
        public void CreateUser_NullPanCard_ThrowsNullReferenceException()
        {
            User userToCreate = new User
            {
                FirstName = "Jane",
                LastName = "Doe",
                PANCardNo = null!
            };

            Assert.That(
                () => _user.CreateUser(userToCreate),
                Throws.TypeOf<NullReferenceException>()
            );
        }
    }
}