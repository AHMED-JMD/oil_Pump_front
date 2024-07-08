import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> PrintPage() async {
  //create pdf
  final doc = pw.Document();

  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 10),
              pw.Text('بسم الله الرحمن الرحيم',),
              pw.Text('شركة اويل انرجي - القضارف'),
              pw.Text('احمد عيسى الحسن'),
              pw.Table()
            ],
          )
        );
      }));

  //print page as pdf
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
}
