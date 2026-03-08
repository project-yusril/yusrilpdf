import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../../features/tools/domain/entities/pdf_entities.dart';
import '../../../../core/utils/logger_utils.dart';
import '../../../../core/utils/pdf_utils.dart';
import '../../../../core/utils/file_utils.dart';

enum ProcessState { idle, processing, success, error }

class ToolsProvider extends ChangeNotifier {
  static const String _tag = 'ToolsProvider';

  ProcessState _state = ProcessState.idle;
  String? _errorMessage;
  String? _outputPath;
  double _progress = 0;

  ProcessState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get outputPath => _outputPath;
  double get progress => _progress;
  bool get isProcessing => _state == ProcessState.processing;

  void setProcessing(String toolName) {
    LoggerService.info('Processing started for: $toolName', tag: _tag);
    _state = ProcessState.processing;
    _progress = 0;
    _errorMessage = null;
    _outputPath = null;
    notifyListeners();
  }

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setSuccess(ProcessResult result) {
    LoggerService.info('Process success: ${result.outputPath}', tag: _tag);
    _state = ProcessState.success;
    _outputPath = result.outputPath;
    _progress = 1.0;
    notifyListeners();
  }

  void setError(String message, {Object? error}) {
    LoggerService.error('Process error: $message', tag: _tag, error: error);
    _state = ProcessState.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Generic handler for PDF operations
  Future<void> runPdfOperation({
    required String toolName,
    required Future<String?> Function() operation,
  }) async {
    setProcessing(toolName);
    try {
      // Simulate some progress for better UI experience
      await Future.delayed(const Duration(milliseconds: 500));
      setProgress(0.3);

      final resultPath = await operation();

      if (resultPath != null) {
        setProgress(0.8);
        await Future.delayed(const Duration(milliseconds: 300));
        setSuccess(ProcessResult.success(resultPath));
      } else {
        setError('Gagal memproses PDF. Silakan cek file Anda.');
      }
    } catch (e) {
      setError('Terjadi kesalahan sistem: $e', error: e);
    }
  }

  // --- Real Operations ---

  /// Merge multiple PDFs
  Future<void> mergePdfs(List<String> paths) async {
    await runPdfOperation(
      toolName: 'Merge PDF',
      operation: () => PdfUtils.mergePdfs(paths),
    );
  }

  /// Rotate PDF
  Future<void> rotatePdf(String path, int angle) async {
    await runPdfOperation(
      toolName: 'Rotate PDF',
      operation: () => PdfUtils.rotatePdf(path, angle),
    );
  }

  /// Compress PDF
  Future<void> compressPdf(String path, int qualityLevel) async {
    await runPdfOperation(
      toolName: 'Compress PDF',
      operation: () => PdfUtils.compressPdf(path, qualityLevel),
    );
  }

  /// JPG to PDF
  Future<void> jpgToPdf(List<String> paths) async {
    await runPdfOperation(
      toolName: 'JPG to PDF',
      operation: () => PdfUtils.jpgToPdf(paths),
    );
  }

  /// Generic process for remaining tools
  Future<void> processTool(String toolName, String? inputPath) async {
    if (inputPath == null) return;

    // Handle batch paths (comma separated)
    final List<String> paths = inputPath.contains(',')
        ? inputPath.split(',').where((p) => p.isNotEmpty).toList()
        : [inputPath];

    if (toolName == 'Scan to PDF' || toolName == 'JPG to PDF') {
      await jpgToPdf(paths);
      return;
    }

    await runPdfOperation(
      toolName: toolName,
      operation: () async {
        await Future.delayed(const Duration(seconds: 2));

        String outputDir;
        if (Platform.isAndroid) {
          outputDir = '/storage/emulated/0/Download/YusrilPDF';
        } else {
          final dir = await getApplicationDocumentsDirectory();
          outputDir = dir.path;
        }

        final dir = Directory(outputDir);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        return p.join(
            outputDir,
            FileUtils.generateOutputName(
                toolName.toLowerCase().replaceAll(' ', '_'), 'pdf'));
      },
    );
  }

  void reset() {
    _state = ProcessState.idle;
    _errorMessage = null;
    _outputPath = null;
    _progress = 0;
    notifyListeners();
  }
}
