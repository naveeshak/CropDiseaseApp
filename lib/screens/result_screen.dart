import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class ResultArgs {
  final String imagePath;
  final String cropName;
  final String label;
  final double confidence;

  ResultArgs({
    required this.imagePath,
    required this.cropName,
    required this.label,
    required this.confidence,
  });
}

class ResultScreen extends StatelessWidget {
  static const routeName = '/result';

  const ResultScreen({super.key});

  String _t(BuildContext context, String en, String si) {
    final code = context.watch<AppState>().languageCode;
    return code == 'si' ? si : en;
  }

  String _prettyLabel(String label) {
    return label.replaceAll('_', ' ');
  }

  String _cropNameDisplay(String cropName, bool isSinhala) {
    if (!isSinhala) return cropName;

    final lower = cropName.toLowerCase();

    if (lower.contains('eggplant')) {
      return 'වම්බටු';
    } else if (lower.contains('green chilli') ||
        lower.contains('green_chilli') ||
        lower.contains('green chillie') ||
        lower.contains('green_chillie') ||
        lower.contains('green chillie') ||
        lower.contains('green_chillie')) {
      return 'මිරිස්';
    } else if (lower.contains('okra')) {
      return 'බණ්ඩක්කා';
    } else {
      return cropName;
    }
  }

