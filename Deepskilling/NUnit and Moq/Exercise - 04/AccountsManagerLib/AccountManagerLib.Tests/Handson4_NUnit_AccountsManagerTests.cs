using NUnit.Framework;
using AccountsManagerLib;
using System;

namespace AccountsManagerLib.Tests
{
    [TestFixture]
    public class AccountsManagerTests
    {
        private AccountsManager _accountsManager;

        [SetUp]
        public void SetUp()
        {
            _accountsManager = new AccountsManager();
        }

        [TestCase("user_11", "secret@user11", "Welcome user_11!!!")]
        [TestCase("user_22", "secret@user22", "Welcome user_22!!!")]
        public void ValidateUser_ValidCredentials_ReturnsWelcomeMessage(
            string userId, string password, string expectedMsg)
        {
            string actual = _accountsManager.ValidateUser(userId, password);
            Assert.That(actual, Is.EqualTo(expectedMsg));
        }

        [Test]
        public void ValidateUser_InvalidCredentials_ReturnsInvalidMessage()
        {
            string actual = _accountsManager.ValidateUser("wrong_user", "wrong_pass");
            Assert.That(actual, Is.EqualTo("Invalid user id/password"));
        }

        [Test]
        public void ValidateUser_EmptyUserId_ThrowsFormatException()
        {
            Assert.That(
                () => _accountsManager.ValidateUser("", "somepassword"),
                Throws.TypeOf<FormatException>()
            );
        }

        [Test]
        public void ValidateUser_EmptyPassword_ThrowsFormatException()
        {
            Assert.That(
                () => _accountsManager.ValidateUser("user_11", ""),
                Throws.TypeOf<FormatException>()
            );
        }
    }
}
