import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../features/files/presentation/providers/files_provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/tools/presentation/pages/tools_page.dart';
import '../features/files/presentation/pages/files_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/tools/presentation/widgets/base_tool_page.dart';
import '../core/constants/app_routes.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    const HomePage(),
    const ToolsPage(),
    const FilesPage(),
    const ProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: _BottomNavBar(controller: controller),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final NavigationController controller;
  const _BottomNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final bgColor = isDark ? AppColors.bgDarkSecondary : Colors.white;
      final selectedColor = AppColors.primary;
      final unselectedColor =
          isDark ? AppColors.textHint : const Color(0xFFAAAAAA);
      final currentIndex = controller.currentIndex.value;

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70, // Increased from 64 to 70 to prevent 4px overflow 🚀
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  isSelected: currentIndex == 0,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                  onTap: () => controller.changePage(0),
                ),
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: AppStrings.navTools,
                  isSelected: currentIndex == 1,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                  onTap: () => controller.changePage(1),
                ),
                // Camera center button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showSmartPicker(
                        context: context,
                        onSelected: (path) {
                          Get.toNamed(AppRoutes.scanToPdf, arguments: path);
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(
                              10), // Use padding instead of fixed size 📏
                          decoration: BoxDecoration(
                            gradient: currentIndex == 2
                                ? const LinearGradient(
                                    colors: AppColors.primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: currentIndex == 2
                                ? null // Gradient handles color when selected
                                : (isDark
                                    ? AppColors.bgDarkCard
                                    : AppColors.bgLight),
                            shape: BoxShape.circle,
                            boxShadow: currentIndex == 2
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: currentIndex == 2
                                ? Colors.white
                                : unselectedColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.navCamera,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.folder_rounded,
                  label: AppStrings.navFiles,
                  isSelected: currentIndex == 2,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                  onTap: () {
                    controller.changePage(2);
                    context.read<FilesProvider>().loadFiles();
                  },
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: AppStrings.navProfile,
                  isSelected: currentIndex == 3,
                  selectedColor: selectedColor,
                  unselectedColor: unselectedColor,
                  onTap: () => controller.changePage(3),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
