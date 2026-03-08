import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class OcrPdfPage extends StatefulWidget {
  const OcrPdfPage({super.key});
  @override
  State<OcrPdfPage> createState() => _OcrPdfPageState();
}

class _OcrPdfPageState extends State<OcrPdfPage> {
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
      title: AppStrings.ocrPdf,
      description: '',
      icon: Icons.document_scanner_rounded,
      color: AppColors.catAdvanced,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilePickerTile(
              filePath: _filePath,
              hint: 'Tap untuk Scan atau pilih File/Gambar',
              onTap: _onTapPicker,
              onRemove: () => setState(() => _filePath = null),
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
            if (provider.state == ProcessState.error &&
                provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(provider.errorMessage!,
                    style:
                        const TextStyle(color: AppColors.error, fontSize: 13)),
              ),
            ProcessButton(
              label: 'Jalankan OCR',
              icon: Icons.document_scanner_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async =>
                      await provider.processTool(AppStrings.ocrPdf, _filePath)
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
