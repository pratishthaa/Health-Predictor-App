import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

//void main() => runApp(new MaterialApp(home: new Main()));
//[
//     {"Pregnancies":6,"Glucose":148,"BloodPressure":72,"SkinThickness":35,"Insulin":0,"BMI":33.6,"DiabetesPedigreeFunction":0.627,"Age":50}
// ]
class DiabetesPage extends StatefulWidget {
  static String id='diabetespage';

  @override
  _DiabetesPageState createState() => _DiabetesPageState();
}

class _DiabetesPageState extends State<DiabetesPage> {
late int pregnancies,age;
  late double bloodpressure,skinthickness, insulin,dpf,glucose, bmi;

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
                          labelText: 'Pregnancies',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          pregnancies = int.parse(val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Glucose',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          glucose = double.parse(val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Blood Pressure',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          bloodpressure = double.parse(val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Skin Thickness',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          skinthickness = double.parse(val);
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Insulin',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          insulin = double.parse(val);
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Diabetes Pedigree Function',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight. bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onChanged: (val) {
                          dpf = double.parse(val);
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
                          age = int.parse(val);
                        },
                      ),



                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black,),
                        //color: Colors.blue,
                        onPressed: () async {
                          var body = [
                            {
                              "Pregnancies":pregnancies,
                              "Glucose":glucose,
                              "BloodPressure":bloodpressure,
                              "SkinThickness":skinthickness,
                              "Insulin":insulin,
                              "BMI":bmi,
                              "DiabetesPedigreeFunction":dpf,
                              "Age":age,
                            }
                          ];
                          /*body=[
                      {"bedrooms": 3, "bathrooms": 1, "sqft_living": 1180, "sqft_lot": 5650, "floors": 1, "waterfront": 0, "view": 0, "condition": 3, "grade": 7, "sqft_above": 1180, "sqft_basement": 0, "lat": 47.5112, "long": -122.257, "sqft_living15": 1340, "sqft_lot15": 5650}
                    ];*/
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
  Alert(context: context, title: "Diabetes(0: No, 1:Yes) : ", desc: resp).show();
}