import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> PrintPage () async {
  //create pdf
  final doc = pw.Document();

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello World'),
        ); // Center
      })
  );

  //print page as pdf
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
