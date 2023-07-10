import 'package:flutter/material.dart';
import 'package:oil_pump_system/components/tables/EmployeeTable.dart';
import 'package:oil_pump_system/components/tables/daily_table.dart';
import 'package:oil_pump_system/components/tables/gasoline_table.dart';
import 'package:oil_pump_system/components/tables/income_table.dart';
import 'package:oil_pump_system/components/tables/reports_table.dart';
import 'package:sidebarx/sidebarx.dart';


class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  int index = 0;

  List<Widget> components = [
    DailyTable(),
    GasolineTable(),
    EmployeeTable(),
    IncomeTable(),
    ReportsTable(),
  ];

  void _setPage (int value){
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Align(
                 alignment: Alignment.topLeft,
                 child: Text('Logo', style: TextStyle(fontSize: 22),)
             ),
             Align(
               alignment: Alignment.topRight,
                 child: Text('نظام تشغيل طرمبة الميناء الجاف', style: TextStyle(fontSize: 22),)
             )
           ],
         ),
         backgroundColor: canvasColor,
       ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
          Row(
          children: [
          SidebarX(
          controller: _controller,
            theme: SidebarXTheme(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: canvasColor,
                borderRadius: BorderRadius.circular(20),
              ),
              hoverColor: scaffoldBackgroundColor,
              textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              selectedTextStyle: const TextStyle(color: Colors.white),
              itemTextPadding: const EdgeInsets.only(left: 30),
              selectedItemTextPadding: const EdgeInsets.only(left: 30),
              itemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: canvasColor),
              ),
              selectedItemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: actionColor.withOpacity(0.37),
                ),
                gradient: const LinearGradient(
                  colors: [accentCanvasColor, canvasColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 30,
                  )
                ],
              ),
              iconTheme: IconThemeData(
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 20,
              ),
            ),
            extendedTheme: const SidebarXTheme(
              width: 200,
              decoration: BoxDecoration(
                color: canvasColor,
              ),
            ),
            footerDivider: divider,
            items:  [
              SidebarXItem(
                  icon: Icons.home_filled,
                  label: 'دفتر اليومية',
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/employees');
                  }
              ),
              SidebarXItem(
                  icon: Icons.local_gas_station,
                  label: 'حالة الوقود',
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/employees');
                  }
              ),
              SidebarXItem(
                icon: Icons.person_4,
                label: 'الموظفين',
                  onTap: (){
                  Navigator.pushReplacementNamed(context, '/employees');
                  }
              ),
              SidebarXItem(
                icon: Icons.monetization_on,
                label: 'ايصال وارد',
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/employees');
                  }
              ),
              SidebarXItem(
                icon: Icons.account_balance_wallet,
                label: 'تقرير',
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/employees');
                  }
              ),
            ],
          ),
          // Your app screen body
          ],
        ),
              Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                      child: components[_controller.selectedIndex]
                  )
              ),
            ],
          ),
        ),
    );
  }
}

const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);