import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

class FileUtils {
  /// Get file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get file extension without dot
  static String getExtension(String path) {
    return p.extension(path).replaceFirst('.', '').toUpperCase();
  }

  /// Get filename without extension
  static String getBaseName(String path) {
    return p.basenameWithoutExtension(path);
  }

  /// Get full filename with extension
  static String getFileName(String path) {
    return p.basename(path);
  }

  /// Format file modified date
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Format date short
  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Check if path is a PDF file
  static bool isPdf(String path) {
    return p.extension(path).toLowerCase() == '.pdf';
  }

  /// Check if path is an image file
  static bool isImage(String path) {
    final ext = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp', '.bmp'].contains(ext);
  }

  /// Get file size from path
  static String getFileSizeFromPath(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        return formatFileSize(file.lengthSync());
      }
    } catch (_) {}
    return '0 B';
  }

  /// Generate output file name with timestamp
  static String generateOutputName(String prefix, String extension) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${prefix}_$timestamp.$extension';
  }
}
