import 'package:flutter/material.dart';
import 'package:oil_pump_system/widgets/Daily.dart';
import 'package:oil_pump_system/widgets/Employee.dart';
import 'package:oil_pump_system/widgets/Gasoline.dart';
import 'package:oil_pump_system/widgets/Income.dart';
import 'package:oil_pump_system/widgets/Report.dart';
import 'package:oil_pump_system/widgets/addDaily.dart';
import 'package:oil_pump_system/widgets/addEmployee.dart';
import 'package:oil_pump_system/widgets/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(),
        '/dailys': (context) => Dailys(),
        '/add_daily' : (context) => AddDaily(),
        '/employees' : (context) => Employees(),
        '/add_employee' : (context) => AddEmployee(),
        '/gasolines' : (context) => Gasolines(),
        '/incomes' : (context) => Incomes(),
        '/reports' : (context) => Reports(),
      },
    );
  }
}
