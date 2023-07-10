import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/daily_table.dart';

class Dailys extends StatefulWidget {
  const Dailys({super.key});

  @override
  State<Dailys> createState() => _DailysState();
}

class _DailysState extends State<Dailys> {
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
                    child: DailyTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
