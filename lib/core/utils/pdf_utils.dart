import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:ui';
import 'logger_utils.dart';
import 'file_utils.dart';

class PdfUtils {
  static const String _tag = 'PdfUtils';

  /// Merge multiple PDF files into one
  static Future<String?> mergePdfs(List<String> inputPaths) async {
    LoggerService.info('Starting merge for ${inputPaths.length} files',
        tag: _tag);
    try {
      final PdfDocument document = PdfDocument();

      for (final path in inputPaths) {
        LoggerService.debug('Merging file: $path', tag: _tag);
        final bytes = await File(path).readAsBytes();
        final PdfDocument sourceDoc = PdfDocument(inputBytes: bytes);

        // Use sourceDoc structure to merge
        for (int i = 0; i < sourceDoc.pages.count; i++) {
          document.pages.add().graphics.drawPdfTemplate(
                sourceDoc.pages[i].createTemplate(),
                Offset.zero,
              );
        }
        sourceDoc.dispose();
      }

      final output = await _saveDocument(document, 'merged');
      document.dispose();

      LoggerService.info('Merge successful: $output', tag: _tag);
      return output;
    } catch (e, stackTrace) {
      LoggerService.error('Merge failed',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Rotate PDF pages
  static Future<String?> rotatePdf(String inputPath, int angle) async {
    LoggerService.info('Starting rotation for $inputPath with angle $angle',
        tag: _tag);
    try {
      final bytes = await File(inputPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      PdfPageRotateAngle rotateAngle;
      switch (angle) {
        case 90:
          rotateAngle = PdfPageRotateAngle.rotateAngle90;
          break;
        case 180:
          rotateAngle = PdfPageRotateAngle.rotateAngle180;
          break;
        case 270:
          rotateAngle = PdfPageRotateAngle.rotateAngle270;
          break;
        default:
          rotateAngle = PdfPageRotateAngle.rotateAngle0;
      }

      for (int i = 0; i < document.pages.count; i++) {
        document.pages[i].rotation = rotateAngle;
      }

      final output = await _saveDocument(document, 'rotated');
      document.dispose();

      LoggerService.info('Rotation successful: $output', tag: _tag);
      return output;
    } catch (e, stackTrace) {
      LoggerService.error('Rotation failed',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Compress PDF (reduce image quality)
  static Future<String?> compressPdf(String inputPath, int qualityLevel) async {
    LoggerService.info(
        'Starting compression for $inputPath (Level: $qualityLevel)',
        tag: _tag);
    try {
      final bytes = await File(inputPath).readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      PdfCompressionLevel compressionLevel;
      switch (qualityLevel) {
        case 1:
          compressionLevel = PdfCompressionLevel.best;
          break;
        case 2:
          compressionLevel = PdfCompressionLevel.normal;
          break;
        case 3:
          compressionLevel = PdfCompressionLevel.belowNormal;
          break;
        default:
          compressionLevel = PdfCompressionLevel.normal;
      }

      document.compressionLevel = compressionLevel;

      final output = await _saveDocument(document, 'compressed');
      document.dispose();

      LoggerService.info('Compression successful: $output', tag: _tag);
      return output;
    } catch (e, stackTrace) {
      LoggerService.error('Compression failed',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Convert JPG/PNG to PDF
  static Future<String?> jpgToPdf(List<String> imagePaths) async {
    LoggerService.info('Starting Image to PDF for ${imagePaths.length} images',
        tag: _tag);
    try {
      final PdfDocument document = PdfDocument();

      for (final path in imagePaths) {
        final bytes = await File(path).readAsBytes();
        final PdfBitmap image = PdfBitmap(bytes);

        final PdfPage page = document.pages.add();
        page.graphics.drawImage(
          image,
          Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
        );
      }

      final output = await _saveDocument(document, 'image_converted');
      document.dispose();

      LoggerService.info('Image Conversion successful: $output', tag: _tag);
      return output;
    } catch (e, stackTrace) {
      LoggerService.error('Image Conversion failed',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Helper to save PDF document to a public/accessible directory
  static Future<String> _saveDocument(
      PdfDocument document, String prefix) async {
    final bytes = await document.save();
    final fileName = FileUtils.generateOutputName(prefix, 'pdf');
    String? dirPath;

    if (Platform.isAndroid) {
      // Try saving to Downloads folder for easy access by other apps
      final downloadDir = Directory('/storage/emulated/0/Download/YusrilPDF');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      dirPath = downloadDir.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      dirPath = directory.path;
    }

    final file = File(p.join(dirPath, fileName));
    await file.writeAsBytes(bytes);
    LoggerService.info('File saved at: ${file.path}', tag: _tag);
    return file.path;
  }
}