  String _treatmentText(String label, bool isSi) {
    final lower = label.toLowerCase();

    if (lower.contains('okra_healthy')) {
      return isSi
          ? 'බණ්ඩක්කා ශාකය සෞඛ්‍ය සම්පන්න බව පෙනේ. සාමාන්‍ය රැකවරණය, නිසි ජලය සහ පෝෂක කළමනාකරණය දිගටම කරන්න.'
          : 'The okra plant appears healthy. Continue normal crop care, proper watering, and nutrient management.';
    }

    if (lower.contains('okra_alternaria')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• තෙතමනය අඩු කරන්න\n• අවශ්‍ය නම් සුදුසු දිලීර නාශකයක් භාවිත කරන්න\n• වගාවේ වාතාශ්‍රය වැඩි කරන්න'
          : '• Remove infected leaves\n• Reduce excess moisture\n• Apply a suitable fungicide if necessary\n• Improve air circulation around the crop';
    }

    if (lower.contains('okra_cercospora')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• ඉහළින් ජලය දැමීමෙන් වලකින්න\n• වගාව අතර ඉඩ තබා වාතාශ්‍රය වැඩි කරන්න\n• සුදුසු දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves\n• Avoid overhead watering\n• Keep proper spacing for air circulation\n• Use a suitable fungicide';
    }

    if (lower.contains('okra_downy_mildew')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• අධික තෙතමනය සහ සෙවන අඩු කරන්න\n• වගාව නිතර පරීක්ෂා කරන්න\n• අවශ්‍ය නම් සුදුසු දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves\n• Reduce excess humidity and shade\n• Monitor the crop regularly\n• Apply a suitable fungicide if needed';
    }

    if (lower.contains('okra_leaf_curly_virus')) {
      return isSi
          ? '• ආසාදිත ශාක කොටස් ඉවත් කරන්න\n• වෛරස වාහක කෘමීන් පාලනය කරන්න\n• සෞඛ්‍ය සම්පන්න පැළ භාවිත කරන්න\n• වගාව පිරිසිදුව තබා ගන්න'
          : '• Remove infected plant parts\n• Control insect vectors\n• Use healthy planting material\n• Maintain field sanitation';
    }

    if (lower.contains('okra_phyllosticta')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• පත්‍ර මත ජලය රැඳීම අඩු කරන්න\n• වාතාශ්‍රය වැඩි කරන්න\n• අවශ්‍ය නම් නිර්දේශිත දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves\n• Reduce water retention on leaves\n• Improve air circulation\n• Use a recommended fungicide if needed';
    }

    if (lower.contains('healthy')) {
      return isSi
          ? 'ශාකය සෞඛ්‍ය සම්පන්න බව පෙනේ. සාමාන්‍ය රැකවරණය දිගටම කරන්න.'
          : 'The plant appears healthy. Continue normal crop care.';
    }

    if (lower.contains('whitefly')) {
      return isSi
          ? '• වයිට්ෆ්ලයි පාලනය සඳහා සුදුසු කෘමි පාලන ක්‍රම භාවිත කරන්න\n• ආසාදිත කොළ ඉවත් කරන්න\n• පැළ නිතර නිරීක්ෂණය කරන්න'
          : '• Use suitable pest control methods for whitefly\n• Remove heavily affected leaves\n• Monitor plants regularly';
    }

    if (lower.contains('insect_pest')) {
      return isSi
          ? '• පළිබෝධ ආසාදිත කොටස් ඉවත් කරන්න\n• සුදුසු පළිබෝධ පාලන ක්‍රම යොදන්න\n• වගාව නිතර පරීක්ෂා කරන්න'
          : '• Remove pest-affected parts\n• Apply suitable pest control methods\n• Inspect the crop regularly';
    }

    if (lower.contains('white_mold')) {
      return isSi
          ? '• ආසාදිත කොළ සහ ශාක කොටස් ඉවත් කරන්න\n• අධික තෙතමනය අඩු කරන්න\n• අවශ්‍ය නම් සුදුසු දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves and plant parts\n• Reduce excess moisture\n• Apply a suitable fungicide if necessary';
    }

    if (lower.contains('downy_mildew')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• අධික තෙතමනය සහ සෙවන අඩු කරන්න\n• අවශ්‍ය නම් සුදුසු දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves\n• Reduce excess humidity and shade\n• Apply a suitable fungicide if necessary';
    }

    if (lower.contains('bacterial_spot')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• ඉහළින් ජලය දැමීමෙන් වලකින්න\n• සුදුසු බැක්ටීරියා පාලන ක්‍රම භාවිත කරන්න'
          : '• Remove infected leaves\n• Avoid overhead watering\n• Use suitable bacterial disease control methods';
    }

    if (lower.contains('leaf_curly_virus') || lower.contains('leaf_curl')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• කෘමි වාහක පාලනය කරන්න\n• සෞඛ්‍ය සම්පන්න පැළ භාවිත කරන්න'
          : '• Remove infected leaves\n• Control insect vectors\n• Use healthy planting material';
    }

    if (lower.contains('alternaria') ||
        lower.contains('cercospora') ||
        lower.contains('leaf_spot') ||
        lower.contains('spot')) {
      return isSi
          ? '• ආසාදිත කොළ ඉවත් කරන්න\n• පත්‍ර මත අධික තෙතමනය අඩු කරන්න\n• අවශ්‍ය නම් නිර්දේශිත දිලීර නාශකයක් භාවිත කරන්න'
          : '• Remove infected leaves\n• Reduce moisture on leaves\n• Use a recommended fungicide if needed';
    }

    if (lower.contains('wilt')) {
      return isSi
          ? '• අධික ජලය දැමීමෙන් වලකින්න\n• පස නිරෝගීව තබා ගන්න\n• ආසාදිත ශාක ඉවත් කරන්න'
          : '• Avoid overwatering\n• Keep the soil healthy\n• Remove severely infected plants';
    }

    if (lower.contains('nutrition_deficiency')) {
      return isSi
          ? '• පස පරීක්ෂා කරන්න\n• සුදුසු පොහොර යොදන්න\n• ශාක වර්ධනය නිරීක්ෂණය කරන්න'
          : '• Check the soil condition\n• Apply suitable fertilizer\n• Monitor plant growth regularly';
    }

    if (lower.contains('unknown') || lower.contains('not_in_supported_list')) {
      return isSi
          ? 'මෙම රූපය සහාය දක්වන රෝග/පළිබෝධ ලැයිස්තුවෙන් හඳුනාගත නොහැක. පැහැදිලි පත්‍ර රූපයක් භාවිත කරන්න. අවශ්‍ය නම් කෘෂි උපදේශකයෙකුගේ උපදෙස් ලබා ගන්න.'
          : 'This image could not be matched confidently with the supported disease or pest list. Please use a clear leaf image from eggplant, green chilli, or okra. If needed, seek advice from an agricultural officer.';
    }

    return isSi
        ? '• ශාකය නිරීක්ෂණය කරන්න\n• ආසාදිත කොටස් ඉවත් කරන්න\n• අවශ්‍ය නම් කෘෂි උපදේශකයෙකුගේ උපදෙස් ලබා ගන්න'
        : '• Observe the plant carefully\n• Remove infected parts\n• Seek agricultural advice if needed';
  }

