import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../features/tools/domain/entities/pdf_entities.dart';
import '../providers/files_provider.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilesProvider>().loadFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<FilesProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark, provider),
            if (provider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (provider.files.isEmpty)
              _buildEmpty(isDark)
            else
              Expanded(child: _buildFileList(context, isDark, provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    FilesProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Text(
            'Files',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimary : AppColors.textDark,
            ),
          ),
          const Spacer(),
          _SortButton(current: provider.sortBy, onChanged: provider.setSortBy),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.textHint),
            onPressed: () => context.read<FilesProvider>().loadFiles(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada file',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimary : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'File hasil proses akan muncul di sini',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(
    BuildContext context,
    bool isDark,
    FilesProvider provider,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      itemCount: provider.files.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _FileCard(
        file: provider.files[i],
        isDark: isDark,
        onDelete: () =>
            context.read<FilesProvider>().deleteFile(provider.files[i]),
        onShare: () async {
          final f = provider.files[i];
          await Share.shareXFiles([XFile(f.path)], text: f.name);
        },
        onOpen: () => OpenFile.open(provider.files[i].path),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String current;
  final Function(String) onChanged;
  const _SortButton({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'date',
          child: Row(
            children: [
              if (current == 'date')
                const Icon(Icons.check, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Tanggal'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'name',
          child: Row(
            children: [
              if (current == 'name')
                const Icon(Icons.check, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Nama'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'size',
          child: Row(
            children: [
              if (current == 'size')
                const Icon(Icons.check, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Ukuran'),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'Urutkan',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final PdfFileEntity file;
  final bool isDark;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onOpen;
  const _FileCard({
    required this.file,
    required this.isDark,
    required this.onDelete,
    required this.onShare,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.divider : AppColors.dividerLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.textPrimary : AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${file.formattedSize}  •  ${FileUtils.formatDate(file.lastModified)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'share') onShare();
                if (v == 'delete') onDelete();
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppColors.textHint,
                size: 20,
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded, size: 16),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
