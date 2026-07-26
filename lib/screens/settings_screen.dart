import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  String t(BuildContext context, String en, String si) {
    final code = context.watch<AppState>().languageCode;
    return code == 'si' ? si : en;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t(context, 'Settings', 'සැකසුම්'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B4332).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.language_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context, 'Language', 'භාෂාව'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        t(context, 'Choose app language',
                            'යෙදුමේ භාෂාව තෝරන්න'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t(context, 'SELECT LANGUAGE', 'භාෂාව තෝරන්න'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF52796F),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              value: 'en',
              groupValue: appState.languageCode,
              label: 'English',
              flag: '🇬🇧',
              subtitle: 'English language',
              onChanged: (v) {
                if (v == null) return;
                context.read<AppState>().setLanguage(v);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _LanguageOption(
              value: 'si',
              groupValue: appState.languageCode,
              label: 'සිංහල',
              flag: '🇱🇰',
              subtitle: 'Sinhala language',
              onChanged: (v) {
                if (v == null) return;
                context.read<AppState>().setLanguage(v);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final String flag;
  final String subtitle;
  final ValueChanged<String?> onChanged;

  const _LanguageOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.flag,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD8F3DC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? const Color(0xFF2D6A4F) : const Color(0xFFDDE8DD),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF1B4332)
                          : const Color(0xFF344E41),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF84A98C),
                    ),
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