import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class CropPdfPage extends StatefulWidget {
  const CropPdfPage({super.key});
  @override
  State<CropPdfPage> createState() => _CropPdfPageState();
}

class _CropPdfPageState extends State<CropPdfPage> {
  String? _filePath;

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
      title: AppStrings.cropPdf,
      description: AppStrings.cropPdfDesc,
      icon: Icons.crop_rounded,
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
            const SizedBox(height: 16),
            Text('Margin Crop (mm):',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 10),
            ...['Atas', 'Bawah', 'Kiri', 'Kanan'].map((side) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(labelText: side),
                    keyboardType: TextInputType.number,
                  ),
                )),
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
              label: 'Crop PDF',
              icon: Icons.crop_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async =>
                      await provider.processTool(AppStrings.cropPdf, _filePath)
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
