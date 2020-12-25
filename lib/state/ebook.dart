import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class Ebook extends StatefulWidget {
  @override
  _EbookState createState() => _EbookState();
}

class _EbookState extends State<Ebook> {
  PDFDocument pdfDocument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPDF();
  }

  Future<Null> loadPDF() async {
    String urlPDF =
        'https://firebasestorage.googleapis.com/v0/b/aeytestmobile.appspot.com/o/ebook%2F2014-08-20_Spec_Customize%20Calculate%20Material%20Average.pdf?alt=media&token=38a3c54c-cc9d-4b71-b77f-cfb64fec98b3';
    try {
      var result = await PDFDocument.fromURL(urlPDF);
      setState(() {
        pdfDocument = result;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfDocument == null
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(document: pdfDocument),
    );
  }
}
