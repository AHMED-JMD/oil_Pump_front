import 'package:OilEnergy_System/components/formatters.dart';
import 'package:OilEnergy_System/components/printing/base_print.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PrintDaily extends StatelessWidget {
  final List readings;
  final List trans;
  final List outGs;
  final int total;

  const PrintDaily({
    super.key,
    required this.readings,
    required this.trans,
    required this.outGs,
    required this.total
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: (){
          PrintPage(printWidget(context), 'يومية جديدة');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[800]
        ),
        icon: Icon(Icons.print, color: Colors.grey,),
        label: Text('طباعة اليومية', style: TextStyle(color: Colors.white),)
    );
  }

  printWidget (BuildContext context) {
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Text(
                          ' اجمالي  :${numberFormat(total)}',
                          style: pw.TextStyle(fontSize: 18, color: PdfColors.black)
                      ),
                    )
                  ]
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('القراءات'),
                  ]
              ),
              pw.SizedBox(height: 5,),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: readings.map((element) {
                    return pw.Container(
                      padding: pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(width: 2, color: PdfColors.blue800),
                            bottom: pw.BorderSide(width: 2, color: PdfColors.blue800),
                          )
                      ),
                      child: pw.Column(
                          children: [
                            pw.Text('${numberFormat(element['f_reading'])}'),
                            pw.Text('${numberFormat(element['last_reading'])}'),
                            pw.Divider(),
                            pw.Text('${numberFormat(element['amount'])}'),
                          ]
                      ),
                    );
                  }).toList()
              ),
              pw.SizedBox(height: 15),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children:[
                    pw.Text('المعاملات')
                  ]
              ),
              pw.SizedBox(height: 5),
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
                      ...trans.map((element) =>
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
              pw.SizedBox(height: 15),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('المنصرفات'),
                  ]
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    ...outGs.map((element) {
                      return pw.Column(
                          children: [
                            pw.Container(
                                width: 800,
                                decoration: pw.BoxDecoration(
                                    shape: pw.BoxShape.rectangle,
                                    color: PdfColors.grey200,
                                    boxShadow: [
                                      pw.BoxShadow(
                                          offset: PdfPoint.zero,
                                          blurRadius: 5,
                                          spreadRadius: 5,
                                          color:PdfColors.black
                                      )
                                    ]
                                ),
                                child: pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                    children: [
                                      pw.Text('${numberFormat(element['amount'])}'),
                                      pw.Text('${element['comment']}'),
                                    ]
                                )
                            ),
                            pw.SizedBox(height: 10)
                          ]
                      );
                    }),
                  ]
              ),
            ]
        )
    );
  }

}
