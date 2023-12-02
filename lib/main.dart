import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_final/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(_app());
}

Widget _app() {
  return GetMaterialApp(
    title: 'ZapZap',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  );
}
