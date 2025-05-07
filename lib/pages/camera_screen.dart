import 'package:dtreatyflutter/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treatment_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  String? _prediction;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    print(res);
  }

  Future<void> _classifyImage(String path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      numResults: 5,
    );
    setState(() {
      if (recognitions?.isNotEmpty == true) {
        double confidence = recognitions!.first['confidence'];
        if (confidence > 0.7) {
          _prediction = recognitions.first['label'];
        } else {
          _prediction = 'Not A Leaf';
        }
      } else {
        _prediction = 'No Prediction';
      }
    });
    if (_prediction == 'Not A Leaf' || _prediction == 'No Prediction') {
      _showWarningDialog();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              prediction: _prediction ?? 'No Prediction',
              imagePath: path,
            ),
          ));
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[600]),
            const SizedBox(width: 10),
            const Text('Oops!'),
          ],
        ),
        content: const Text('Only skin-related scans are supported.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndClassify() async {
    try {
      final image = await _controller?.takePicture();
      if (image != null) {
        await _classifyImage(image.path);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    Tflite.close();
    super.dispose();
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
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        title: Text(
          'SkinScan',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Align your skin in the frame\nTap capture to scan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isCameraInitialized && _controller != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      )
                    : const Center(
                        child: SpinKitFadingCircle(
                          color: Colors.green,
                          size: 50.0,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _captureAndClassify,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[600],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
