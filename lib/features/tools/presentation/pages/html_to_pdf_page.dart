import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/tools_provider.dart';
import '../widgets/base_tool_page.dart';

class HtmlToPdfPage extends StatefulWidget {
  const HtmlToPdfPage({super.key});
  @override
  State<HtmlToPdfPage> createState() => _HtmlToPdfPageState();
}

class _HtmlToPdfPageState extends State<HtmlToPdfPage> {
  final _urlController = TextEditingController();
  final _htmlController = TextEditingController();
  String _mode = 'url'; // 'url', 'html'

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ToolsProvider>();
    return BaseToolPage(
      title: AppStrings.htmlToPdf,
      description: AppStrings.htmlToPdfDesc,
      icon: Icons.language_rounded,
      color: AppColors.catConvertTo,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode selector
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = 'url'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _mode == 'url'
                            ? AppColors.catConvertTo.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _mode == 'url'
                              ? AppColors.catConvertTo
                              : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: _mode == 'url'
                                ? AppColors.catConvertTo
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'URL Website',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _mode == 'url'
                                  ? AppColors.catConvertTo
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = 'html'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _mode == 'html'
                            ? AppColors.catConvertTo.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _mode == 'html'
                              ? AppColors.catConvertTo
                              : AppColors.divider,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.code_rounded,
                            color: _mode == 'html'
                                ? AppColors.catConvertTo
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'HTML Code',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _mode == 'html'
                                  ? AppColors.catConvertTo
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_mode == 'url') ...[
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com',
                  labelText: 'URL Website',
                  prefixIcon: Icon(Icons.link_rounded),
                ),
                keyboardType: TextInputType.url,
              ),
            ] else ...[
              TextField(
                controller: _htmlController,
                decoration: const InputDecoration(
                  hintText: '<html><body><h1>Hello PDF!</h1></body></html>',
                  labelText: 'HTML Code',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),
            ],
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
              label: 'Konversi ke PDF',
              icon: Icons.language_rounded,
              isLoading: provider.isProcessing,
              onPressed: (_mode == 'url'
                      ? _urlController.text.isNotEmpty
                      : _htmlController.text.isNotEmpty)
                  ? () async {
                      await provider.processTool(
                          AppStrings.htmlToPdf,
                          _mode == 'url'
                              ? _urlController.text
                              : _htmlController.text);
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
