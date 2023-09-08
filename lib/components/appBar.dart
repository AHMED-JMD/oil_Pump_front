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
                 style: TextButton.styleFrom(
                   primary: Colors.white
                 ),
                 icon: Icon(Icons.logout),
                 label: Text('تسجيل الخروج',style: TextStyle(fontSize: 18),)
             )
         ),
         Align(
             alignment: Alignment.topRight,
             child: Text('نظام تشغيل طرمبة اويل انرجي',
               style: TextStyle(fontSize: 22),)
         )
       ],
     ),
     backgroundColor: canvasColor,
   );
 }