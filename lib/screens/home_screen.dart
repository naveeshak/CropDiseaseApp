import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  const HomeScreen({super.key});

  String t(BuildContext context, String en, String si) {
    final code = context.watch<AppState>().languageCode;
    return code == 'si' ? si : en;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1B4332),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, SettingsScreen.routeName),
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                t(context, 'Crop Doctor', 'බෝග මිතුරා'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1B4332),
                          Color(0xFF2D6A4F),
                          Color(0xFF40916C),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 50,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: -10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF74C69D).withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 16,
                    child: Icon(
                      Icons.eco_rounded,
                      size: 64,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                t(context, 'What would you like to do?',
                    'ඔබට කුමක් කිරීමට අවශ්‍යද?'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF52796F),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.camera_alt_rounded,
                  title: t(context, 'Start Detection',
                      'හඳුනාගැනීම ආරම්භ කරන්න'),
                  subtitle: t(
                    context,
                    'Detect diseases and pests from leaf images',
                    'පත්‍ර රූප මගින් රෝග හා පළිබෝධ හඳුනාගන්න',
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, CameraScreen.routeName),
                  badge: t(context, 'AI Powered', 'AI'),
                ),
                const SizedBox(height: 14),
                _FeatureCard(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.history_rounded,
                  title: t(context, 'History', 'ඉතිහාසය'),
                  subtitle: t(context, 'View saved results',
                      'සුරකින ලද ප්‍රතිඵල බලන්න'),
                  onTap: () =>
                      Navigator.pushNamed(context, HistoryScreen.routeName),
                ),
                const SizedBox(height: 14),
                _FeatureCard(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF52796F), Color(0xFF84A98C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.language_rounded,
                  title: t(context, 'Language', 'භාෂාව'),
                  subtitle: t(context, 'Change app language',
                      'යෙදුමේ භාෂාව වෙනස් කරන්න'),
                  onTap: () =>
                      Navigator.pushNamed(context, SettingsScreen.routeName),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  const _FeatureCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF95D5B2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1B4332),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.6), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}