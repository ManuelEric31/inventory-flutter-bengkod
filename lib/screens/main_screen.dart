import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inventory_management/screens/add_item_screen.dart';
import 'package:inventory_management/screens/home_screen.dart';
import 'package:inventory_management/widgets/dialogs/custom_video_dialog.dart';

class MainScreeen extends StatefulWidget {
  const MainScreeen({super.key});

  @override
  State<MainScreeen> createState() => _MainScreeenState();
}

class _MainScreeenState extends State<MainScreeen> {
  int _selectedNavbarIndex = 0;

  void _onTabChange(int index) {
    if (index == 2 || index == 3) {
      showCustomLottieDialog(context);
    }
    setState(() {
      _selectedNavbarIndex = index;
    });
  }

  Widget _getSelectedView() {
    switch (_selectedNavbarIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const AddItemScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedView(),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.white,
        activeColor: const Color.fromARGB(255, 0, 28, 53),
        tabBackgroundColor: const Color.fromARGB(52, 3, 44, 149),
        gap: 8,
        selectedIndex: _selectedNavbarIndex,
        onTabChange: _onTabChange,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.add,
            text: 'Add Item',
          ),
          GButton(
            icon: Icons.history,
            text: 'History',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
