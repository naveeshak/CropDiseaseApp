import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  const HistoryScreen({super.key});

  String t(BuildContext context, String en, String si) {
    final code = context.watch<AppState>().languageCode;
    return code == 'si' ? si : en;
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final records = appState.history;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t(context, 'History', 'ඉතිහාසය'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        actions: [
          if (records.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Text(t(ctx, 'Clear All?', 'සියල්ල මකන්නද?')),
                    content: Text(t(
                        ctx,
                        'This will delete all saved results.',
                        'සුරකින ලද සියලු ප්‍රතිඵල මකා දැමෙනු ඇත.')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          t(ctx, 'Cancel', 'අවලංගු කරන්න'),
                          style: const TextStyle(color: Color(0xFF52796F)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          appState.clearHistory();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5383A),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          t(ctx, 'Delete', 'මකන්න'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep_rounded,
                  color: Colors.white70, size: 20),
              label: Text(
                t(context, 'Clear all', 'සියල්ල මකන්න'),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
        ],
      ),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8F3DC),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.history_rounded,
                        size: 40, color: Color(0xFF2D6A4F)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t(context, 'No saved results yet',
                        'තවම සුරකින ලද ප්‍රතිඵල නැත'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF52796F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t(context, 'Your scan history will appear here',
                        'ඔබේ ස්කෑන් ඉතිහාසය මෙහි දිස් වේ'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF84A98C),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                final isHealthy = r.label.toLowerCase().contains('healthy');

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(r.imagePath),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      r.cropName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Color(0xFF1B4332),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isHealthy
                                          ? const Color(0xFFD8F3DC)
                                          : const Color(0xFFFFEBEB),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isHealthy
                                          ? t(context, 'Healthy',
                                              'සෞඛ්‍ය සම්පන්න')
                                          : t(context, 'Issue', 'ගැටලුවක්'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isHealthy
                                            ? const Color(0xFF2D6A4F)
                                            : const Color(0xFFB5383A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                r.label.replaceAll('_', ' '),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF52796F),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.bar_chart_rounded,
                                      size: 13,
                                      color: Color(0xFF84A98C)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${(r.confidence * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF84A98C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.access_time_rounded,
                                      size: 13,
                                      color: Color(0xFF84A98C)),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      _formatDate(r.dateTime),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF84A98C),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Color(0xFFB5383A), size: 22),
                          onPressed: () => appState.deleteHistoryItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}