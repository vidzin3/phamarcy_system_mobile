import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // for kReleaseMode
import 'package:phamarcy_system/plugins/DatabaseHelpers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Screens
import 'features/splash/splashscreen.dart';
import 'features/home/main_layout.dart';
import 'features/home/settings/profile_screen.dart';
import 'features/home/settings/change_password_screen.dart';
import 'features/home/settings/notification_screen.dart';
import 'features/home/settings/theme_screen.dart';
import 'features/home/settings/language_screen.dart';
import 'features/home/settings/inventory_screen.dart';
import 'features/home/settings/staff_screen.dart';
import 'features/home/settings/transaction_screen.dart';
import 'features/home/settings/help_screen.dart';
import 'features/home/settings/support_screen.dart';
import 'features/home/settings/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Use web implementation on the web.
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Use ffi on Linux and Windows.
    if (Platform.isLinux || Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();
    }
  }
  var db = await openDatabase(inMemoryDatabasePath);
  print((await db.rawQuery('SELECT sqlite_version()')).first.values.first);
  await db.close();

  await DatabaseHelper().database;
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enable only in debug mode
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Pharmacy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F7FE),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        '/main': (context) => const MainLayout(),

        // Settings
        '/profile': (context) => const ProfileScreen(),
        '/change-password': (context) => const ChangePassword(),
        '/notifications': (context) => const NotificationScreen(),
        '/theme': (context) => const ThemeScreen(),
        '/language': (context) => const LanguageScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/staff': (context) => const StaffScreen(),
        '/transactions': (context) => const TransactionScreen(),
        '/help': (context) => const HelpScreen(),
        '/support': (context) => const SupportScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
