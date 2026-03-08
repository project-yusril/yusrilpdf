import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/tools_data.dart';
import '../../../../features/tools/domain/entities/pdf_tool_model.dart';
import '../providers/home_provider.dart';
import '../../../../navigation/main_wrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Request permissions on home detection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeProvider>().requestPermissions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, isDark),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildBanner(context),
                  const SizedBox(height: 28),
                  _buildQuickTools(context),
                  const SizedBox(height: 28),
                  _buildRecentSection(context),
                  const SizedBox(height: 28),
                  _buildAllCategoriesPreview(context),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      expandedHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color:
                isDark ? AppColors.textSecondary : AppColors.textDarkSecondary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53E3E), Color(0xFFFF6B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '29 PDF Tools',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Semua kebutuhan PDF ada di sini.\nMerge, split, compress, convert & lebih banyak!',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              final nav = Get.find<NavigationController>();
              nav.changePage(1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Lihat Semua Tools',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTools(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final tools = provider.quickAccessTools;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Akses Cepat',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                final nav = Get.find<NavigationController>();
                nav.changePage(1);
              },
              child: Text(
                'Lihat Semua',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                (constraints.maxWidth / 110).floor().clamp(3, 6);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: tools.length,
              itemBuilder: (context, i) => _ToolCard(
                tool: tools[i],
                onTap: () {
                  provider.addRecent(tools[i].id);
                  Get.toNamed(tools[i].route);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentSection(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final recent = provider.recentTools;
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Baru Digunakan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recent.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _RecentToolChip(
              tool: recent[i],
              onTap: () {
                provider.addRecent(recent[i].id);
                Get.toNamed(recent[i].route);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllCategoriesPreview(BuildContext context) {
    final categories = ToolCategory.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...categories.map((cat) => _CategoryRow(category: cat)),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final PdfToolModel tool;
  final VoidCallback onTap;
  const _ToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.divider : AppColors.dividerLight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tool.icon, color: tool.color, size: 24),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                tool.title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimary : AppColors.textDark,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentToolChip extends StatelessWidget {
  final PdfToolModel tool;
  final VoidCallback onTap;
  const _RecentToolChip({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.divider : AppColors.dividerLight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tool.icon, color: tool.color, size: 24),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                tool.title,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.textDarkSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ToolCategory category;
  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tools = ToolsData.getByCategory(category);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.divider : AppColors.dividerLight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getCategoryIcon(category),
            color: category.color,
            size: 20,
          ),
        ),
        title: Text(
          category.label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          '${tools.length} tools',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textHint),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textHint,
          size: 20,
        ),
        onTap: () {
          final nav = Get.find<NavigationController>();
          nav.changePage(1);
        },
      ),
    );
  }

  IconData _getCategoryIcon(ToolCategory cat) {
    switch (cat) {
      case ToolCategory.optimize:
        return Icons.tune_rounded;
      case ToolCategory.convertTo:
        return Icons.upload_file_rounded;
      case ToolCategory.convertFrom:
        return Icons.download_rounded;
      case ToolCategory.editSecurity:
        return Icons.shield_rounded;
      case ToolCategory.advanced:
        return Icons.auto_awesome_rounded;
    }
  }
}
