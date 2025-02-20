import 'package:flutter/material.dart';
import 'map.dart';
import 'account.dart';
import 'booking.dart';
import 'expence.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    BookingScreen(),
    ExpensesScreen(),
    MapScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFFACE7C0).withOpacity(0.3),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bottomNavigation/Home_icon.png',
                color: _selectedIndex == 0
                    ? Colors.black
                    : const Color.fromARGB(255, 109, 109, 109),
                width: 24,
                height: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bottomNavigation/booking_icon.png',
                color: _selectedIndex == 1
                    ? Colors.black
                    : const Color.fromARGB(255, 109, 109, 109),
                width: 24,
                height: 24,
              ),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bottomNavigation/expenses_icon.png',
                color: _selectedIndex == 2
                    ? Colors.black
                    : const Color.fromARGB(255, 109, 109, 109),
                width: 24,
                height: 24,
              ),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bottomNavigation/map_icon.png',
                color: _selectedIndex == 3
                    ? Colors.black
                    : const Color.fromARGB(255, 109, 109, 109),
                width: 24,
                height: 24,
              ),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bottomNavigation/account_icon.png',
                color: _selectedIndex == 4 ? Colors.black : Colors.grey,
                width: 24,
                height: 24,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
