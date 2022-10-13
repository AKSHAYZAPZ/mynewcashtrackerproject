import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:my_cashtracker_app/db/transaction/transaction_db.dart';
import 'package:my_cashtracker_app/models/category/category_model.dart';

import '../../models/transactions/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 55, 55),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder:
              (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final _list = newlist[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    key: Key(_list.id!),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            TransactionDB.instance.deleteTransaction(_list.id!);
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      color: const Color.fromARGB(255, 68, 65, 65),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _list.type == CategoryList.income
                              ? Colors.green
                              : Colors.red,
                          radius: 50,
                          child: Center(
                            child: Text(
                              parseDate(_list.date),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        title: Text('Rs. ${_list.amount}'),
                        subtitle: Text(_list.pupose),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newlist.length,
            );
          },
        ),
      ),
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';

    // '${date.day}\n${date.month}';
  }
}
