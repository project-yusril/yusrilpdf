# Flutter PDF Tools App — Implementation Plan

Aplikasi Flutter lengkap untuk pengolahan dokumen PDF dengan **29 fitur tools**, menggunakan **Clean Architecture**, **Provider** untuk state management UI, dan **GetX** untuk navigasi & controller. Tampilan modern dengan 5 bottom navigation bar.

---

## 📦 Tech Stack & Packages

### Core & Navigation

| Package     | Versi  | Kegunaan                           |
| ----------- | ------ | ---------------------------------- |
| `get`       | ^4.6.6 | GetX navigation + controllers      |
| `provider`  | ^6.1.2 | State management UI layer          |
| `go_router` | -      | Tidak dipakai (pakai GetX routing) |

### PDF Processing

| Package                        | Versi  | Kegunaan                                               |
| ------------------------------ | ------ | ------------------------------------------------------ |
| `pdf_manipulator`              | latest | Merge, Split, Compress, Rotate, Watermark, Encrypt PDF |
| `pdf_combiner`                 | latest | Merge PDF (cross-platform)                             |
| `syncfusion_flutter_pdf`       | latest | Edit, Page Numbers, PDF/A, Protect, Sign PDF           |
| `syncfusion_flutter_pdfviewer` | latest | Viewer PDF in-app                                      |
| `pdf`                          | latest | Generate PDF dari konten                               |

### File Conversion

| Package          | Versi  | Kegunaan                       |
| ---------------- | ------ | ------------------------------ |
| `image`          | latest | Manipulasi gambar (JPG to PDF) |
| `flutter_to_pdf` | latest | Widget/HTML to PDF             |

### OCR & Camera

| Package                         | Versi  | Kegunaan                         |
| ------------------------------- | ------ | -------------------------------- |
| `google_mlkit_text_recognition` | latest | OCR text dari gambar             |
| `flutter_doc_scanner`           | latest | Scan to PDF (ML Kit + VisionKit) |
| `camera`                        | latest | Raw camera access                |

### File Management

| Package              | Versi  | Kegunaan                      |
| -------------------- | ------ | ----------------------------- |
| `file_picker`        | latest | Pilih file dari storage       |
| `path_provider`      | latest | Akses direktori app           |
| `share_plus`         | latest | Share file hasil              |
| `open_file`          | latest | Buka file di viewer eksternal |
| `permission_handler` | latest | Kelola izin storage & kamera  |

### UI & UX

| Package                | Versi  | Kegunaan                  |
| ---------------------- | ------ | ------------------------- |
| `flutter_animate`      | latest | Micro-animations          |
| `lottie`               | latest | Animation assets          |
| `shimmer`              | latest | Loading skeleton          |
| `cached_network_image` | latest | Image caching             |
| `google_fonts`         | latest | Tipografi premium (Inter) |
| `flutter_svg`          | latest | Icon SVG                  |
| `dotted_border`        | latest | Drop zone UI              |

### Storage & Translation

| Package              | Versi  | Kegunaan                          |
| -------------------- | ------ | --------------------------------- |
| `shared_preferences` | latest | Settings lokal                    |
| `hive_flutter`       | latest | Database lokal (history file)     |
| `translator`         | latest | Translate teks (Google Translate) |
| `http`               | latest | HTTP requests                     |

---

## 🏗️ Struktur Folder (Clean Architecture)

