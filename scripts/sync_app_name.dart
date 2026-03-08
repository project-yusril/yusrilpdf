// ignore_for_file: avoid_print
import 'dart:io';

/// Script untuk sinkronisasi nama aplikasi dari AppConfig ke file native (Android & iOS)
/// Jalankan dengan: dart scripts/sync_app_name.dart
void main() {
  final appConfigPath = 'lib/core/config/app_config.dart';
  final androidManifestPath = 'android/app/src/main/AndroidManifest.xml';
  final iosPlistPath = 'ios/Runner/Info.plist';

  final appConfigContent = File(appConfigPath).readAsStringSync();

  // Extract appName using regex
  final nameMatch = RegExp(r"static const String appName = '(.+?)';")
      .firstMatch(appConfigContent);
  if (nameMatch == null) {
    print('❌ Gagal nemuin appName di AppConfig.dart bro!');
    return;
  }

  final newName = nameMatch.group(1)!;
  print('🚀 Sinkronisasi nama aplikasi ke: $newName...');

  // 1. Update Android
  if (File(androidManifestPath).existsSync()) {
    var content = File(androidManifestPath).readAsStringSync();
    content = content.replaceFirst(
        RegExp(r'android:label=".+?"'), 'android:label="$newName"');
    File(androidManifestPath).writeAsStringSync(content);
    print('✅ AndroidManifest.xml diupdate!');
  }

  // 2. Update iOS
  if (File(iosPlistPath).existsSync()) {
    var content = File(iosPlistPath).readAsStringSync();

    // Update CFBundleDisplayName
    content = content.replaceFirst(
        RegExp(r'<key>CFBundleDisplayName</key>\s*<string>.+?</string>'),
        '<key>CFBundleDisplayName</key>\n\t<string>$newName</string>');

    // Update CFBundleName
    content = content.replaceFirst(
        RegExp(r'<key>CFBundleName</key>\s*<string>.+?</string>'),
        '<key>CFBundleName</key>\n\t<string>$newName</string>');

    File(iosPlistPath).writeAsStringSync(content);
    print('✅ Info.plist diupdate!');
  }

  print(
      '\n🔥 BERES! Nama aplikasi sekarang jadi "$newName" di semua platform.');
  print(
      'Silakan restart aplikasi atau rebuild (flutter run) buat liat perubahannya bro! 🚀');
}
