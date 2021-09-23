import 'package:volt_arena/consts/my_icons.dart';
import 'package:volt_arena/search.dart';
import 'package:volt_arena/user_info.dart';
import 'package:flutter/material.dart';
import 'cart/cart.dart';
import 'feeds.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  late List pages;
  @override
  void initState() {
    pages = [
      Feeds(),
      Search(),
      MyBookingsScreen(),
      UserInfo(),
    ];
    // _pages = [
    //   {
    //     'page': Home(),
    //   },
    //   {
    //     'page': Feeds(),
    //   },
    //   {
    //     'page': Search(),
    //   },
    //   {
    //     'page': CartScreen(),
    //   },
    //   {
    //     'page': UserInfo(),
    //   },
    // ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: Colors.deepOrange,
              currentIndex: _selectedPageIndex,
              // selectedLabelStyle: TextStyle(fontSize: 16),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.room_service), label: 'Services'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyAppIcons.search,
                    ),
                    label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyAppIcons.bag,
                    ),
                    label: 'My Bookings'),
                BottomNavigationBarItem(
                    icon: Icon(MyAppIcons.user), label: 'User'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
