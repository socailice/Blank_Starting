import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kush/signupScreen.dart';
// import 'package:kush/firebase_option.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),  // Start with signup screen
    );
  }
}