  bool _isHealthy(String label) => label.toLowerCase().contains('healthy');
  bool _isUnknown(String label) => label.toLowerCase().contains('unknown') || label.toLowerCase().contains('not_in_supported_list');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    final isSinhala = context.watch<AppState>().languageCode == 'si';
    final healthy = _isHealthy(args.label);
    final unknown = _isUnknown(args.label);
    final confidencePercent = args.confidence * 100;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _t(context, 'Result', 'ප්‍රතිඵලය'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Image.file(
                    File(args.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFFF4F7F2), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: healthy
                          ? const Color(0xFF2D6A4F)
                          : const Color(0xFFB5383A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '${confidencePercent.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8F3DC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.eco_rounded,
                                  color: Color(0xFF2D6A4F), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _t(context, 'Crop', 'බෝගය'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF84A98C),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _cropNameDisplay(args.cropName, isSinhala),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1B4332),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFECF4EC)),
                        const SizedBox(height: 14),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmall = constraints.maxWidth < 360;

                            if (isSmall) {
                              return Column(
                                children: [
                                  _InfoChip(
                                    label:
                                        _t(context, 'Prediction', 'හඳුනාගැනීම'),
                                     value: unknown
                                        ? _t(
                                            context,
                                            'Unable to identify this crop disease or pest',
                                            'මෙම බෝග රෝගය හෝ පළිබෝධය හඳුනාගත නොහැක',
                                          )
                                        : _prettyLabel(args.label),
                                    icon: Icons.biotech_rounded,
                                    color: const Color(0xFF2D6A4F),
                                  ),
                                  const SizedBox(height: 10),
                                  _InfoChip(
                                    label: _t(context, 'Confidence',
                                        'විශ්වාස මට්ටම'),
                                    value:
                                        '${confidencePercent.toStringAsFixed(1)}%',
                                    icon: Icons.bar_chart_rounded,
                                    color: healthy
                                        ? const Color(0xFF2D6A4F)
                                        : const Color(0xFFB5383A),
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _InfoChip(
                                    label:
                                        _t(context, 'Prediction', 'හඳුනාගැනීම'),
                                     value: unknown
                                        ? _t(
                                            context,
                                            'Unable to identify this crop disease or pest',
                                            'මෙම බෝග රෝගය හෝ පළිබෝධය හඳුනාගත නොහැක',
                                          )
                                        : _prettyLabel(args.label),
                                    icon: Icons.biotech_rounded,
                                    color: const Color(0xFF2D6A4F),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _InfoChip(
                                    label: _t(context, 'Confidence',
                                        'විශ්වාස මට්ටම'),
                                    value:
                                        '${confidencePercent.toStringAsFixed(1)}%',
                                    icon: Icons.bar_chart_rounded,
                                    color: healthy
                                        ? const Color(0xFF2D6A4F)
                                        : const Color(0xFFB5383A),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(context, 'Treatment Recommendation',
                              'ප්‍රතිකාර නිර්දේශ'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B4332),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: healthy
                                ? const Color(0xFFF0FBF4)
                                : const Color(0xFFFFF8F8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: healthy
                                  ? const Color(0xFFB7E4C7)
                                  : const Color(0xFFFFCDD2),
                            ),
                          ),
                          child: Text(
                            _treatmentText(args.label, isSinhala),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF344E41),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(
                              _t(context, 'Try Again', 'නැවත උත්සාහ කරන්න'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2D6A4F),
                              side: const BorderSide(
                                  color: Color(0xFF2D6A4F), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final record = DetectionRecord(
                                cropName: args.cropName,
                                label: args.label,
                                confidence: args.confidence,
                                dateTime: DateTime.now(),
                                imagePath: args.imagePath,
                              );
                              context.read<AppState>().addToHistory(record);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _t(context, 'Saved to history',
                                        'ඉතිහාසයට සුරකින ලදී'),
                                  ),
                                  backgroundColor: const Color(0xFF2D6A4F),
                                ),
                              );
                            },
                            icon: const Icon(Icons.save_rounded),
                            label: Text(
                              _t(context, 'Save', 'සුරකින්න'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D6A4F),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8EDDF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B4332),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}