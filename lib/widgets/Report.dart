import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/reports_table.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
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
                    child: ReportsTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
