import 'dart:io';
import 'package:dtreatyflutter/backend/llm_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final String additionalText;
  final String predictionText;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.additionalText,
    required this.predictionText,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? medicalReport;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  Future<void> _generateReport() async {
    try {
      final report = await MedicalLLMService().generateMedicalReport(
        widget.predictionText,
        widget.additionalText,
      );
      setState(() {
        medicalReport = report;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        medicalReport = "Failed to generate report. Please try again";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Result'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget.imagePath),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.predictionText,
              style: GoogleFonts.openSans(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        medicalReport ?? '',
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
