import 'package:flutter/material.dart';
import 'package:my_cashtracker_app/db/category/category_db.dart';
import 'package:my_cashtracker_app/screens/add_transaction/add_transaction.dart';
import 'package:my_cashtracker_app/screens/category/category_add_popup.dart';
import 'package:my_cashtracker_app/screens/category/screen_category.dart';
import 'package:my_cashtracker_app/screens/home/widgets/bottom_navigation.dart';
import 'package:my_cashtracker_app/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUi();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 55, 55),
      appBar: AppBar(
        title: const Center(
          child: Text('My Cash Tracker'),
        ),
      ),
      bottomNavigationBar: const MoneymanagementBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndexNotifier,
          builder: (BuildContext ctx, int updatedindex, Widget? _) {
            return _pages[updatedindex];
          },
          child: const Center(
            child: Text('Home'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routname);
          } else {
            showCategoryAddPopup(context);
          }
        },
      ),
    );
  }
}
