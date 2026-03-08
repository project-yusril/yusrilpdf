import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/tools_data.dart';
import '../../../../features/tools/domain/entities/pdf_tool_model.dart';
import '../../../../core/utils/logger_utils.dart';

class HomeProvider extends ChangeNotifier {
  final List<String> _recentToolIds = [];
  final List<String> quickAccessIds = [
    'merge_pdf',
    'compress_pdf',
    'jpg_to_pdf',
    'pdf_to_word',
    'protect_pdf',
    'ocr_pdf',
  ];

  List<String> get recentToolIds => _recentToolIds;

  List<PdfToolModel> get quickAccessTools => quickAccessIds
      .map((id) => ToolsData.getById(id))
      .whereType<PdfToolModel>()
      .toList();

  List<PdfToolModel> get recentTools => _recentToolIds
      .map((id) => ToolsData.getById(id))
      .whereType<PdfToolModel>()
      .toList();

  /// Request essential permissions for the app
  Future<void> requestPermissions() async {
    LoggerService.info('Requesting device permissions...', tag: 'HomeProvider');

    // Request storage, notifications, camera, and photos
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.notification,
      Permission.camera,
      Permission.photos,
      // For Android 11+ (API 30+)
      Permission.manageExternalStorage,
    ].request();

    statuses.forEach((permission, status) {
      LoggerService.info('Permission ${permission.toString()}: $status',
          tag: 'HomeProvider');
    });

    if (statuses[Permission.storage]!.isDenied ||
        statuses[Permission.notification]!.isDenied) {
      LoggerService.warning('Some essential permissions were denied.',
          tag: 'HomeProvider');
    }
  }

  void addRecent(String toolId) {
    _recentToolIds.remove(toolId);
    _recentToolIds.insert(0, toolId);
    if (_recentToolIds.length > 8) {
      _recentToolIds.removeLast();
    }
    notifyListeners();
  }

  void clearRecent() {
    _recentToolIds.clear();
    notifyListeners();
  }
}
