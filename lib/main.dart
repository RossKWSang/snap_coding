import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/layouts/mobile_screen_layout.dart';
import 'package:snap_coding_2/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA9KLlZuMrj9r4kBUjbtcrb3CEPWoGnfsg',
        appId: '1:839672250923:web:48ab1645a8789cb2a4e06e',
        messagingSenderId: '839672250923',
        projectId: 'snapcoding-2',
        storageBucket: 'snapcoding-2.appspot.com',
      ),
    );
  } else {}
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnapCoding',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: MobileScreenLayout(),
    );
  }
}
