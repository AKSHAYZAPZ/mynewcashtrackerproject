import 'package:flutter/material.dart';
import 'package:my_cashtracker_app/screens/home/screen_home.dart';

class MoneymanagementBottomNavigation extends StatelessWidget {
  const MoneymanagementBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndexNotifier,
        builder: (BuildContext ctx, int selecteindex, Widget? _) {
          return BottomNavigationBar(
            currentIndex: selecteindex,
            onTap: (newindex) {
              ScreenHome.selectedIndexNotifier.value = newindex;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
            ],
          );
        });
  }
}
