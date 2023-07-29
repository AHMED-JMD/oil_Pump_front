import 'package:flutter/material.dart';
import 'package:oil_pump_system/SharedService.dart';
import 'package:oil_pump_system/widgets/Daily.dart';
import 'package:oil_pump_system/widgets/Clients.dart';
import 'package:oil_pump_system/widgets/Gasoline.dart';
import 'package:oil_pump_system/widgets/Income.dart';
import 'package:oil_pump_system/widgets/Report.dart';
import 'package:oil_pump_system/widgets/addDaily.dart';
import 'package:oil_pump_system/widgets/addClient.dart';
import 'package:oil_pump_system/widgets/addReciept.dart';
import 'package:oil_pump_system/widgets/home.dart';
import 'package:oil_pump_system/widgets/oldDailys.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

Widget _defaultHome = HomePage();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize FFI
  sqfliteFfiInit();
  // Change the default factory
  databaseFactory = databaseFactoryFfi;

  bool _isLoggedIn = await SharedServices.isLoggedIn();
  if(_isLoggedIn){
    _defaultHome = OldDailys();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => _defaultHome,
        '/login' : (context) => HomePage(),
        '/dailys': (context) => Dailys(),
        '/add_daily' : (context) => AddDaily(),
        '/old_daily' : (context) => OldDailys(),
        '/employees' : (context) => Employees(),
        '/add_employee' : (context) => AddEmployee(),
        '/gasolines' : (context) => Gasolines(),
        '/incomes' : (context) => Incomes(),
        '/add_reciept' : (context) => AddReciept(),
        '/reports' : (context) => Reports(),
      },
    );
  }
}
