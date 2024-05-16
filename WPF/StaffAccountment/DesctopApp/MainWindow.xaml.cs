using DesktopApp.Models;
using DesktopApp.Repositories;
using System.Windows;
using System.Windows.Controls;

namespace DesktopApp
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            LoadData();
            citiesList.ItemsSource = cities;
            worshopsList.ItemsSource = workshops;
            staffList.ItemsSource = staff;
        }

        private IEnumerable<City> cities;
        private IEnumerable<Workshop> workshops;
        private IEnumerable<Employee> staff;

        private void CitiesList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (((ComboBox)sender).SelectedItem is City city)
            {
                var cityWorkshops = workshops.Where(w => w.City == city);
                worshopsList.ItemsSource = cityWorkshops;
                staffList.ItemsSource = staff.Where(e => cityWorkshops.Any(w => w == e.Workshop));
            }
        }

        private void WorshopsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (((ComboBox)sender).SelectedItem is Workshop workshop)
            {
                staffList.ItemsSource = staff.Where(e => e.Workshop == workshop);
            }
        }

        private void LoadData()
        {
            var repository = new MockAppRepository();
            cities = repository.GetCities();
            workshops = repository.GetWorkshops();
            staff = repository.GetStaff();
        }
    }
}