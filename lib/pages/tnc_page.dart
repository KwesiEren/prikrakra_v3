import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndCondPage extends StatefulWidget {
  const TermsAndCondPage({super.key});

  @override
  State<TermsAndCondPage> createState() => _TermsAndCondPageState();
}

class _TermsAndCondPageState extends State<TermsAndCondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.asset(
        "assets/terms_conditions.pdf", // Path to the PDF file
      ),
    );
  }
}
