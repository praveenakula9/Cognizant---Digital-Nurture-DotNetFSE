using NUnit.Framework;
using CollectionsLib;
using System.Collections.Generic;
using System.Linq;

namespace CollectionsLib.Tests
{
    [TestFixture]
    public class EmployeeManagerTests
    {
        private EmployeeManager _manager;
        private List<Employee> _employees;

        [SetUp]
        public void SetUp()
        {
            _manager = new EmployeeManager();
            _employees = _manager.GetEmployees();
        }

        [Test]
        public void GetEmployees_WhenCalled_CollectionHasNoNullItems()
        {
            Assert.That(_employees.All(e => e != null), Is.True);
        }

        [Test]
        public void GetEmployees_WhenCalled_ContainsEmployeeWithId100()
        {
            var emp100 = _employees.FirstOrDefault(e => e.EmpId == 100);
            Assert.That(emp100, Is.Not.Null);
        }

        [Test]
        public void GetEmployees_WhenCalled_ReturnsOnlyUniqueEmployees()
        {
            Assert.That(_employees.Distinct().Count(), Is.EqualTo(_employees.Count));
        }

        [Test]
        public void GetEmployeesWhoJoinedInPreviousYears_MatchesGetEmployees()
        {
            var previous = _manager.GetEmployeesWhoJoinedInPreviousYears();
            Assert.That(previous, Is.EquivalentTo(_employees));
        }
    }
}