import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PdfToolModel {
  final String id;
  final String title;
  final String description;
  final String route;
  final IconData icon;
  final Color color;
  final ToolCategory category;

  const PdfToolModel({
    required this.id,
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
    required this.color,
    required this.category,
  });
}

enum ToolCategory { optimize, convertTo, convertFrom, editSecurity, advanced }

extension ToolCategoryExt on ToolCategory {
  String get label {
    switch (this) {
      case ToolCategory.optimize:
        return 'Optimize & Organize';
      case ToolCategory.convertTo:
        return 'Convert to PDF';
      case ToolCategory.convertFrom:
        return 'Convert from PDF';
      case ToolCategory.editSecurity:
        return 'Edit & Security';
      case ToolCategory.advanced:
        return 'Advanced Tools';
    }
  }

  Color get color {
    switch (this) {
      case ToolCategory.optimize:
        return AppColors.catOptimize;
      case ToolCategory.convertTo:
        return AppColors.catConvertTo;
      case ToolCategory.convertFrom:
        return AppColors.catConvertFrom;
      case ToolCategory.editSecurity:
        return AppColors.catEdit;
      case ToolCategory.advanced:
        return AppColors.catAdvanced;
    }
  }
}
