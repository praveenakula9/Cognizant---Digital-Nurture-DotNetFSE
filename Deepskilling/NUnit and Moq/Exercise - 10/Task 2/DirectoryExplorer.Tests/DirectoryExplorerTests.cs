using System.Collections.Generic;
using Moq;
using NUnit.Framework;
using MagicFilesLib;

namespace MagicFilesLib.Tests
{
    [TestFixture]
    public class DirectoryExplorerTests
    {
        private Mock<IDirectoryExplorer> _mockDirectoryExplorer;

        private readonly string _file1 = "file.txt";
        private readonly string _file2 = "file2.txt";

        [OneTimeSetUp]
        public void Setup()
        {
            _mockDirectoryExplorer = new Mock<IDirectoryExplorer>();
        }

        [TestCase]
        public void GetFiles_ReturnsFiles()
        {
            _mockDirectoryExplorer
                .Setup(x => x.GetFiles(It.IsAny<string>()))
                .Returns(new List<string>
                {
                    _file1,
                    _file2
                });

            var files = _mockDirectoryExplorer.Object.GetFiles("C:\\");

            Assert.That(files, Is.Not.Null);
            Assert.That(files.Count, Is.EqualTo(2));
            Assert.That(files, Does.Contain(_file1));
        }
    }
}