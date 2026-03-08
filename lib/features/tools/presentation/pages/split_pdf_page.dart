import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class SplitPdfPage extends StatefulWidget {
  const SplitPdfPage({super.key});
  @override
  State<SplitPdfPage> createState() => _SplitPdfPageState();
}

class _SplitPdfPageState extends State<SplitPdfPage> {
  String? _filePath;
  final _rangeController = TextEditingController(text: '1-3');
  String _splitMode = 'range'; // 'range', 'every', 'all'

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
      title: AppStrings.splitPdf,
      description: AppStrings.splitPdfDesc,
      icon: Icons.call_split_rounded,
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
              'Mode Split:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'range',
                    label: Text('Range', style: TextStyle(fontSize: 11)),
                    icon: Icon(Icons.date_range_rounded, size: 16),
                  ),
                  ButtonSegment(
                    value: 'every',
                    label: Text('Setiap 1', style: TextStyle(fontSize: 11)),
                    icon: Icon(Icons.filter_1_rounded, size: 16),
                  ),
                  ButtonSegment(
                    value: 'all',
                    label: Text('Semua', style: TextStyle(fontSize: 11)),
                    icon: Icon(Icons.select_all_rounded, size: 16),
                  ),
                ],
                selected: {_splitMode},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() => _splitMode = newSelection.first);
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.1),
                  selectedForegroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (_splitMode == 'range') ...[
              const SizedBox(height: 20),
              Text(
                'Masukkan Range Halaman:',
                style:
                    GoogleFonts.inter(fontSize: 13, color: AppColors.textHint),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rangeController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 1-3, 5, 7-10',
                  labelText: 'Range Halaman',
                ),
              ),
            ],
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
              label: 'Pisahkan PDF',
              isLoading: provider.isProcessing,
              icon: Icons.call_split_rounded,
              onPressed: _filePath != null
                  ? () async {
                      await provider.processTool(
                          AppStrings.splitPdf, _filePath);
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
