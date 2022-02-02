import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

//void main() => runApp(new MaterialApp(home: new Main()));

class StrokePage extends StatefulWidget {
  static String id='strokepage';

  @override
  _StrokePageState createState() => _StrokePageState();
}

class _StrokePageState extends State<StrokePage> {
  late String gender, work_type;

  late double age, hypertension, heart_disease,avg_glucose_leve, bmi;

  Future<String?> predict(var body) async {
    var client = new http.Client();
    var uri = Uri.parse("http://10.0.2.2:12345/predict");
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonString = json.encode(body);
    try {
      var resp = await client.post(uri, headers: headers, body: jsonString);
      //var resp=await http.get(Uri.parse("http://192.168.1.101:5000"));
      if (resp.statusCode == 200) {
        print("DATA FETCHED SUCCESSFULLY");
        var result = json.decode(resp.body);
        print(result["prediction"]);
        return result["prediction"];
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      return null;
    }
    return null;
  }

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Details"),
        backgroundColor: Colors.teal,
          actions: [
            IconButton (
              icon: Icon(Icons.logout),
              onPressed: () async{
                try {
                  await FirebaseAuth.instance.signOut();
                  errorMessage = '';
                } on FirebaseAuthException catch (error) {
                  errorMessage = error.message!;
                }
                Navigator.pop(context);
                setState(() {});
                /** Do something */
              },
            ),
          ]
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
      Image.asset("assets/Healthy.png",
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.5),
        colorBlendMode: BlendMode.lighten,
      ),
      // Container(
      //   margin: EdgeInsets.all(20.0),
        //child:
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      gender = (val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      age = double.parse(val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Hypertension',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      hypertension = double.parse(val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Heart Disease',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      heart_disease = double.parse(val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Work Type',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      work_type = (val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Average Glucose Level',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      avg_glucose_leve = double.parse(val);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'BMI',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight. bold,
                        fontSize: 20.0,
                      ),
                    ),
                    onChanged: (val) {
                      bmi = double.parse(val);
                    },
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black,),
                    //color: Colors.blue,
                    onPressed: () async {
                      var body = [
                        {
                          "gender": gender,
                          "age": age,
                          "hypertension": hypertension,
                          "heart_disease": heart_disease,
                          "work_type":work_type,
                          "avg_glucose_leve": avg_glucose_leve,
                          "bmi": bmi,
                        }
                      ];
                      print(body);
                      var resp = await predict(body);
                      _onBasicAlertPressed(context, resp);
                    },
                    child: Text("Predict"),
                  ),
                ],
              ),
            ),
          ),
        ),
    ]
    ),
    );
  }
}

_onBasicAlertPressed(context, resp) {
  Alert(context: context, title: "Stroke(0: No, 1:Yes) : ", desc: resp).show();
}