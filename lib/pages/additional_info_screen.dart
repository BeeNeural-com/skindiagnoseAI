import 'dart:io';
import 'package:dtreatyflutter/backend/classifier_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'result_screen.dart';

class AdditionalDiseaseScreen extends StatefulWidget {
  final String imagePath;

  const AdditionalDiseaseScreen({super.key, required this.imagePath});

  @override
  State<AdditionalDiseaseScreen> createState() =>
      _AdditionalDiseaseScreenState();
}

class _AdditionalDiseaseScreenState extends State<AdditionalDiseaseScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openSpeechDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.red : Colors.black,
                  ),
                  onPressed: () async {
                    if (!_isListening) {
                      bool available = await _speech.initialize();
                      if (available) {
                        setState(() => _isListening = true);
                        _speech.listen(
                          onResult: (val) {
                            setState(() {
                              _spokenText = val.recognizedWords;
                            });
                          },
                        );
                      }
                    } else {
                      _speech.stop();
                      setState(() => _isListening = false);
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  _spokenText.isEmpty ? "Speak now..." : _spokenText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _speech.stop();
                    setState(() => _isListening = false);
                    _descriptionController.text = _spokenText;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 116, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Finish',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SkinDiagnose',
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Image Display
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(widget.imagePath),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Text Input
              TextField(
                controller: _descriptionController,
                maxLines: 6,
                style: GoogleFonts.openSans(),
                decoration: InputDecoration(
                  hintText: 'Describe symptoms, concerns, or notes...',
                  hintStyle: GoogleFonts.openSans(color: Colors.black45),
                  filled: true,
                  hintMaxLines: 10,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Speak Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 116, 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  icon: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Speak',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _openSpeechDialog,
                ),
              ),

              const Spacer(),

              // Diagnose Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 116, 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () async {
                    // Show loading indicator while classifying
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    // Load model
                    await ClassifierService.loadModel();

                    // Classify
                    String prediction =
                        await ClassifierService.classifyImage(widget.imagePath);

                    // Close loading dialog
                    Navigator.pop(context);

                    // Navigate to ResultScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          imagePath: widget.imagePath,
                          additionalText: _descriptionController.text.trim(),
                          predictionText: "Acne", // <-- Use real prediction
                          // predictionText: prediction, // <-- Use real prediction
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Diagnose',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
