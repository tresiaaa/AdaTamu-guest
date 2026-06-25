import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pill_button.dart';
import 'dashboard_page.dart';

/// Halaman konfirmasi setelah data tamu berhasil disimpan ke Firestore.
class GuestSuccessPage extends StatelessWidget {
  const GuestSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 64,
                      color: AppColors.logoIcon,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Terima Kasih!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.welcomeTitle,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Data buku tamu kamu berhasil disimpan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  AnimatedPillButton(
                    label: 'Kembali ke Beranda',
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const DashboardPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
