import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurac/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Member App',
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ).copyWith(
        secondary: Colors.blueAccent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Unfocused border
        ),
        focusedBorder: OutlineInputBorder(

          borderSide: BorderSide(color: Colors.blueAccent,), // Focused border
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        // labelStyle: TextStyle(color: Colors.grey), // Label text color
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)), // Hint text color

      ),
    ),

    home: SplashPage(),
    );
  }
}
