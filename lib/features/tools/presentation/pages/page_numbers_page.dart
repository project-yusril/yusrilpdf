import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';
class PageNumbersPage extends StatefulWidget {
  const PageNumbersPage({super.key});
  @override
  State<PageNumbersPage> createState() => _PageNumbersPageState();
}

class _PageNumbersPageState extends State<PageNumbersPage> {
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    return BaseToolPage(
      title: AppStrings.pageNumbers,
      description: '',
      icon: Icons.format_list_numbered_rounded,
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
              label: 'Tambah Nomor Halaman',
              icon: Icons.format_list_numbered_rounded,
              isLoading: provider.isProcessing,
              onPressed: _filePath != null ? () async => await provider.processTool(AppStrings.pageNumbers, _filePath) : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

