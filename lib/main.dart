import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/tools/presentation/providers/tools_provider.dart';
import 'features/files/presentation/providers/files_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'navigation/app_pages.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local DB
  // await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ToolsProvider()),
        ChangeNotifierProvider(create: (_) => FilesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const YusrilPdfApp(),
    ),
  );
}

class YusrilPdfApp extends StatelessWidget {
  const YusrilPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: profileProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
    );
  }
}
