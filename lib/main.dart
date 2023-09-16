import 'package:OilEnergy_System/widgets/Employees.dart';
import 'package:OilEnergy_System/widgets/Pumps.dart';
import 'package:OilEnergy_System/widgets/addEmployee.dart';
import 'package:OilEnergy_System/widgets/addReadings.dart';
import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';
import 'package:OilEnergy_System/widgets/Banks.dart';
import 'package:OilEnergy_System/widgets/Daily.dart';
import 'package:OilEnergy_System/widgets/Clients.dart';
import 'package:OilEnergy_System/widgets/Gasoline.dart';
import 'package:OilEnergy_System/widgets/Income.dart';
import 'package:OilEnergy_System/widgets/MainPage.dart';
import 'package:OilEnergy_System/widgets/Safe.dart';
import 'package:OilEnergy_System/widgets/addTrans.dart';
import 'package:OilEnergy_System/widgets/addClient.dart';
import 'package:OilEnergy_System/widgets/addMachine.dart';
import 'package:OilEnergy_System/widgets/addReciept.dart';
import 'package:OilEnergy_System/widgets/home.dart';
import 'package:OilEnergy_System/widgets/oldDailys.dart';
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
    _defaultHome = MainPage();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Cairo'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => _defaultHome,
        '/home': (context) => MainPage(),
        '/login' : (context) => HomePage(),
        '/dailys': (context) => Dailys(),
        '/add_daily' : (context) => AddDaily(),
        '/old_daily' : (context) => OldDailys(),
        '/clients' : (context) => Clients(),
        '/employees': (context) => Employees(),
        '/add_employes': (context) => AddEmployee(),
        '/add_client' : (context) => AddClient(),
        '/gasolines' : (context) => Gasolines(),
        '/machines' : (context) => Machine_Pumps(),
        '/add_machine': (context) => AddMachine(),
        '/add_reading': (context) => AddReading(),
        '/incomes' : (context) => Incomes(),
        '/add_reciept' : (context) => AddReciept(),
        '/banks' : (context) => Banks(),
        '/safe' : (context) => Safe(),
      },
    );
  }
}
