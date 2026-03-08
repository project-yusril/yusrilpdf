import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../features/tools/domain/entities/pdf_entities.dart';

class FilesProvider extends ChangeNotifier {
  List<PdfFileEntity> _files = [];
  bool _isLoading = false;
  String _sortBy = 'date'; // 'date', 'name', 'size'

  List<PdfFileEntity> get files => _files;
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;

  Future<void> loadFiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<PdfFileEntity> result = [];
      final List<Directory> dirsToScan = [];

      // 1. Scan internal app directory (all platforms)
      dirsToScan.add(await getApplicationDocumentsDirectory());

      // 2. Scan public Downloads directory (Android only)
      if (Platform.isAndroid) {
        final downloadDir = Directory('/storage/emulated/0/Download/YusrilPDF');
        if (downloadDir.existsSync()) {
          dirsToScan.add(downloadDir);
        }
      }

      for (final dir in dirsToScan) {
        if (dir.existsSync()) {
          final entities = dir.listSync(recursive: false);
          for (final entity in entities) {
            if (entity is File && FileUtils.isPdf(entity.path)) {
              // Avoid duplicates if same path is scanned twice (unlikely here but safe)
              if (!result.any((e) => e.path == entity.path)) {
                result.add(PdfFileEntity.fromFile(entity));
              }
            }
          }
        }
      }

      _files = result;
      _sortFiles();
    } catch (e) {
      debugPrint('Error loading files: $e');
      _files = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _sortFiles();
    notifyListeners();
  }

  void _sortFiles() {
    switch (_sortBy) {
      case 'name':
        _files.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'size':
        _files.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
        break;
      default:
        _files.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    }
  }

  Future<void> deleteFile(PdfFileEntity file) async {
    try {
      final f = File(file.path);
      if (f.existsSync()) await f.delete();
      _files.removeWhere((e) => e.id == file.id);
      notifyListeners();
    } catch (_) {}
  }

  void addFile(PdfFileEntity file) {
    _files.removeWhere((e) => e.path == file.path);
    _files.insert(0, file);
    notifyListeners();
  }
}
