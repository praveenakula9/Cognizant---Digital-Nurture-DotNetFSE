using NUnit.Framework;
using SeasonsLib;
using System.Collections;

namespace FourSeasonsLib.Tests
{
    [TestFixture]
    public class SeasonTellerTests
    {
        private SeasonTeller _seasonTeller;

        [SetUp]
        public void SetUp()
        {
            _seasonTeller = new SeasonTeller();
        }

        private static readonly object[] SeasonTestData_Field =
        {
            new object[] { "February",  "Spring"  },
            new object[] { "March",     "Spring"  },
            new object[] { "April",     "Summer"  },
            new object[] { "May",       "Summer"  },
            new object[] { "June",      "Summer"  },
            new object[] { "July",      "Monsoon" },
            new object[] { "August",    "Monsoon" },
            new object[] { "September", "Monsoon" },
            new object[] { "October",   "Autumn"  },
            new object[] { "November",  "Autumn"  },
            new object[] { "December",  "Winter"  },
            new object[] { "January",   "Winter"  },
        };

        [TestCaseSource(nameof(SeasonTestData_Field))]
        public void DisplaySeasonBy_ValidMonth_ReturnsCorrectSeason_UsingField(
            string month, string expectedSeason)
        {
            string actual = _seasonTeller.DisplaySeasonBy(month);
            Assert.That(actual, Is.EqualTo(expectedSeason));
        }

        private static IEnumerable GetSeasonTestData_Method()
        {
            yield return new object[] { "February",  "Spring"  };
            yield return new object[] { "April",     "Summer"  };
            yield return new object[] { "July",      "Monsoon" };
            yield return new object[] { "October",   "Autumn"  };
            yield return new object[] { "December",  "Winter"  };
        }

        [TestCaseSource(nameof(GetSeasonTestData_Method))]
        public void DisplaySeasonBy_ValidMonth_ReturnsCorrectSeason_UsingMethod(
            string month, string expectedSeason)
        {
            string actual = _seasonTeller.DisplaySeasonBy(month);
            Assert.That(actual, Is.EqualTo(expectedSeason));
        }

        [Test]
        public void DisplaySeasonBy_InvalidMonth_ReturnsInvalidSeason()
        {
            string actual = _seasonTeller.DisplaySeasonBy("Blah");
            Assert.That(actual, Is.EqualTo("Invalid Season"));
        }
    }
}
