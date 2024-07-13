import 'package:flutter/material.dart';
import 'package:OilEnergy_System/components/printing/base_print.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrintReciept extends StatelessWidget {
  final Map reciept;
  const PrintReciept({super.key, required this.reciept});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: (){
          PrintPage(printWidget(context), 'ايصال الشحن');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[800]
        ),
        icon: Icon(Icons.print, color: Colors.grey,),
        label: Text('طباعة', style: TextStyle(color: Colors.white),)
    );
  }

  printWidget (BuildContext context) {
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
            children: [
              pw.SizedBox(height: 50),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' المصدر ${reciept['source']}')
                    ),
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' شركة ${reciept['company']}')
                    ),
                  ]
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' تاريخ الوصول: ${reciept['arrive_date']}')
                    ),
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' تاريخ الشحن: ${reciept['ship_date']}')
                    ),
                  ]
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                  width: 600,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                  ),
                  child: pw.Text(' الوقود ${reciept['fuel_type']}')
              ),
              pw.SizedBox(height: 15),
              pw.Container(
                  width: 600,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                  ),
                  child: pw.Text(' الكمية ${reciept['amount']}لتر ')
              ),
              pw.SizedBox(height: 15),
              pw.Container(
                  width: 600,
                  decoration: pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                  ),
                  child: pw.Text(' العجز ${reciept['shortage']}')
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' رقم اللوحة (${reciept['car_plate']})')
                    ),
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' السائق ${reciept['driver']}')
                    ),
                  ]
              ),
            ]
        )
    );
  }

}
