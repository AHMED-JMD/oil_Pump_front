import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/appBar.dart';
import 'package:oil_pump_system/components/side_bar.dart';
import 'package:oil_pump_system/components/tables/income_table.dart';

class Incomes extends StatefulWidget {
  const Incomes({super.key});

  @override
  State<Incomes> createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {
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
                    child: IncomeTable()
                )
            )
          ],
        ),
      ),
    );
  }
}
