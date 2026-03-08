import 'package:get/get.dart';
import '../navigation/main_wrapper.dart';
import '../features/tools/presentation/pages/merge_pdf_page.dart';
import '../features/tools/presentation/pages/split_pdf_page.dart';
import '../features/tools/presentation/pages/compress_pdf_page.dart';
import '../features/tools/presentation/pages/organize_pdf_page.dart';
import '../features/tools/presentation/pages/repair_pdf_page.dart';
import '../features/tools/presentation/pages/rotate_pdf_page.dart';
import '../features/tools/presentation/pages/crop_pdf_page.dart';
import '../features/tools/presentation/pages/jpg_to_pdf_page.dart';
import '../features/tools/presentation/pages/word_to_pdf_page.dart';
import '../features/tools/presentation/pages/ppt_to_pdf_page.dart';
import '../features/tools/presentation/pages/excel_to_pdf_page.dart';
import '../features/tools/presentation/pages/html_to_pdf_page.dart';
import '../features/tools/presentation/pages/pdf_to_jpg_page.dart';
import '../features/tools/presentation/pages/pdf_to_word_page.dart';
import '../features/tools/presentation/pages/pdf_to_ppt_page.dart';
import '../features/tools/presentation/pages/pdf_to_excel_page.dart';
import '../features/tools/presentation/pages/pdf_to_pdfa_page.dart';
import '../features/tools/presentation/pages/edit_pdf_page.dart';
import '../features/tools/presentation/pages/sign_pdf_page.dart';
import '../features/tools/presentation/pages/watermark_page.dart';
import '../features/tools/presentation/pages/protect_pdf_page.dart';
import '../features/tools/presentation/pages/unlock_pdf_page.dart';
import '../features/tools/presentation/pages/redact_pdf_page.dart';
import '../features/tools/presentation/pages/page_numbers_page.dart';
import '../features/tools/presentation/pages/ocr_pdf_page.dart';
import '../features/tools/presentation/pages/scan_to_pdf_page.dart';
import '../features/tools/presentation/pages/compare_pdf_page.dart';
import '../features/tools/presentation/pages/translate_pdf_page.dart';
import '../features/tools/presentation/pages/smart_scanner_page.dart';
import '../core/constants/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.main, page: () => const MainWrapper()),

    // Optimize & Organize
    GetPage(name: AppRoutes.mergePdf, page: () => const MergePdfPage()),
    GetPage(name: AppRoutes.splitPdf, page: () => const SplitPdfPage()),
    GetPage(name: AppRoutes.compressPdf, page: () => const CompressPdfPage()),
    GetPage(name: AppRoutes.organizePdf, page: () => const OrganizePdfPage()),
    GetPage(name: AppRoutes.repairPdf, page: () => const RepairPdfPage()),
    GetPage(name: AppRoutes.rotatePdf, page: () => const RotatePdfPage()),
    GetPage(name: AppRoutes.cropPdf, page: () => const CropPdfPage()),

    // Convert to PDF
    GetPage(name: AppRoutes.jpgToPdf, page: () => const JpgToPdfPage()),
    GetPage(name: AppRoutes.wordToPdf, page: () => const WordToPdfPage()),
    GetPage(name: AppRoutes.pptToPdf, page: () => const PptToPdfPage()),
    GetPage(name: AppRoutes.excelToPdf, page: () => const ExcelToPdfPage()),
    GetPage(name: AppRoutes.htmlToPdf, page: () => const HtmlToPdfPage()),

    // Convert from PDF
    GetPage(name: AppRoutes.pdfToJpg, page: () => const PdfToJpgPage()),
    GetPage(name: AppRoutes.pdfToWord, page: () => const PdfToWordPage()),
    GetPage(name: AppRoutes.pdfToPpt, page: () => const PdfToPptPage()),
    GetPage(name: AppRoutes.pdfToExcel, page: () => const PdfToExcelPage()),
    GetPage(name: AppRoutes.pdfToPdfa, page: () => const PdfToPdfaPage()),

    // Edit & Security
    GetPage(name: AppRoutes.editPdf, page: () => const EditPdfPage()),
    GetPage(name: AppRoutes.signPdf, page: () => const SignPdfPage()),
    GetPage(name: AppRoutes.watermark, page: () => const WatermarkPage()),
    GetPage(name: AppRoutes.protectPdf, page: () => const ProtectPdfPage()),
    GetPage(name: AppRoutes.unlockPdf, page: () => const UnlockPdfPage()),
    GetPage(name: AppRoutes.redactPdf, page: () => const RedactPdfPage()),
    GetPage(name: AppRoutes.pageNumbers, page: () => const PageNumbersPage()),

    // Advanced
    GetPage(name: AppRoutes.ocrPdf, page: () => const OcrPdfPage()),
    GetPage(name: AppRoutes.scanToPdf, page: () => const ScanToPdfPage()),
    GetPage(name: AppRoutes.smartScanner, page: () => const SmartScannerPage()),
    GetPage(name: AppRoutes.comparePdf, page: () => const ComparePdfPage()),
    GetPage(name: AppRoutes.translatePdf, page: () => const TranslatePdfPage()),
  ];
}
