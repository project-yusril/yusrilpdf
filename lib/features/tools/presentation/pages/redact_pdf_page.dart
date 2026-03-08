import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';
class RedactPdfPage extends StatefulWidget {
  const RedactPdfPage({super.key});
  @override
  State<RedactPdfPage> createState() => _RedactPdfPageState();
}

class _RedactPdfPageState extends State<RedactPdfPage> {
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    return BaseToolPage(
      title: AppStrings.redactPdf,
      description: '',
      icon: Icons.remove_circle_rounded,
      color: AppColors.catEdit,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilePickerTile(
              filePath: _filePath,
              onTap: () async {
                final path = await pickAnyFile(['pdf']);
                if (path != null) setState(() => _filePath = path);
              },
              onRemove: () => setState(() => _filePath = null),
            ),
            const Spacer(),
            if (provider.state == ProcessState.success && provider.outputPath != null) ...[
              ResultCard(
                outputPath: provider.outputPath!,
                onOpen: () => OpenFile.open(provider.outputPath),
                onShare: () => Share.shareXFiles([XFile(provider.outputPath!)]),
              ),
              const SizedBox(height: 12),
            ],
            if (provider.state == ProcessState.error && provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(provider.errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ),
            ProcessButton(
              label: 'Redaksi PDF',
              icon: Icons.remove_circle_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null ? () async => await provider.processTool(AppStrings.redactPdf, _filePath) : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

