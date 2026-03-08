import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class JpgToPdfPage extends StatefulWidget {
  const JpgToPdfPage({super.key});
  @override
  State<JpgToPdfPage> createState() => _JpgToPdfPageState();
}

class _JpgToPdfPageState extends State<JpgToPdfPage> {
  String? _filePath;

  void _onTapPicker() {
    showSmartPicker(
      context: context,
      onSelected: (path) => setState(() => _filePath = path),
      allowPdf: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    return BaseToolPage(
      title: AppStrings.jpgToPdf,
      description: '',
      icon: Icons.image_rounded,
      color: AppColors.catConvertTo,
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
              label: 'Konversi ke PDF',
              icon: Icons.image_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async {
                      await provider.jpgToPdf([_filePath!]);
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
