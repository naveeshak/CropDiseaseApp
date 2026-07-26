import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../pages.dart';
import '../services/tflite_service.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';

  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final TFLiteService _tfliteService = TFLiteService();

  File? selectedImage;
  bool isLoading = false;
  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _tfliteService.loadModel();
      if (!mounted) return;
      setState(() {
        modelLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading model: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading model: $e')),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      selectedImage = File(image.path);
    });
  }

  String _detectCropName(String label) {
    final lower = label.toLowerCase();

    if (lower.contains('eggplant')) {
      return 'Eggplant';
    } else if (lower.contains('green_chilli') ||
        lower.contains('green_chillie') ||
        lower.contains('green_chillit')) {
      return 'Green Chilli';
    } else if (lower.contains('okra')) {
      return 'Okra';
    } else {
      return 'Unknown Crop';
    }
  }

  Future<void> _analyzeImage() async {
    if (selectedImage == null || !modelLoaded) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _tfliteService.runModelOnImage(selectedImage!.path);

      const double confidenceThreshold = 0.70;

      if (result.confidence < confidenceThreshold) {
        if (!mounted) return;

        Navigator.pushNamed(
          context,
          ResultScreen.routeName,
          arguments: ResultArgs(
            imagePath: selectedImage!.path,
            cropName: 'Unknown Crop',
            label: 'Unknown_Not_In_Supported_List',
            confidence: result.confidence,
          ),
        );
        return;
      }

      final cropName = _detectCropName(result.label);

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: ResultArgs(
          imagePath: selectedImage!.path,
          cropName: cropName,
          label: result.label,
          confidence: result.confidence,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediction error: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSinhala = context.watch<AppState>().languageCode == 'si';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isSinhala ? 'ඡායාරූපය තෝරන්න' : 'Select Image',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickFromGallery,
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: selectedImage == null
                        ? const Color(0xFFB7E4C7)
                        : const Color(0xFF52B788),
                    width: selectedImage == null ? 2 : 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D6A4F).withOpacity(0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8F3DC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 36,
                              color: Color(0xFF2D6A4F),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isSinhala ? 'රූපයක් තෝරා නැත' : 'No image selected',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF52796F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isSinhala
                                ? 'ස්පර්ශ කර ගැලරිය විවෘත කරන්න'
                                : 'Tap to open gallery',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF84A98C),
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    onPressed: _pickFromCamera,
                    icon: Icons.camera_alt_rounded,
                    label: isSinhala ? 'කැමරා' : 'Camera',
                    backgroundColor: const Color(0xFF2D6A4F),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    onPressed: _pickFromGallery,
                    icon: Icons.photo_library_rounded,
                    label: isSinhala ? 'ගැලරිය' : 'Gallery',
                    backgroundColor: const Color(0xFF52796F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: (selectedImage != null && modelLoaded && !isLoading)
                      ? const LinearGradient(
                          colors: [Color(0xFF1B4332), Color(0xFF40916C)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFB7E4C7), Color(0xFFB7E4C7)],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: (selectedImage != null && modelLoaded && !isLoading)
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2D6A4F).withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [],
                ),
                child: TextButton(
                  onPressed:
                      (selectedImage == null || !modelLoaded || isLoading)
                          ? null
                          : _analyzeImage,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.biotech_rounded,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              isSinhala ? 'විශ්ලේෂණය කරන්න' : 'Analyze Image',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}