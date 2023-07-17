import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/gasoline_table.dart';
import 'package:sidebarx/sidebarx.dart';

class Gasolines extends StatefulWidget {
  const Gasolines({super.key});

  @override
  State<Gasolines> createState() => _GasolinesState();
}

class _GasolinesState extends State<Gasolines> {
  SidebarXController controller = SidebarXController(selectedIndex: 1, extended: true);

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
                Navbar(controller: controller),
              ],
            ),
            Expanded(
                child: Container(
                    color: Colors.grey.shade100,
                    child: GasolineTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
