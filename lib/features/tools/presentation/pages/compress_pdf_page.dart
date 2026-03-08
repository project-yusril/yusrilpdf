import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class CompressPdfPage extends StatefulWidget {
  const CompressPdfPage({super.key});
  @override
  State<CompressPdfPage> createState() => _CompressPdfPageState();
}

class _CompressPdfPageState extends State<CompressPdfPage> {
  String? _filePath;
  String _quality = 'medium'; // 'low', 'medium', 'high'

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
    return BaseToolPage(
      title: AppStrings.compressPdf,
      description: AppStrings.compressPdfDesc,
      icon: Icons.compress_rounded,
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
            const SizedBox(height: 20),
            Text(
              'Kualitas Kompresi:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ('low', 'Rendah\n(Terkecil)', AppColors.success),
                ('medium', 'Sedang\n(Seimbang)', AppColors.warning),
                ('high', 'Tinggi\n(Terbaik)', AppColors.error),
              ].map((item) {
                final isSelected = _quality == item.$1;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _quality = item.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.$3.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? item.$3 : AppColors.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.circle, color: item.$3, size: 14),
                          const SizedBox(height: 6),
                          Text(
                            item.$2.split('\n')[0],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? item.$3 : AppColors.textHint,
                            ),
                          ),
                          Text(
                            item.$2.split('\n')[1],
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            if (provider.state == ProcessState.success &&
                provider.outputPath != null)
              ResultCard(
                outputPath: provider.outputPath!,
                onOpen: () => OpenFile.open(provider.outputPath),
                onShare: () => Share.shareXFiles([XFile(provider.outputPath!)]),
              ),
            const SizedBox(height: 12),
            ProcessButton(
              label: 'Kompres PDF',
              icon: Icons.compress_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async {
                      final level = _quality == 'low'
                          ? 3
                          : (_quality == 'medium' ? 2 : 1);
                      await provider.compressPdf(_filePath!, level);
                    }
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
