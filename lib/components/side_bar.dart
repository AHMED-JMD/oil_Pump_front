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
            icon: Icons.home_filled,
            label: 'دفتر اليومية',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/dailys');
            }
        ),
        SidebarXItem(
            icon: Icons.local_gas_station,
            label: 'حالة الوقود',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/gasolines');
            }
        ),
        SidebarXItem(
            icon: Icons.person_4,
            label: 'العملاء',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/employees');
            }
        ),
        SidebarXItem(
            icon: Icons.monetization_on,
            label: 'الشحن و التفريغ',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/incomes');
            }
        ),
        SidebarXItem(
            icon: Icons.account_balance_wallet,
            label: 'تقرير',
            onTap: (){
              Navigator.pushReplacementNamed(context, '/reports');
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