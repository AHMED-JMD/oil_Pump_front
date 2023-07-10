import 'package:flutter/material.dart';

const canvasColor = Color(0xFF2E2E48);
 APPBAR () {
   return AppBar(
     title: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Align(
             alignment: Alignment.topLeft,
             child: Text('Logo', style: TextStyle(fontSize: 22),)
         ),
         Align(
             alignment: Alignment.topRight,
             child: Text('نظام تشغيل طرمبة الميناء الجاف',
               style: TextStyle(fontSize: 22),)
         )
       ],
     ),
     backgroundColor: canvasColor,
   );
 }