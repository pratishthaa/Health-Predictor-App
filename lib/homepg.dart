import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

//void main() => runApp(new MaterialApp(home: new Main()));

class HomePage extends StatefulWidget {
  static String id='homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'gender',
                  ),
                  onChanged: (val) {
                    gender = (val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'age',
                  ),
                  onChanged: (val) {
                    age = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'hypertension',
                  ),
                  onChanged: (val) {
                    hypertension = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'heart_disease',
                  ),
                  onChanged: (val) {
                    heart_disease = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'work type',
                  ),
                  onChanged: (val) {
                    work_type = (val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'avg glucose level',
                  ),
                  onChanged: (val) {
                    avg_glucose_leve = double.parse(val);
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'bmi',
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
    ]
    ),
    );
  }
}

//function from rflutter pkg to display alert
_onBasicAlertPressed(context, resp) {
  Alert(context: context, title: "Stroke(0: No, 1:Yes) : ", desc: resp).show();
}