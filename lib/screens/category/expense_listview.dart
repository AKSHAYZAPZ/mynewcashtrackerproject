import 'package:flutter/material.dart';
import 'package:my_cashtracker_app/db/category/category_db.dart';

import '../../models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final category = newlist[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0,
                color: const Color.fromARGB(255, 68, 65, 65),
                child: ListTile(
                  title: Text(
                   category.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                       CategoryDB().deleteCategory(category.id);
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 2,
            );
          },
          itemCount: newlist.length,
        );
      },
    );
  }
}
