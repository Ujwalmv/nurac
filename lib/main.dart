import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Color(0xFF383C44);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Reddiar's",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionColor: primaryColor.withOpacity(0.3),
          selectionHandleColor: primaryColor,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: primaryColor, // fallback for old widgets
        ).copyWith(
          primary: primaryColor,
          secondary: primaryColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Unfocused border
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor), // Focused border
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
        ),
      ),
      home: SplashPage(),
    );
  }
}
