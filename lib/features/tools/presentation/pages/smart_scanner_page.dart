import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/document_detector.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class SmartScannerPage extends StatefulWidget {
  const SmartScannerPage({super.key});

  @override
  State<SmartScannerPage> createState() => _SmartScannerPageState();
}

class _SmartScannerPageState extends State<SmartScannerPage>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  late AnimationController _animationController;
  double _scanLinePosition = 0.0;
  bool _isBatchMode = false;
  int _capturedCount = 0;
  bool _isReady = false;

  FlashMode _flashMode = FlashMode.off;
  Size? _imageSize;

  // --- Advanced Smart Logic Variables ---
  int _stableFrames = 0;
  bool _isAutoCaptureEnabled = true;
  bool _isLowLight = false;
  String _statusMessage = "";
  DateTime? _lastCaptureTime;
  Offset? _lastCenter;
  int _frameCount = 0;

  List<math.Point<int>>? _currentCorners;
  bool _isBusy = false;
  final List<String> _capturedPaths = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          _scanLinePosition = _animationController.value;
        });
      });
    _animationController.repeat(reverse: true);
    _initializeDetector();
    _initializeCamera();
  }

  void _initializeDetector() {
    // Custom DocumentDetector is static, no initialization needed for object
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      _controller!.startImageStream(_processCameraImage);
      setState(() => _isReady = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    _frameCount++;
    if (_frameCount % 4 != 0)
      return; // Process every 4th frame (increased from 5 for better 'Quick' feel)

    if (_isBusy) return;
    _isBusy = true;

    try {
      final img.Image? dartImage = _convertCameraImage(image);
      if (dartImage == null) return;

      final corners = DocumentDetector.detectDocument(dartImage);

      if (corners != null) {
        // Stability Logic: Check if corners moved significantly
        if (_lastCenter != null) {
          final currentCenter = _calculateCenter(corners);
          final diff = (currentCenter - _lastCenter!).distance;
          if (diff > (image.width * 0.05)) {
            _stableFrames = 0;
          }
        }
        _lastCenter = _calculateCenter(corners);
        _imageSize =
            Size(dartImage.width.toDouble(), dartImage.height.toDouble());

        setState(() {
          // Smoothing (lerp) for the 4 corners
          if (_currentCorners == null || _currentCorners!.length != 4) {
            _currentCorners = List.from(corners);
          } else {
            for (int i = 0; i < 4; i++) {
              _currentCorners![i] = math.Point(
                ui
                    .lerpDouble(_currentCorners![i].x.toDouble(),
                        corners[i].x.toDouble(), 0.3)!
                    .toInt(),
                ui
                    .lerpDouble(_currentCorners![i].y.toDouble(),
                        corners[i].y.toDouble(), 0.3)!
                    .toInt(),
              );
            }
          }

          _stableFrames++;
          if (_stableFrames > 12) {
            _statusMessage = "Siap! Jepret Otomatis...";
            if (_isAutoCaptureEnabled && _canAutoCapture()) {
              _autoTakePicture();
            }
          } else if (_stableFrames > 4) {
            _statusMessage = "Tahan Sebentar...";
          } else {
            _statusMessage = "Dokumen Terdeteksi";
          }
        });
      } else {
        _stableFrames = 0;
        _lastCenter = null;
        setState(() {
          _currentCorners = null;
          _statusMessage = "Mencari Dokumen...";
        });
      }

      _checkLighting(image);
    } catch (e) {
      debugPrint('Detection error: $e');
    } finally {
      _isBusy = false;
    }
  }

  Offset _calculateCenter(List<math.Point<int>> corners) {
    double x = 0;
    double y = 0;
    for (final p in corners) {
      x += p.x;
      y += p.y;
    }
    return Offset(x / 4, y / 4);
  }

  img.Image? _convertCameraImage(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final img.Image dartImage = img.Image(width: width, height: height);

      final Plane yPlane = image.planes[0];
      final Plane uPlane = image.planes[1];
      final Plane vPlane = image.planes[2];

      final Uint8List yBytes = yPlane.bytes;
      final Uint8List uBytes = uPlane.bytes;
      final Uint8List vBytes = vPlane.bytes;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int yIndex = y * yPlane.bytesPerRow + x * yPlane.bytesPerPixel!;
          final int uvIndex =
              (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2) * uPlane.bytesPerPixel!;

          final int yValue = yBytes[yIndex];
          final int uValue = uBytes[uvIndex] - 128;
          final int vValue = vBytes[uvIndex] - 128;

          int r = (yValue + 1.370705 * vValue).round();
          int g = (yValue - 0.337633 * uValue - 0.698001 * vValue).round();
          int b = (yValue + 1.732446 * uValue).round();

          dartImage.setPixelRgb(
              x, y, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
        }
      }

      // Rotate image to match portrait screen orientation
      // Most Android camera sensors are rotated 90 deg landscape
      return img.copyRotate(dartImage, angle: 90);
    } catch (e) {
      debugPrint("Conversion error: $e");
      return null;
    }
  }

  void _checkLighting(CameraImage image) {
    if (image.planes.isEmpty) return;
    final bytes = image.planes[0].bytes;
    int total = 0;
    // Subsample for performance
    for (int i = 0; i < bytes.length; i += 100) {
      total += bytes[i];
    }
    final avg = total / (bytes.length / 100);
    final isLow = avg < 70; // Threshold for low light
    if (isLow != _isLowLight) {
      setState(() => _isLowLight = isLow);
    }
  }

  bool _canAutoCapture() {
    if (_lastCaptureTime == null) {
      return true;
    }
    return DateTime.now().difference(_lastCaptureTime!).inSeconds > 3;
  }

  Future<void> _autoTakePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isBusy) {
      return;
    }
    _lastCaptureTime = DateTime.now();
    HapticFeedback.mediumImpact();

    try {
      final XFile file = await _controller!.takePicture();
      final processedPath =
          await _processCapturedImage(file.path, _currentCorners);

      if (!_isBatchMode) {
        Get.back(result: processedPath);
      } else {
        setState(() {
          _capturedPaths.add(processedPath);
          _capturedCount = _capturedPaths.length;
        });
      }
    } catch (e) {
      debugPrint('Auto-capture error: $e');
    }
  }

  Future<String> _processCapturedImage(
      String path, List<math.Point<int>>? corners) async {
    if (corners == null || _imageSize == null) return path;

    try {
      final bytes = await File(path).readAsBytes();
      img.Image? capturedImage = img.decodeImage(bytes);
      if (capturedImage == null) return path;

      // Coordinate transformation from stream resolution to captured image resolution
      // The corners are in stream resolution (portrait after my manual rotation)
      final double scaleX = capturedImage.width / _imageSize!.width;
      final double scaleY = capturedImage.height / _imageSize!.height;

      // Find bounding box for the 4 corners to perform crop
      int minX = corners.map((p) => p.x).reduce(math.min);
      int maxX = corners.map((p) => p.x).reduce(math.max);
      int minY = corners.map((p) => p.y).reduce(math.min);
      int maxY = corners.map((p) => p.y).reduce(math.max);

      final int left = (minX * scaleX).toInt().clamp(0, capturedImage.width);
      final int top = (minY * scaleY).toInt().clamp(0, capturedImage.height);
      final int width =
          ((maxX - minX) * scaleX).toInt().clamp(0, capturedImage.width - left);
      final int height =
          ((maxY - minY) * scaleY).toInt().clamp(0, capturedImage.height - top);

      if (width > 100 && height > 100) {
        // High quality crop
        final cropped = img.copyCrop(capturedImage,
            x: left, y: top, width: width, height: height);

        final tempDir = await getTemporaryDirectory();
        final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final newPath = p.join(tempDir.path, fileName);

        await File(newPath).writeAsBytes(img.encodeJpg(cropped, quality: 90));
        return newPath;
      }
    } catch (e) {
      debugPrint('Crop error: $e');
    }
    return path;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),

          // 2. Green Box Overlay (AI Detection)
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                scanLinePosition: _scanLinePosition,
                corners: _currentCorners,
                imageSize: _imageSize,
                statusMessage: _statusMessage,
                isLowLight: _isLowLight,
              ),
            ),
          ),

          // 2.1 Lighting Warning
          if (_isLowLight)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wb_incandescent_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Cahaya Kurang, Gunakan Senter",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 3. Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Get.back(),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.off
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _flashMode = _flashMode == FlashMode.off
                              ? FlashMode.torch
                              : FlashMode.off;
                        });
                        _controller?.setFlashMode(_flashMode);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isAutoCaptureEnabled
                            ? Icons.auto_mode_rounded
                            : Icons.camera_alt_outlined,
                        color: _isAutoCaptureEnabled
                            ? AppColors.primary
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() =>
                            _isAutoCaptureEnabled = !_isAutoCaptureEnabled);
                        Get.snackbar(
                          "Auto Capture",
                          _isAutoCaptureEnabled ? "Aktif" : "Non-aktif",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.black54,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 1),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.hd, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Mode Toggle (Single/Batch)
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ModeButton(
                      label: 'Satu Halaman',
                      isSelected: !_isBatchMode,
                      onTap: () {
                        if (_isBatchMode) {
                          setState(() {
                            _isBatchMode = false;
                            _stableFrames = 0;
                            _currentCorners = null;
                            _statusMessage = "Mode Satu Halaman";
                          });
                        }
                      },
                    ),
                    _ModeButton(
                      label: 'Batch',
                      isSelected: _isBatchMode,
                      onTap: () {
                        if (!_isBatchMode) {
                          setState(() {
                            _isBatchMode = true;
                            _stableFrames = 0;
                            _currentCorners = null;
                            _statusMessage = "Mode Batch Aktif";
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 5. Bottom Navigation & Capture
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sub-nav labels
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SubNavItem(label: 'Kode QR'),
                        _SubNavItem(label: 'Tanda tangani'),
                        _SubNavItem(label: 'Scan', isSelected: true),
                        _SubNavItem(label: 'Hapus Cerdas'),
                        _SubNavItem(label: 'Kartu ID'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Capture Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionItem(
                        icon: Icons.grid_view_rounded,
                        label: 'Semua Fitur',
                        onTap: () {},
                      ),
                      // Main Capture Button
                      GestureDetector(
                        onTap: () async {
                          if (_controller == null ||
                              !_controller!.value.isInitialized) {
                            return;
                          }

                          try {
                            final XFile file = await _controller!.takePicture();
                            final processedPath = await _processCapturedImage(
                                file.path, _currentCorners);

                            if (!_isBatchMode) {
                              Get.back(result: processedPath);
                            } else {
                              setState(() {
                                _capturedPaths.add(processedPath);
                                _capturedCount = _capturedPaths.length;
                              });
                              HapticFeedback.mediumImpact();
                              _lastCaptureTime = DateTime.now();
                            }
                          } catch (e) {
                            debugPrint('Capture error: $e');
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Stability Progress Ring
                            if (_stableFrames > 0 && _isAutoCaptureEnabled)
                              SizedBox(
                                width: 90,
                                height: 90,
                                child: CircularProgressIndicator(
                                  value: (_stableFrames / 15).clamp(0.0, 1.0),
                                  strokeWidth: 4,
                                  color: AppColors.primary,
                                ),
                              ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 3),
                              ),
                              child: Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: _isBatchMode && _capturedCount > 0
                                      ? Center(
                                          child: Text(
                                            '$_capturedCount',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Done Button (Only for Batch Mode)
                      if (_isBatchMode && _capturedCount > 0)
                        _ActionItem(
                          icon: Icons.check_circle_rounded,
                          label: 'Selesai',
                          onTap: () {
                            // Join multiple paths with a special separator or return as list if Get supports it
                            // Here we return comma separated for simplicity if the receiver handles it
                            Get.back(result: _capturedPaths.join(','));
                          },
                        )
                      else
                        _ActionItem(
                          icon: Icons.image_rounded,
                          label: 'Impor Gambar',
                          onTap: () {},
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SubNavItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _SubNavItem({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.7),
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final List<math.Point<int>>? corners;
  final Size? imageSize;
  final double scanLinePosition;
  final String statusMessage;
  final bool isLowLight;

  ScannerOverlayPainter({
    this.corners,
    this.imageSize,
    required this.scanLinePosition,
    required this.statusMessage,
    required this.isLowLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (corners == null || corners!.length != 4 || imageSize == null) {
      _drawGuideLines(canvas, size);
      _drawStatusText(canvas, size,
          statusMessage.isEmpty ? "Mencari Dokumen..." : statusMessage, false);
      _drawScanningBeam(canvas, size, null);
      return;
    }

    // Scale coordinates from camera resolution (usually landscape) to screen resolution (portrait)
    // imageSize: width (long), height (short)
    final double scaleX = size.width / imageSize!.width;
    final double scaleY = size.height / imageSize!.height;

    final scaledPoints =
        corners!.map((p) => Offset(p.x * scaleX, p.y * scaleY)).toList();

    // Draw the detection quad
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(scaledPoints[0].dx, scaledPoints[0].dy)
      ..lineTo(scaledPoints[1].dx, scaledPoints[1].dy)
      ..lineTo(scaledPoints[2].dx, scaledPoints[2].dy)
      ..lineTo(scaledPoints[3].dx, scaledPoints[3].dy)
      ..close();

    canvas.drawPath(path, paint);

    // Semi-transparent overlay inside the quad
    final fillPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    _drawStatusText(canvas, size, statusMessage, true);

    // Derive a bounding box for scanning beam
    final double minX = scaledPoints.map((p) => p.dx).reduce(math.min);
    final double maxX = scaledPoints.map((p) => p.dx).reduce(math.max);
    final double minY = scaledPoints.map((p) => p.dy).reduce(math.min);
    final double maxY = scaledPoints.map((p) => p.dy).reduce(math.max);
    final rect = Rect.fromLTRB(minX, minY, maxX, maxY);

    _drawScanningBeam(canvas, size, rect);
  }

  void _drawStatusText(Canvas canvas, Size size, String text, bool isDetected) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isDetected ? AppColors.primary : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          shadows: [
            Shadow(blurRadius: 10, color: Colors.black, offset: Offset(0, 2)),
          ],
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final margin = 40.0;
    final guideRect = Rect.fromLTRB(
        margin, size.height * 0.2, size.width - margin, size.height * 0.7);

    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        guideRect.top - 30,
      ),
    );
  }

  void _drawScanningBeam(Canvas canvas, Size size, Rect? boundRect) {
    final beamPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, 10),
        [
          AppColors.primary.withValues(alpha: 0.0),
          AppColors.primary.withValues(alpha: 0.8),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    late double y;
    late double left;
    late double right;

    if (boundRect != null) {
      y = boundRect.top + (boundRect.height * scanLinePosition);
      left = boundRect.left;
      right = boundRect.right;
    } else {
      final margin = 40.0;
      final guideRect = Rect.fromLTRB(
          margin, size.height * 0.2, size.width - margin, size.height * 0.7);
      y = guideRect.top + (guideRect.height * scanLinePosition);
      left = guideRect.left;
      right = guideRect.right;
    }

    canvas.drawRect(Rect.fromLTRB(left, y - 5, right, y + 5), beamPaint);

    // Add a bright line in middle of beam
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(left, y), Offset(right, y), linePaint);
  }

  void _drawGuideLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final margin = 40.0;
    final rect = Rect.fromLTRB(
        margin, size.height * 0.2, size.width - margin, size.height * 0.7);

    // Draw partial corners for guide box
    final cs = 30.0;
    final path = Path()
      ..moveTo(rect.left, rect.top + cs)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + cs, rect.top)
      ..moveTo(rect.right - cs, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + cs)
      ..moveTo(rect.right, rect.bottom - cs)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right - cs, rect.bottom)
      ..moveTo(rect.left + cs, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cs);

    canvas.drawPath(path, paint);

    // Draw very faint dashed lines or just a light overlay
    final bgPaint = Paint()..color = Colors.black.withValues(alpha: 0.2);
    canvas.drawRect(rect, bgPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => true;
}
