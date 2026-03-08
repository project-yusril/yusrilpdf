import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/file_utils.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class MergePdfPage extends StatefulWidget {
  const MergePdfPage({super.key});
  @override
  State<MergePdfPage> createState() => _MergePdfPageState();
}

class _MergePdfPageState extends State<MergePdfPage> {
  final List<String> _files = [];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseToolPage(
      title: AppStrings.mergePdf,
      description: AppStrings.mergePdfDesc,
      icon: Icons.call_merge_rounded,
      color: AppColors.catOptimize,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambahkan file PDF yang ingin digabung (minimal 2)',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textHint),
            ),
            const SizedBox(height: 16),
            if (_files.isEmpty)
              FilePickerTile(hint: 'Tap untuk pilih file PDF', onTap: _addFile)
            else ...[
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _files.length,
                onReorder: _onReorder,
                itemBuilder: (_, i) => _FileTile(
                  key: ValueKey(_files[i]),
                  path: _files[i],
                  index: i,
                  isDark: isDark,
                  onRemove: () => setState(() => _files.removeAt(i)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _addFile,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(AppStrings.addFile),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
            const Spacer(),
            if (provider.state == ProcessState.success &&
                provider.outputPath != null) ...[
              ResultCard(
                outputPath: provider.outputPath!,
                onOpen: () => OpenFile.open(provider.outputPath),
                onShare: () => Share.shareXFiles([
                  XFile(provider.outputPath!),
                ], text: 'Merged PDF'),
              ),
              const SizedBox(height: 12),
            ],
            ProcessButton(
              label: 'Gabungkan PDF',
              isLoading: provider.isProcessing,
              icon: Icons.call_merge_rounded,
              onPressed: _files.length >= 2 ? () => _merge(provider) : null,
            ),
            if (provider.state == ProcessState.error &&
                provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _files.removeAt(oldIndex);
      _files.insert(newIndex, item);
    });
  }

  Future<void> _addFile() async {
    showSmartPicker(
      context: context,
      onSelected: (path) => setState(() => _files.add(path)),
      allowPdf: true,
    );
  }

  Future<void> _merge(ToolsProvider provider) async {
    await provider.mergePdfs(_files);
  }
}

class _FileTile extends StatelessWidget {
  final String path;
  final int index;
  final bool isDark;
  final VoidCallback onRemove;
  const _FileTile({
    super.key,
    required this.path,
    required this.index,
    required this.isDark,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.divider : AppColors.dividerLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              FileUtils.getFileName(path),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimary : AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(
            Icons.drag_handle_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.textHint,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