```
lib/
├── core/
│   ├── constants/          # app_colors, app_strings, app_routes
│   ├── errors/             # failures, exceptions
│   ├── theme/              # app_theme.dart
│   ├── utils/              # file_utils, pdf_utils, format_utils
│   └── widgets/            # shared widgets (buttons, cards, loaders)
│
├── features/
│   ├── home/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/   # HomeProvider (Provider)
│   │       └── pages/       # home_page.dart
│   │
│   ├── tools/              # 29 PDF tools
│   │   ├── domain/
│   │   │   ├── entities/   # PdfFile, ToolResult
│   │   │   ├── repositories/ # PdfToolRepository (interface)
│   │   │   └── usecases/   # MergePdf, SplitPdf, CompressPdf, ...
│   │   ├── data/
│   │   │   ├── datasources/ # PdfLocalDataSource
│   │   │   └── repositories/ # PdfToolRepositoryImpl
│   │   └── presentation/
│   │       ├── providers/   # ToolsProvider (Provider)
│   │       ├── controllers/ # MergeController, SplitController, ... (GetX)
│   │       └── pages/
│   │           ├── tools_page.dart        # grid semua tools
│   │           ├── merge_pdf_page.dart
│   │           ├── split_pdf_page.dart
│   │           ├── compress_pdf_page.dart
│   │           ├── organize_pdf_page.dart
│   │           ├── repair_pdf_page.dart
│   │           ├── rotate_pdf_page.dart
│   │           ├── crop_pdf_page.dart
│   │           ├── jpg_to_pdf_page.dart
│   │           ├── word_to_pdf_page.dart
│   │           ├── ppt_to_pdf_page.dart
│   │           ├── excel_to_pdf_page.dart
│   │           ├── html_to_pdf_page.dart
│   │           ├── pdf_to_jpg_page.dart
│   │           ├── pdf_to_word_page.dart
│   │           ├── pdf_to_ppt_page.dart
│   │           ├── pdf_to_excel_page.dart
│   │           ├── pdf_to_pdfa_page.dart
│   │           ├── edit_pdf_page.dart
│   │           ├── sign_pdf_page.dart
│   │           ├── watermark_page.dart
│   │           ├── protect_pdf_page.dart
│   │           ├── unlock_pdf_page.dart
│   │           ├── redact_pdf_page.dart
│   │           ├── page_numbers_page.dart
│   │           ├── ocr_pdf_page.dart
│   │           ├── compare_pdf_page.dart
│   │           └── translate_pdf_page.dart
│   │
│   ├── camera/
│   │   ├── domain/usecases/ # ScanDocument, CaptureAndConvert
│   │   ├── data/
│   │   └── presentation/
│   │       ├── providers/   # CameraProvider (Provider)
│   │       └── pages/       # camera_page.dart, scan_result_page.dart
│   │
│   ├── files/
│   │   ├── domain/usecases/ # GetRecentFiles, DeleteFile, ShareFile
│   │   ├── data/
│   │   └── presentation/
│   │       ├── providers/   # FilesProvider (Provider)
│   │       └── pages/       # files_page.dart, file_detail_page.dart
│   │
│   └── profile/
│       ├── domain/usecases/ # GetSettings, UpdateTheme
│       ├── data/
│       └── presentation/
│           ├── providers/   # ProfileProvider (Provider)
│           └── pages/       # profile_page.dart
│
├── navigation/
│   ├── app_pages.dart      # GetX route definitions
│   ├── app_routes.dart     # Route name constants
│   └── main_wrapper.dart   # 5 BottomNavBar scaffold
│
└── main.dart               # App entry, MultiProvider + GetMaterialApp
```

---

## 🎨 Desain UI

- **Theme**: Dark mode dengan aksen merah-oranye (#FF4B4B) — mirip iLovePDF
- **Font**: `Inter` dari Google Fonts
- **Bottom Nav**: 5 tab dengan animasi aktif (indicator + label color change)
  - 🏠 Home
  - 🛠️ Tools
  - 📷 Camera ← tombol tengah lebih besar (floating style)
  - 📁 Files
  - 👤 Profile
- **Tools Grid**: 3 kolom, card dengan icon berwarna per kategori

### Kategori Warna Tools

| Kategori            | Warna     |
| ------------------- | --------- |
| Optimize & Organize | 🔴 Merah  |
| Convert to PDF      | 🔵 Biru   |
| Convert from PDF    | 🟢 Hijau  |
| Edit & Security     | 🟡 Kuning |
| Advanced Tools      | 🟣 Ungu   |

---

## 🔧 Pattern: Provider + GetX

```
UI Layer
  └── Pages (Stateless)
        ├── Consume: Provider (ChangeNotifier) → UI state, loading/error
        └── Call: GetX Controller → business logic, navigation

GetX Controller
  └── Calls: UseCase (Domain Layer)

UseCase
  └── Calls: Repository (interface)

Repository (Impl)
  └── Calls: DataSource (local file system / native PDF API)
```

---

## ✅ Verification Plan

### Manual Testing (setelah build)

1. **Navigasi**: Tap setiap bottom nav → pastikan screen berganti
2. **Tools Grid**: Buka Tools tab → pastikan 29 tools tampil dalam grid
3. **File Picker**: Di Merge PDF → tap "Add File" → file picker terbuka
4. **Camera**: Tap Camera tab → izin kamera diminta → preview muncul
5. **Dark/Light Mode**: Profile → toggle theme → UI berubah
6. **Share File**: Files tab → long press file → share dialog muncul

### Run Command

```bash
cd d:\yusril-flutter-project\yusrilpdf
flutter run
```
