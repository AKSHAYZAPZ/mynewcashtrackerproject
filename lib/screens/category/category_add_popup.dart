import 'package:flutter/material.dart';
import 'package:my_cashtracker_app/db/category/category_db.dart';
import 'package:my_cashtracker_app/models/category/category_model.dart';

ValueNotifier<CategoryList> selectedCategoryNotifier =
    ValueNotifier(CategoryList.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _categoryEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _categoryEditingController,
              decoration: InputDecoration(
                hintText: 'Category Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                RadioButton(title: 'Income', type: CategoryList.income),
                RadioButton(title: 'Expense', type: CategoryList.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _categoryEditingController.text;

                if (_name == null) {
                  return;
                }
                final _category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  list: selectedCategoryNotifier.value,
                );
                CategoryDB().insertCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryList type;
  const RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryList newCategory, Widget? _) {
            return Radio<CategoryList>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
