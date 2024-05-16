using DesktopApp.Models;

namespace DesktopApp.Repositories
{
    public class MockAppRepository
    {
        public MockAppRepository()
        {
            cities =
            [
                new City { Name = "Нижний Новгород" },
                new City { Name = "Липецк" },
            ];

            workshops =
            [
                new Workshop { Name = "Цех 1", City = cities[0] },
                new Workshop { Name = "Цех 2", City = cities[0] },
                new Workshop { Name = "Цех 3", City = cities[1] },
            ];

            staff =
            [
                new Employee { FullName = "Иванов Иванов Иванович", Workshop = workshops[0] },
                new Employee { FullName = "Петров Иванов Иванович", Workshop = workshops[1] },
                new Employee { FullName = "Николаев Иванов Иванович", Workshop = workshops[1] },
                new Employee { FullName = "Карасёв Иванов Иванович", Workshop = workshops[2] },
                new Employee { FullName = "Карпов Иванов Иванович", Workshop = workshops[2] },
            ];
        }

        private readonly List<City> cities;
        private readonly List<Workshop> workshops;
        private readonly List<Employee> staff;

        public IReadOnlyList<City> GetCities() => cities;
        public IReadOnlyList<Workshop> GetWorkshops() => workshops;
        public IReadOnlyList<Employee> GetStaff() => staff;
    }
}
