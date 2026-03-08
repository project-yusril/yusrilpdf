import 'package:flutter/material.dart';
import '../../features/tools/domain/entities/pdf_tool_model.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class ToolsData {
  static List<PdfToolModel> get allTools => [
    // ── Optimize & Organize ──────────────────────────────────
    PdfToolModel(
      id: 'merge_pdf',
      title: AppStrings.mergePdf,
      description: AppStrings.mergePdfDesc,
      route: AppRoutes.mergePdf,
      icon: Icons.call_merge_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'split_pdf',
      title: AppStrings.splitPdf,
      description: AppStrings.splitPdfDesc,
      route: AppRoutes.splitPdf,
      icon: Icons.call_split_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'compress_pdf',
      title: AppStrings.compressPdf,
      description: AppStrings.compressPdfDesc,
      route: AppRoutes.compressPdf,
      icon: Icons.compress_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'organize_pdf',
      title: AppStrings.organizePdf,
      description: AppStrings.organizePdfDesc,
      route: AppRoutes.organizePdf,
      icon: Icons.dashboard_customize_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'repair_pdf',
      title: AppStrings.repairPdf,
      description: AppStrings.repairPdfDesc,
      route: AppRoutes.repairPdf,
      icon: Icons.build_circle_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'rotate_pdf',
      title: AppStrings.rotatePdf,
      description: AppStrings.rotatePdfDesc,
      route: AppRoutes.rotatePdf,
      icon: Icons.rotate_right_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),
    PdfToolModel(
      id: 'crop_pdf',
      title: AppStrings.cropPdf,
      description: AppStrings.cropPdfDesc,
      route: AppRoutes.cropPdf,
      icon: Icons.crop_rounded,
      color: AppColors.catOptimize,
      category: ToolCategory.optimize,
    ),

    // ── Convert to PDF ───────────────────────────────────────
    PdfToolModel(
      id: 'jpg_to_pdf',
      title: AppStrings.jpgToPdf,
      description: AppStrings.jpgToPdfDesc,
      route: AppRoutes.jpgToPdf,
      icon: Icons.image_rounded,
      color: AppColors.catConvertTo,
      category: ToolCategory.convertTo,
    ),
    PdfToolModel(
      id: 'word_to_pdf',
      title: AppStrings.wordToPdf,
      description: AppStrings.wordToPdfDesc,
      route: AppRoutes.wordToPdf,
      icon: Icons.article_rounded,
      color: AppColors.catConvertTo,
      category: ToolCategory.convertTo,
    ),
    PdfToolModel(
      id: 'ppt_to_pdf',
      title: AppStrings.pptToPdf,
      description: AppStrings.pptToPdfDesc,
      route: AppRoutes.pptToPdf,
      icon: Icons.slideshow_rounded,
      color: AppColors.catConvertTo,
      category: ToolCategory.convertTo,
    ),
    PdfToolModel(
      id: 'excel_to_pdf',
      title: AppStrings.excelToPdf,
      description: AppStrings.excelToPdfDesc,
      route: AppRoutes.excelToPdf,
      icon: Icons.table_chart_rounded,
      color: AppColors.catConvertTo,
      category: ToolCategory.convertTo,
    ),
    PdfToolModel(
      id: 'html_to_pdf',
      title: AppStrings.htmlToPdf,
      description: AppStrings.htmlToPdfDesc,
      route: AppRoutes.htmlToPdf,
      icon: Icons.language_rounded,
      color: AppColors.catConvertTo,
      category: ToolCategory.convertTo,
    ),

    // ── Convert from PDF ─────────────────────────────────────
    PdfToolModel(
      id: 'pdf_to_jpg',
      title: AppStrings.pdfToJpg,
      description: AppStrings.pdfToJpgDesc,
      route: AppRoutes.pdfToJpg,
      icon: Icons.photo_library_rounded,
      color: AppColors.catConvertFrom,
      category: ToolCategory.convertFrom,
    ),
    PdfToolModel(
      id: 'pdf_to_word',
      title: AppStrings.pdfToWord,
      description: AppStrings.pdfToWordDesc,
      route: AppRoutes.pdfToWord,
      icon: Icons.description_rounded,
      color: AppColors.catConvertFrom,
      category: ToolCategory.convertFrom,
    ),
    PdfToolModel(
      id: 'pdf_to_ppt',
      title: AppStrings.pdfToPpt,
      description: AppStrings.pdfToPptDesc,
      route: AppRoutes.pdfToPpt,
      icon: Icons.present_to_all_rounded,
      color: AppColors.catConvertFrom,
      category: ToolCategory.convertFrom,
    ),
    PdfToolModel(
      id: 'pdf_to_excel',
      title: AppStrings.pdfToExcel,
      description: AppStrings.pdfToExcelDesc,
      route: AppRoutes.pdfToExcel,
      icon: Icons.grid_on_rounded,
      color: AppColors.catConvertFrom,
      category: ToolCategory.convertFrom,
    ),
    PdfToolModel(
      id: 'pdf_to_pdfa',
      title: AppStrings.pdfToPdfa,
      description: AppStrings.pdfToPdfaDesc,
      route: AppRoutes.pdfToPdfa,
      icon: Icons.archive_rounded,
      color: AppColors.catConvertFrom,
      category: ToolCategory.convertFrom,
    ),

    // ── Edit & Security ──────────────────────────────────────
    PdfToolModel(
      id: 'edit_pdf',
      title: AppStrings.editPdf,
      description: AppStrings.editPdfDesc,
      route: AppRoutes.editPdf,
      icon: Icons.edit_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'sign_pdf',
      title: AppStrings.signPdf,
      description: AppStrings.signPdfDesc,
      route: AppRoutes.signPdf,
      icon: Icons.draw_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'watermark',
      title: AppStrings.watermark,
      description: AppStrings.watermarkDesc,
      route: AppRoutes.watermark,
      icon: Icons.water_drop_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'protect_pdf',
      title: AppStrings.protectPdf,
      description: AppStrings.protectPdfDesc,
      route: AppRoutes.protectPdf,
      icon: Icons.lock_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'unlock_pdf',
      title: AppStrings.unlockPdf,
      description: AppStrings.unlockPdfDesc,
      route: AppRoutes.unlockPdf,
      icon: Icons.lock_open_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'redact_pdf',
      title: AppStrings.redactPdf,
      description: AppStrings.redactPdfDesc,
      route: AppRoutes.redactPdf,
      icon: Icons.remove_circle_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),
    PdfToolModel(
      id: 'page_numbers',
      title: AppStrings.pageNumbers,
      description: AppStrings.pageNumbersDesc,
      route: AppRoutes.pageNumbers,
      icon: Icons.format_list_numbered_rounded,
      color: AppColors.catEdit,
      category: ToolCategory.editSecurity,
    ),

    // ── Advanced Tools ───────────────────────────────────────
    PdfToolModel(
      id: 'ocr_pdf',
      title: AppStrings.ocrPdf,
      description: AppStrings.ocrPdfDesc,
      route: AppRoutes.ocrPdf,
      icon: Icons.document_scanner_rounded,
      color: AppColors.catAdvanced,
      category: ToolCategory.advanced,
    ),
    PdfToolModel(
      id: 'scan_to_pdf',
      title: AppStrings.scanToPdf,
      description: AppStrings.scanToPdfDesc,
      route: AppRoutes.scanToPdf,
      icon: Icons.camera_alt_rounded,
      color: AppColors.catAdvanced,
      category: ToolCategory.advanced,
    ),
    PdfToolModel(
      id: 'compare_pdf',
      title: AppStrings.comparePdf,
      description: AppStrings.comparePdfDesc,
      route: AppRoutes.comparePdf,
      icon: Icons.compare_rounded,
      color: AppColors.catAdvanced,
      category: ToolCategory.advanced,
    ),
    PdfToolModel(
      id: 'translate_pdf',
      title: AppStrings.translatePdf,
      description: AppStrings.translatePdfDesc,
      route: AppRoutes.translatePdf,
      icon: Icons.translate_rounded,
      color: AppColors.catAdvanced,
      category: ToolCategory.advanced,
    ),
  ];

  static List<PdfToolModel> getByCategory(ToolCategory category) {
    return allTools.where((t) => t.category == category).toList();
  }

  static List<PdfToolModel> search(String query) {
    final q = query.toLowerCase();
    return allTools
        .where(
          (t) =>
              t.title.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q),
        )
        .toList();
  }

  static PdfToolModel? getById(String id) {
    try {
      return allTools.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
