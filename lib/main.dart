import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/common/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp();
// Load .env
  await dotenv.load(fileName: ".env");
  runApp(const WasteWiseApp());
}

class WasteWiseApp extends StatelessWidget {
  const WasteWiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // sesuaikan dengan UI design
      builder: (context, child) {
        return GetMaterialApp(
          title: 'WasteWise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,    // Light theme
          darkTheme: AppTheme.darkTheme, // Dark theme
          themeMode: ThemeMode.system,   // Atur sesuai preferensi
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
