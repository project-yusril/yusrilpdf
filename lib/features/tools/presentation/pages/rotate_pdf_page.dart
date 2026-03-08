import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class RotatePdfPage extends StatefulWidget {
  const RotatePdfPage({super.key});

  @override
  State<RotatePdfPage> createState() => _RotatePdfPageState();
}

class _RotatePdfPageState extends State<RotatePdfPage> {
  String? _filePath;
  int _angle = 90;

  void _onTapPicker() {
    showSmartPicker(
      context: context,
      onSelected: (path) => setState(() => _filePath = path),
      allowPdf: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseToolPage(
      title: AppStrings.rotatePdf,
      description: AppStrings.rotatePdfDesc,
      icon: Icons.rotate_right_rounded,
      color: AppColors.catOptimize,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilePickerTile(
              filePath: _filePath,
              onTap: _onTapPicker,
              onRemove: () => setState(() => _filePath = null),
            ),
            const SizedBox(height: 24),
            Text(
              'Sudut Rotasi',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark ? AppColors.textPrimary : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [90, 180, 270].map((a) {
                final isSelected = _angle == a;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _angle = a),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.catOptimize.withValues(alpha: 0.12)
                            : isDark
                                ? AppColors.bgDarkCard
                                : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.catOptimize
                              : AppColors.divider,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$a°',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isSelected
                                ? AppColors.catOptimize
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            if (provider.state == ProcessState.success &&
                provider.outputPath != null) ...[
              ResultCard(
                outputPath: provider.outputPath!,
                onOpen: () => OpenFile.open(provider.outputPath),
                onShare: () => Share.shareXFiles([XFile(provider.outputPath!)]),
              ),
              const SizedBox(height: 12),
            ],
            ProcessButton(
              label: 'Putar PDF',
              icon: Icons.rotate_right_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async {
                      await provider.rotatePdf(_filePath!, _angle);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
