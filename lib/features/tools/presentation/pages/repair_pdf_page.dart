import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class RepairPdfPage extends StatefulWidget {
  const RepairPdfPage({super.key});
  @override
  State<RepairPdfPage> createState() => _RepairPdfPageState();
}

class _RepairPdfPageState extends State<RepairPdfPage> {
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
      title: AppStrings.repairPdf,
      description: AppStrings.repairPdfDesc,
      icon: Icons.build_circle_rounded,
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
              label: 'Perbaiki PDF',
              icon: Icons.build_circle_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null
                  ? () async => await provider.processTool(
                      AppStrings.repairPdf, _filePath)
                  : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
