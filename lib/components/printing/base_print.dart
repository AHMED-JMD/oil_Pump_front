import 'package:OilEnergy_System/components/formatters.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future PrintPage(printWidget, String title) async {
  //create pdf
  final doc = pw.Document();


  DateTime now = DateTime.now();
  String date = '${now.year}/${timeFormat(now.month)}/${timeFormat(now.day)}';
  // String time = '${timeFormat(now.hour)}:${timeFormat(now.minute)}';
  // String amPm = now.hour < 12 ? 'AM' : 'PM';
  
  //set Font
  final ttf = await fontFromAssetBundle('assets/fonts/HacenTunisia.ttf');
  //set header image
  // final header = await imageFromAssetBundle('assets/oil_station Bg.png');

  //set theme
  var myTheme = pw.ThemeData.withFont( base: ttf );

  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: myTheme,
      build: (pw.Context context) {
        return [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text('التاريخ: ${date}', style: pw.TextStyle(fontSize: 18)),
                  pw.Text('$title', style: pw.TextStyle(fontSize: 18)),

                ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Center(
              child: pw.Text('محطة وقود اويل انرجي القضارف', style: pw.TextStyle(fontSize: 20)),
            ),
          ),
          pw.SizedBox(height: 20),
          printWidget,
        ];
      }));

  //print page as pdf
   await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save()
  );

  //return doc.save();
}
