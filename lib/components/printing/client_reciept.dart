import 'package:OilEnergy_System/components/formatters.dart';
import 'package:OilEnergy_System/components/printing/base_print.dart';
import 'package:OilEnergy_System/models/daily_data.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrintClientReciept extends StatelessWidget {
  final Daily transact;
  const PrintClientReciept({super.key, required this.transact});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          PrintPage(printWidget(context), 'ايصال عميل');
        },
        icon: Icon(Icons.print, color: Colors.deepPurple[900],),
        tooltip: 'طباعة'
    );
  }

  printWidget(BuildContext context) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        children: [
          pw.SizedBox(height: 50),
          pw.Text('تفاصيل المعاملة'),
          pw.SizedBox(height: 25),

          pw.Container(
            padding: pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(12)
            ),
            child: pw.Table(
                border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 1.5, color: PdfColors.blue800)),
                children: [
                  pw.TableRow(
                      children: [
                        pw.Text('البيان', textAlign: pw.TextAlign.center),
                        pw.Text('المبلغ', textAlign: pw.TextAlign.center),
                        pw.Text('الوقود', textAlign: pw.TextAlign.center),
                        pw.Text('اللترات', textAlign: pw.TextAlign.center),
                        pw.Text('الحالة', textAlign: pw.TextAlign.center),
                        pw.Text('العميل', textAlign: pw.TextAlign.center),
                      ]
                  ),
                  pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${transact.comment}', textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${numberFormat(transact.amount)}', textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${transact.gas_type}', textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${transact.gas_amount}', textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${transact.type}', textAlign: pw.TextAlign.center),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(2),
                          child: pw.Text('${transact.name}', textAlign: pw.TextAlign.center),
                        ),
                          ]
                      )
                ]
            ),
          ),
        ]
      )
    );
  }
}
