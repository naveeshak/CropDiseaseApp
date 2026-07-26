class DetectionRecord {
  final String cropName;
  final String label;
  final double confidence;
  final DateTime dateTime;
  final String imagePath; // local file path

  DetectionRecord({
    required this.cropName,
    required this.label,
    required this.confidence,
    required this.dateTime,
    required this.imagePath,
  });
}