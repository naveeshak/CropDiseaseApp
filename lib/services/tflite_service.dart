import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({
    required this.label,
    required this.confidence,
  });
}

class TFLiteService {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

    final labelData = await rootBundle.loadString('assets/model/labels.txt');
    _labels =
        labelData.split('\n').where((label) => label.trim().isNotEmpty).toList();
  }

  Future<PredictionResult> runModelOnImage(String imagePath) async {
    if (_interpreter == null) {
      throw Exception("Model not loaded");
    }

    final imageBytes = await File(imagePath).readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception("Could not decode image");
    }

    final resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    final input = imageToInput(resizedImage);

    final output = [List.filled(_labels.length, 0.0)];

    _interpreter!.run(input, output);

    final scores = output[0];
    int maxIndex = 0;
    double maxScore = scores[0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        maxIndex = i;
      }
    }

    return PredictionResult(
      label: _labels[maxIndex],
      confidence: maxScore,
    );
  }

  List<List<List<List<double>>>> imageToInput(img.Image image) {
    return [
      List.generate(224, (y) {
        return List.generate(224, (x) {
          final pixel = image.getPixel(x, y);

          return [
            img.getRed(pixel) / 255.0,
            img.getGreen(pixel) / 255.0,
            img.getBlue(pixel) / 255.0,
          ];
        });
      })
    ];
  }
}