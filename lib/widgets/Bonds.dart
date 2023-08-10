import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Bonds extends StatefulWidget {
  const Bonds({super.key});

  @override
  State<Bonds> createState() => _BondsState();
}

class _BondsState extends State<Bonds> {
  SidebarXController controller = SidebarXController(selectedIndex: 6, extended: true);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPBAR(context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
              children: [
                Navbar(controller: controller,),
                Expanded(
                    child: Center(
                      child: Text('hello bonds here'),
                    ))
              ],
            )
      ),
    );
  }
}
