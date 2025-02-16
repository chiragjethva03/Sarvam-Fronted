import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'onbording screen/onbording.dart'; // Animation Screen

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
      title: 'Sarvam',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnbordingScreen(),
    );
  }
}
