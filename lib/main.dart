import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:strokepred/SelectPage.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:strokepred/homepage.dart';
import 'package:strokepred/SignPage.dart';
import 'DiabetesPage.dart';
import 'StrokePage.dart';

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
      home: SignPage(),
      initialRoute: SignPage.id,
    routes: {
      SignPage.id: (context) => SignPage(),
      Selectpage.id: (context) => Selectpage(),
      DiabetesPage.id:(context) => DiabetesPage(),
      //SignInScreen.id: (context) => SignInScreen(),
      StrokePage.id: (context) => StrokePage(),
    }
    );
  }
}





