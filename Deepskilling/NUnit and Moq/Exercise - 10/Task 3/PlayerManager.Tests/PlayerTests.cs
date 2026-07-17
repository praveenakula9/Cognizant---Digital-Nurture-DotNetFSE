using Moq;
using NUnit.Framework;
using PlayersManagerLib;

namespace PlayersManagerLib.Tests
{
    [TestFixture]
    public class PlayerTests
    {
        private Mock<IPlayerMapper> _mockPlayerMapper;

        [OneTimeSetUp]
        public void Setup()
        {
            _mockPlayerMapper = new Mock<IPlayerMapper>();
        }

        [TestCase]
        public void RegisterNewPlayer_ReturnsPlayer()
        {
            _mockPlayerMapper
                .Setup(x => x.IsPlayerNameExistsInDb(It.IsAny<string>()))
                .Returns(false);

            Player player = Player.RegisterNewPlayer("Virat", _mockPlayerMapper.Object);

            Assert.That(player.Name, Is.EqualTo("Virat"));
            Assert.That(player.Age, Is.EqualTo(23));
            Assert.That(player.Country, Is.EqualTo("India"));
            Assert.That(player.NoOfMatches, Is.EqualTo(30));
        }
    }
}