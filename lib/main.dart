import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kush/homepage.dart';
import 'package:kush/loginscreen.dart';
import 'package:kush/profile_tab.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileTab(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text('Page not found')),
        ),
      ),
    );
  }
}
