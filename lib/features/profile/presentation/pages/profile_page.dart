import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimary : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileCard(isDark),
              const SizedBox(height: 20),
              _buildSection(context, 'Pengaturan', [
                _SettingsItem(
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: AppStrings.darkMode,
                  trailing: Switch(
                    value: provider.isDarkMode,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) => provider.toggleDarkMode(),
                  ),
                  isDark: isDark,
                ),
                _SettingsItem(
                  icon: Icons.language_rounded,
                  title: AppStrings.language,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.language == 'id' ? '🇮🇩 ID' : '🇺🇸 EN',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  isDark: isDark,
                  onTap: () => _showLanguageDialog(context, provider),
                ),
              ], isDark),
              const SizedBox(height: 16),
              _buildSection(context, 'Aplikasi', [
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  title: AppStrings.aboutApp,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  isDark: isDark,
                  onTap: () => _showAboutDialog(context),
                ),
                _SettingsItem(
                  icon: Icons.star_rate_rounded,
                  title: 'Beri Rating',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  isDark: isDark,
                ),
                _SettingsItem(
                  icon: Icons.delete_outline_rounded,
                  title: AppStrings.clearHistory,
                  iconColor: AppColors.error,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  isDark: isDark,
                ),
              ], isDark),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      AppStrings.appName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(
              Icons.person_rounded,
              size: 34,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yusril PDF User',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '29 PDF Tools siap digunakan',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> items,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgDarkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.divider : AppColors.dividerLight,
            ),
          ),
          child: Column(
            children: List.generate(
              items.length,
              (i) => Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      color: isDark
                          ? AppColors.divider
                          : AppColors.dividerLight,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('🇮🇩 Indonesia'),
              onTap: () {
                provider.setLanguage('id');
                Navigator.pop(context);
              },
              trailing: provider.language == 'id'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
            ),
            ListTile(
              title: const Text('🇺🇸 English'),
              onTap: () {
                provider.setLanguage('en');
                Navigator.pop(context);
              },
              trailing: provider.language == 'en'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Yusril Eka Mahendra',
      children: [
        const SizedBox(height: 8),
        const Text(
          'Aplikasi PDF tools lengkap dengan 29 fitur untuk keperluan pengolahan dokumen PDF.',
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final bool isDark;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.isDark,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isDark ? AppColors.textPrimary : AppColors.textDark,
        ),
      ),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
