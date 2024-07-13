import 'package:OilEnergy_System/components/formatters.dart';
import 'package:OilEnergy_System/components/printing/base_print.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrintClient extends StatelessWidget {
  final Map client;
  final List client_trans;

  const PrintClient({super.key, required this.client, required this.client_trans});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: (){
          PrintPage(printWidget(context), 'تقرير عميل');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[800]
        ),
        icon: Icon(Icons.print, color: Colors.grey,),
        label: Text('طباعة بيانات العميل', style: TextStyle(color: Colors.white),)
    );
  }

  printWidget(BuildContext context){
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' اجمالي الحساب: ${numberFormat(client['account'])}')
                    ),
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' العميل ${client['name']}')
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
                        child: pw.Text(' الجازولين: ${numberFormat(client['gas_amount'])}')
                    ),
                    pw.Container(
                        width: 150,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue800, width: 1))
                        ),
                        child: pw.Text(' البنزين: ${numberFormat(client['benz_amount'])}')
                    ),
                  ]
              ),
              pw.SizedBox(height: 30),
              pw.Text('تفاصيل المعاملات'),
              pw.SizedBox(height: 10),
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
                      ...client_trans.map((element) =>
                          pw.TableRow(
                              children: [
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['comment']}', textAlign: pw.TextAlign.center),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['amount']}', textAlign: pw.TextAlign.center),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['gas_type']}', textAlign: pw.TextAlign.center),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['gas_amount']}', textAlign: pw.TextAlign.center),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['type']}', textAlign: pw.TextAlign.center),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text('${element['name']}', textAlign: pw.TextAlign.center),
                                ),
                              ]
                          )
                      )
                    ]
                ),
              ),
            ]
        )
    );
  }

}

