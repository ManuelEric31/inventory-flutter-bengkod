import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/firebase_options.dart';
import 'package:inventory_management/screens/onboarding_screen.dart';

void main() {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    MaterialApp(
      home: const OnboardingScreen(),
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
    ),
  );
}
