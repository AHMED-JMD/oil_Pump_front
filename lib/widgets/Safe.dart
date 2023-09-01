import 'package:flutter/material.dart';
import 'package:OilEnergy_System/components/appBar.dart';
import 'package:OilEnergy_System/components/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class Safe extends StatefulWidget {
  const Safe({super.key});

  @override
  State<Safe> createState() => _SafeState();
}

class _SafeState extends State<Safe> {
  SidebarXController controller = SidebarXController(selectedIndex: 5, extended: true);
  
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
                      child: Text('hello safe here'),
                    ))
              ],
            )
      ),
    );
  }
}
