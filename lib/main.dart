import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_cashtracker_app/models/category/category_model.dart';
import 'package:my_cashtracker_app/models/transactions/transaction_model.dart';
import 'package:my_cashtracker_app/screens/add_transaction/add_transaction.dart';
import 'package:my_cashtracker_app/screens/home/screen_home.dart';

Future<void> main(List<String> args)async{
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
  Hive.registerAdapter(CategoryModelAdapter());
}
if(!Hive.isAdapterRegistered(CategoryListAdapter().typeId)){
  Hive.registerAdapter(CategoryListAdapter());
}
if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
  Hive.registerAdapter(TransactionModelAdapter());
}


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home:const ScreenHome() ,
      routes: {
        ScreenAddTransaction.routname: (context) =>  const ScreenAddTransaction()
        
      },
    );
  }
}