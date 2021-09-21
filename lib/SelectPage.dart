import 'package:flutter/material.dart';
import 'package:strokepred/StrokePage.dart';

import 'DiabetesPage.dart';

class Selectpage extends StatefulWidget {
  const Selectpage({Key? key}) : super(key: key);
  static String id='select-here';


  @override
  _SelectpageState createState() => _SelectpageState();
}

class _SelectpageState extends State<Selectpage> {
  bool isLoading = false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose any option"),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset("assets/Healthy.png",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.lighten,
          ),
          Center(
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      child: isLoading? CircularProgressIndicator(color: Colors.white,)
                          :Text("PREDICT STROKE"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,),
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                              Navigator.pushNamed(context, StrokePage.id);
                      }
                  ),
                  Padding(padding: const EdgeInsets.all(10.0)),
                  ElevatedButton(
                      child: isLoading? CircularProgressIndicator(color: Colors.white,)
                          :Text("PREDICT DIABETES"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,),
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        Navigator.pushNamed(context, DiabetesPage.id);
                      }
                  )
                ],
              ),
            ),
          )
          ],
            ),
          );
  }
}
