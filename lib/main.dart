import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deva_news_web/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(), // Inter yazı tipini tüm uygulama için uygula
      ),
      home: Home(),
    );
  }
}
