import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:strokepred/homepage.dart';
import 'package:strokepred/signpage.dart';
import 'homepg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stroke Predictor',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Signpage(),
      initialRoute: Signpage.id,
    routes: {
      Signpage.id: (context) => Signpage(),
      //SignInScreen.id: (context) => SignInScreen(),
      HomePage.id: (context) => HomePage(),
    }
    );
  }
}





