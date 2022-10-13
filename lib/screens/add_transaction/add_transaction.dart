// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_cashtracker_app/db/category/category_db.dart';
import 'package:my_cashtracker_app/db/transaction/transaction_db.dart';
import 'package:my_cashtracker_app/models/category/category_model.dart';
import 'package:my_cashtracker_app/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routname = 'screen-addtransaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  final _puposeController = TextEditingController();

  final _amountController = TextEditingController();

 final String  _timelabel = 'Select a Date';

  String? _categoryId;

  DateTime? _selectedDate;
  CategoryList? _selectedCategoryValue;
  CategoryModel? _selectedCategoryModel;

  @override
  void initState() {
    _selectedCategoryValue = CategoryList.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------//pupose----------------
              TextFormField(
                maxLength: 25,
                controller: _puposeController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Purpose',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
//------------ // Amount  -----------
              TextFormField(
                keyboardType:TextInputType.number ,
                controller: _amountController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Amount',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
//------------ // date time -----------
              TextButton.icon(
                onPressed: () async {
                  final _selectDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 90)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectDateTemp == null) {
                    return;
                  }
                  setState(() {
                    _selectedDate = _selectDateTemp;
                  });
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(_selectedDate == null
                    ? _timelabel
                    : _selectedDate.toString()),
              ),

              // ------------Income or expense--------------

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryList.income,
                        groupValue: _selectedCategoryValue,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryValue = CategoryList.income;
                            _categoryId = null;
                          });
                        },
                      ),
                      const Text('Income')
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryList.expense,
                        groupValue: _selectedCategoryValue,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryValue = CategoryList.expense;
                            _categoryId = null;
                          });
                        },
                      ),
                      const Text('Expense')
                    ],
                  )
                ],
              ),
// -----------Category type -------------
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _categoryId,
                items: (_selectedCategoryValue == CategoryList.income
                        ? CategoryDB().incomeCategoryListListener
                        : CategoryDB().expenseCategoryListListener)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                    value: e.id,
                    child: Text(e.name),
                  );
                }).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _categoryId = selectedValue;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _puposeController.text;
    final _amoutText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amoutText.isEmpty) {
      return;
    }
    if (_categoryId == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    // selctedCategoryType

    final _parsedAmount = double.tryParse(_amoutText);
    if(_parsedAmount ==null){
      return;
    }

  final _model=  TransactionModel(
      pupose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryValue!,
      category: _selectedCategoryModel!,
    );
   await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();

  }
}
