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
                child: ListView(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Curve_Line.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.difference),
                          )
                      ),
                      child: Center(child: Text('العملاء', style: TextStyle(fontSize: 26, color: Colors.white), textAlign: TextAlign.center,)),
                    ),
                    SizedBox(height: 80,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            color: Colors.grey.shade100,
                            child: EmployeeTable()
                        ),
                      ],
                    ),
                  ]
                )
            )
          ],
        ),
      ),
    );
  }
}
