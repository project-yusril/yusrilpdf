import 'dart:math';
import 'package:image/image.dart' as img;

class DocumentDetector {
  /// Detects the 4 corners of the largest document-like shape in the image.
  /// Returns a list of 4 points in [top-left, top-right, bottom-right, bottom-left] order.
  static List<Point<int>>? detectDocument(img.Image image) {
    // 1. Pre-process: Downscale for performance
    const targetWidth = 300;
    final scale = image.width / targetWidth;
    final smallImg = img.copyResize(image, width: targetWidth);

    // 2. Grayscale & Blur to reduce noise
    final gray = img.grayscale(smallImg);
    final blurred = img.gaussianBlur(gray, radius: 2);

    // 3. Sobel Edge Detection
    final edges = img.sobel(blurred);

    // 4. Threshold to get binary edges
    // We want to find the most significant edges
    final binaryEdges = _applyThreshold(edges, 50);

    // 5. Find extreme points (simplified contour approximation)
    final points = _findSignificantPoints(binaryEdges);
    if (points.length < 50) return null; // Not enough edge points

    final corners = _findQuadCorners(points);

    // 6. Scale back to original resolution
    return corners
        .map((p) => Point((p.x * scale).toInt(), (p.y * scale).toInt()))
        .toList();
  }

  static img.Image _applyThreshold(img.Image image, int threshold) {
    for (final pixel in image) {
      final val = pixel.r.toInt();
      if (val > threshold) {
        pixel.r = 255;
        pixel.g = 255;
        pixel.b = 255;
      } else {
        pixel.r = 0;
        pixel.g = 0;
        pixel.b = 0;
      }
    }
    return image;
  }

  static List<Point<int>> _findSignificantPoints(img.Image edgeImage) {
    final List<Point<int>> points = [];
    for (int y = 0; y < edgeImage.height; y++) {
      for (int x = 0; x < edgeImage.width; x++) {
        if (edgeImage.getPixel(x, y).r > 0) {
          points.add(Point(x, y));
        }
      }
    }
    return points;
  }

  static List<Point<int>> _findQuadCorners(List<Point<int>> points) {
    if (points.isEmpty) return [];

    // Find the 4 points that are closest to the corners of the image bounds
    // provided by the points themselves
    int minX = points.map((p) => p.x).reduce(min);
    int maxX = points.map((p) => p.x).reduce(max);
    int minY = points.map((p) => p.y).reduce(min);
    int maxY = points.map((p) => p.y).reduce(max);

    Point<int> tl = points.first;
    Point<int> tr = points.first;
    Point<int> br = points.first;
    Point<int> bl = points.first;

    double distTl = double.maxFinite;
    double distTr = double.maxFinite;
    double distBr = double.maxFinite;
    double distBl = double.maxFinite;

    for (final p in points) {
      // Top Left: dist to (minX, minY)
      double dTl = _distSq(p.x, p.y, minX, minY);
      if (dTl < distTl) {
        distTl = dTl;
        tl = p;
      }
      // Top Right: dist to (maxX, minY)
      double dTr = _distSq(p.x, p.y, maxX, minY);
      if (dTr < distTr) {
        distTr = dTr;
        tr = p;
      }
      // Bottom Right: dist to (maxX, maxY)
      double dBr = _distSq(p.x, p.y, maxX, maxY);
      if (dBr < distBr) {
        distBr = dBr;
        br = p;
      }
      // Bottom Left: dist to (minX, maxY)
      double dBl = _distSq(p.x, p.y, minX, maxY);
      if (dBl < distBl) {
        distBl = dBl;
        bl = p;
      }
    }

    return [tl, tr, br, bl];
  }

  static double _distSq(int x1, int y1, int x2, int y2) {
    return (x1 - x2) * (x1 - x2).toDouble() + (y1 - y2) * (y1 - y2).toDouble();
  }
}
