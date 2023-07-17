import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/reports_table.dart';
import 'package:sidebarx/sidebarx.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  SidebarXController controller = SidebarXController(selectedIndex: 4, extended: true);

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
                child: Container(
                    color: Colors.grey.shade100,
                    child: ReportsTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
