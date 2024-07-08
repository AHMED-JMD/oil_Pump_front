import 'package:flutter/material.dart';
import 'package:OilEnergy_System/SharedService.dart';

const canvasColor = Color(0xFF2E2E48);
 APPBAR (BuildContext context) {
   return AppBar(
     title: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Align(
             alignment: Alignment.topLeft,
             child: TextButton.icon(
                 onPressed: (){
                   SharedServices.logout(context);
                 },
                 icon: const Icon(Icons.logout, color: Colors.white),
                 label: Text('تسجيل الخروج',style: TextStyle(fontSize: 18, color: Colors.white),)
             )
         ),
         Align(
             alignment: Alignment.topRight,
             child: Text('اويل تراك لادارة محطات الوقود',
               style: TextStyle(fontSize: 22, color: Colors.white),)
         )
       ],
     ),
     backgroundColor: canvasColor,
   );
 }