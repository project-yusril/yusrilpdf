import 'dart:io';

class PdfFileEntity {
  final String id;
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime lastModified;
  final String? thumbnailPath;

  const PdfFileEntity({
    required this.id,
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.lastModified,
    this.thumbnailPath,
  });

  factory PdfFileEntity.fromFile(File file) {
    final stat = file.statSync();
    return PdfFileEntity(
      id: file.path.hashCode.toString(),
      path: file.path,
      name: file.path.split(Platform.pathSeparator).last,
      sizeBytes: stat.size,
      lastModified: stat.modified,
    );
  }

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  PdfFileEntity copyWith({
    String? id,
    String? path,
    String? name,
    int? sizeBytes,
    DateTime? lastModified,
    String? thumbnailPath,
  }) {
    return PdfFileEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      lastModified: lastModified ?? this.lastModified,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }
}

class ProcessResult {
  final bool isSuccess;
  final String? outputPath;
  final String? errorMessage;
  final int? outputSizeBytes;

  const ProcessResult({
    required this.isSuccess,
    this.outputPath,
    this.errorMessage,
    this.outputSizeBytes,
  });

  factory ProcessResult.success(String outputPath, {int? outputSizeBytes}) {
    return ProcessResult(
      isSuccess: true,
      outputPath: outputPath,
      outputSizeBytes: outputSizeBytes,
    );
  }

  factory ProcessResult.failure(String message) {
    return ProcessResult(isSuccess: false, errorMessage: message);
  }
}
