import 'package:digi_card/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'layouts/default_layout.dart';

class DigicardApp extends StatelessWidget {
  const DigicardApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.orbitron().fontFamily,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: DigicardStyles.primaryColor,
          ),
        ),
      ),
      home: const DefaultLayout(),
    );
  }
}
