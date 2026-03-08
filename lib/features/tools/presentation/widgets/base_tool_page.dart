import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/file_utils.dart';

/// Generic base widget untuk semua tool pages
class BaseToolPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget body;
  const BaseToolPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}

/// File picker tile widget — reusable di semua tool pages
class FilePickerTile extends StatelessWidget {
  final String? filePath;
  final String hint;
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const FilePickerTile({
    super.key,
    this.filePath,
    this.hint = 'Tap untuk pilih file PDF',
    this.allowMultiple = false,
    this.allowedExtensions,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasFile = filePath != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: hasFile
              ? AppColors.primary.withValues(alpha: 0.06)
              : (isDark ? AppColors.bgDarkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasFile
                ? AppColors.primary
                : (isDark ? AppColors.divider : AppColors.dividerLight),
            width: hasFile ? 1.5 : 1,
            style: hasFile ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: hasFile
            ? Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filePath!.contains(',')
                              ? '${filePath!.split(',').length} File dipilih'
                              : p.basename(filePath!),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          filePath!.contains(',')
                              ? 'Batch Scan Result'
                              : FileUtils.getFileSizeFromPath(filePath!),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textHint,
                        size: 18,
                      ),
                      onPressed: onRemove,
                    ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file_rounded,
                    size: 40,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hint,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Process button with loading state
class ProcessButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final IconData? icon;
  const ProcessButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}

/// Success result card
class ResultCard extends StatelessWidget {
  final String outputPath;
  final VoidCallback? onShare;
  final VoidCallback? onOpen;

  const ResultCard({
    super.key,
    required this.outputPath,
    this.onShare,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            'Berhasil!',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            p.basename(outputPath),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.textDarkSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (onOpen != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOpen,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('Buka'),
                  ),
                ),
              if (onOpen != null && onShare != null) const SizedBox(width: 10),
              if (onShare != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onShare,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('Share'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper function untuk file picker
Future<String?> pickPdfFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  return result?.files.single.path;
}

Future<List<String>?> pickMultiplePdfFiles() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    allowMultiple: true,
  );
  return result?.files.map((f) => f.path!).where((p) => p.isNotEmpty).toList();
}

Future<String?> pickAnyFile(List<String> extensions) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: extensions,
  );
  return result?.files.single.path;
}

/// Helper global untuk memanggil picker pintar di semua 29 fitur 🎯🚀
Future<void> showSmartPicker({
  required BuildContext context,
  required Function(String path) onSelected,
  bool allowPdf = true,
  bool allowImages = true,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkSecondary : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Sumber Input',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // 1. Professional AI Scan (4-point detection + Perspective Transform) 🤖✨
            _PickerItem(
              icon: Icons.auto_awesome_rounded,
              title: 'Professional AI Scan',
              subtitle: 'Deteksi 4-titik & perataan otomatis',
              color: Colors.purple,
              onTap: () async {
                Navigator.pop(context);
                try {
                  final tempDir = await getTemporaryDirectory();
                  final scanPath = p.join(
                    tempDir.path,
                    "scan_${DateTime.now().millisecondsSinceEpoch}.jpg",
                  );

                  bool success = await EdgeDetection.detectEdge(
                    scanPath,
                    canUseGallery: true,
                    androidScanTitle: 'Scan Dokumen',
                  );

                  if (success) {
                    onSelected(scanPath);
                  }
                } catch (e) {
                  debugPrint('Edge detection error: $e');
                }
              },
            ),

            // 2. Quick Batch Scan (Our custom UI for fast multiple pages) 📸⚡
            _PickerItem(
              icon: Icons.camera_roll_rounded,
              title: 'Quick Batch Scan',
              subtitle: 'Ambil banyak halaman dengan cepat',
              color: Colors.orange,
              onTap: () async {
                Navigator.pop(context);
                final result = await Get.toNamed(AppRoutes.smartScanner);
                if (result != null && result is String) {
                  onSelected(result);
                }
              },
            ),

            if (allowImages) ...[
              _PickerItem(
                icon: Icons.camera_alt_rounded,
                title: 'Kamera Biasa',
                subtitle: 'Ambil foto tanpa deteksi AI',
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final res =
                      await picker.pickImage(source: ImageSource.camera);
                  if (res != null) onSelected(res.path);
                },
              ),
              _PickerItem(
                icon: Icons.photo_library_rounded,
                title: AppStrings.pickFromGallery,
                subtitle: 'Pilih dari galeri foto hp',
                color: Colors.green,
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final res =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (res != null) onSelected(res.path);
                },
              ),
            ],

            if (allowPdf)
              _PickerItem(
                icon: Icons.picture_as_pdf_rounded,
                title: AppStrings.pickFromFiles,
                subtitle: 'Pilih file PDF dari penyimpanan',
                color: AppColors.primary,
                onTap: () async {
                  Navigator.pop(context);
                  final path = await pickPdfFile();
                  if (path != null) onSelected(path);
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

class _PickerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PickerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
      onTap: onTap,
    );
  }
}
