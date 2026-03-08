import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/tools_data.dart';
import '../../../../features/tools/domain/entities/pdf_tool_model.dart';
import '../../../home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ToolCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildSearchBar(context, isDark),
            _buildCategoryFilter(context, isDark),
            Expanded(child: _buildToolsGrid(context, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Text(
            'PDF Tools',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimary : AppColors.textDark,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '29 Tools',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Cari tool...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, bool isDark) {
    final cats = [null, ...ToolCategory.values];
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: cats.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final cat = cats[i];
            final isSelected = _selectedCategory == cat;
            final color = cat?.color ?? AppColors.primary;
            final label = cat?.label ?? 'Semua';
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToolsGrid(BuildContext context, bool isDark) {
    final homeProvider = context.read<HomeProvider>();
    List<PdfToolModel> tools;

    if (_searchQuery.isNotEmpty) {
      tools = ToolsData.search(_searchQuery);
    } else if (_selectedCategory != null) {
      tools = ToolsData.getByCategory(_selectedCategory!);
    } else {
      tools = ToolsData.allTools;
    }

    if (tools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 60, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'Tool tidak ditemukan',
              style: GoogleFonts.inter(color: AppColors.textHint, fontSize: 15),
            ),
          ],
        ),
      );
    }

    // Group by category when not searching
    if (_searchQuery.isEmpty && _selectedCategory == null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
        children: ToolCategory.values.map((cat) {
          final catTools = ToolsData.getByCategory(cat);
          return _CategorySection(
            category: cat,
            tools: catTools,
            onToolTap: (tool) {
              homeProvider.addRecent(tool.id);
              Get.toNamed(tool.route);
            },
          );
        }).toList(),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = (screenWidth / 120).floor().clamp(3, 6);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tools.length,
      itemBuilder: (context, i) {
        final tool = tools[i];
        return _SmallToolCard(
          tool: tool,
          onTap: () {
            homeProvider.addRecent(tool.id);
            Get.toNamed(tool.route);
          },
        );
      },
    );
  }
}

class _CategorySection extends StatelessWidget {
  final ToolCategory category;
  final List<PdfToolModel> tools;
  final Function(PdfToolModel) onToolTap;
  const _CategorySection({
    required this.category,
    required this.tools,
    required this.onToolTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 20,
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category.label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDark ? AppColors.textPrimary : AppColors.textDark,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${tools.length})',
                style: GoogleFonts.inter(
                  color: AppColors.textHint,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                (constraints.maxWidth / 110).floor().clamp(3, 6);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: tools.length,
              itemBuilder: (_, i) => _SmallToolCard(
                  tool: tools[i], onTap: () => onToolTap(tools[i])),
            );
          },
        ),
      ],
    );
  }
}

class _SmallToolCard extends StatelessWidget {
  final PdfToolModel tool;
  final VoidCallback onTap;
  const _SmallToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(tool.icon, color: tool.color, size: 24),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                tool.title,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
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
