import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Camera',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimary : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Scan dan ubah dokumen ke PDF',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 24),
              _ScanOptionCard(
                icon: Icons.document_scanner_rounded,
                title: 'Scan to PDF',
                subtitle: 'Ambil foto dokumen dan ubah ke PDF',
                color: AppColors.catAdvanced,
                onTap: () => Get.toNamed(AppRoutes.scanToPdf),
              ),
              const SizedBox(height: 14),
              _ScanOptionCard(
                icon: Icons.document_scanner_rounded,
                title: 'OCR PDF',
                subtitle: 'Ekstrak teks dari file PDF atau gambar',
                color: AppColors.catOptimize,
                onTap: () => Get.toNamed(AppRoutes.ocrPdf),
              ),
              const SizedBox(height: 14),
              _ScanOptionCard(
                icon: Icons.photo_library_rounded,
                title: 'JPG to PDF',
                subtitle: 'Pilih gambar dari galeri lalu ubah ke PDF',
                color: AppColors.catConvertTo,
                onTap: () => Get.toNamed(AppRoutes.jpgToPdf),
              ),
              const Spacer(),
              // Big camera button
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.scanToPdf),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mulai Scan',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Tap untuk membuka kamera',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ScanOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.divider : AppColors.dividerLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
