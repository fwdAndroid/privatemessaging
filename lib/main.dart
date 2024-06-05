import 'package:flutter/material.dart';
import 'package:privatemessaging/firebase_options.dart';
import 'package:privatemessaging/pin_verification.dart';
import 'package:privatemessaging/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final pin = prefs.getString('pin');

  runApp(MyApp(pin: pin));
}

class MyApp extends StatelessWidget {
  final String? pin;

  const MyApp({Key? key, this.pin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Messaging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: pin != null ? PinVerificationScreen() : SplashScreen(),
    );
  }
}
