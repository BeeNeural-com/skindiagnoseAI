import 'package:tflite_v2/tflite_v2.dart';

class ClassifierService {
  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  static Future<String> classifyImage(String imagePath) async {
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 5,
    );

    if (recognitions?.isNotEmpty == true) {
      double confidence = recognitions!.first['confidence'];
      if (confidence > 0.1) {
        return recognitions.first['label'];
      } else {
        return 'Not A Leaf'; // or 'Not a Skin Disease' based on your needs
      }
    } else {
      return 'No Prediction';
    }
  }

  static Future<void> closeModel() async {
    await Tflite.close();
  }
}
