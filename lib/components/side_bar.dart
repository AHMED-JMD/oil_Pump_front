import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';


class Navbar extends StatefulWidget {
  final SidebarXController controller;
  Navbar({super.key, required this.controller});

  @override
  State<Navbar> createState() => _NavbarState(controller: controller);
}

class _NavbarState extends State<Navbar> {
  SidebarXController controller;
  _NavbarState({required this.controller});

  List<String> options = [ ' يومية جديدة', 'يوميات سابقة'];
  String? selected;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
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
            icon: Icons.home,
            label: ' الرئيسية ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/home');
            }
        ),
        SidebarXItem(
            icon: Icons.bar_chart_outlined,
            label: ' اليوميات ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/old_daily');
            }
            // iconWidget:
            // DropdownButton(
            //       value: selected,
            //       hint: Text(' اليوميات ', style: TextStyle(color: Colors.grey[300]),),
            //       onChanged: (value){
            //         setState(() {
            //           selected = value;
            //         });
            //         value == 'يوميات سابقة' ? Navigator.pushReplacementNamed(context, '/old_daily') : Navigator.pushReplacementNamed(context, '/dailys');
            //       },
            //       items: options.map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //       style: TextStyle(color: Colors.grey[300]),
            //       icon: Icon(Icons.arrow_drop_down_circle_sharp),
            //       iconEnabledColor: Colors.grey[300],
            //       dropdownColor: canvasColor,
            //       underline: SizedBox(),
            //     ),
        ),
        SidebarXItem(
            icon: Icons.add_chart_rounded,
            label: ' يومية جديدة ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/dailys');
            }
        ),
        SidebarXItem(
            icon: Icons.gas_meter,
            label: ' بئر الوقود ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/gasolines');
            }
        ),
        SidebarXItem(
            icon: Icons.person_4,
            label: 'العملاء',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/clients');
            }
        ),
        SidebarXItem(
            icon: Icons.local_shipping,
            label: ' الشحن و التفريغ ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/incomes');
            }
        ),
        SidebarXItem(
            icon: Icons.local_gas_station,
            label: ' عدادات الوقود ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/machines');
            }
        ),
        SidebarXItem(
            icon: Icons.person_pin,
            label: ' الموظفين و العمال ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/employees');
            }
        ),
        SidebarXItem(
            icon: Icons.home_work_rounded,
            label: ' البنوك ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/banks');
            }
        ),
      ],
    );
  }
}

const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);