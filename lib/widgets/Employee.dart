import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/EmployeeTable.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Row(
              children: [
                Navbar(),
              ],
            ),
            Expanded(
                child: Container(
                    color: Colors.grey.shade100,
                    child: EmployeeTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
