import 'package:digi_card/providers/navigation_provider.dart';
import 'package:digi_card/providers/qr_data_provider.dart';
import 'package:flutter/material.dart'; // Keep this for provider compatibility
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QRCodeData()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: const DigicardApp(),
    ),
  );
}
