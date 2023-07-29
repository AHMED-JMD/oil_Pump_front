import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/ClientTable.dart';
import 'package:sidebarx/sidebarx.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  SidebarXController controller = SidebarXController(selectedIndex: 2, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Row(
              children: [
                Navbar(controller: controller,),
              ],
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        color: Colors.grey.shade100,
                        child: EmployeeTable()
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
