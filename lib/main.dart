import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notey_the_notes_application/bottomNavigationBar.dart';
import 'package:notey_the_notes_application/screens/HomePage.dart';

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
      theme: ThemeData(
        fontFamily: 'avenir',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool isConnected = false;
  //StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    // sub = Connectivity().onConnectivityChanged.listen((event) {
    //   setState(() {
    //     // ignore: unrelated_type_equality_checks
    //     isConnected = (event != ConnectivityResult.none);
    //   });
    // });
    Timer(Duration(seconds: 4), openOnBoarding);
  }

  @override
  void dispose() {
    super.dispose();
    //sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 80),
              height: 450,
              width: 350,
              child: Lottie.network(
                  "https://assets4.lottiefiles.com/packages/lf20_lcmpz7.json")),
          Text('Notey',
              style: GoogleFonts.bungee(
                  color: Colors.black,
                  fontSize: 50,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1, 1.0),
                      blurRadius: 5.0,
                      color: Colors.white,
                    ),
                  ],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          SizedBox(height: 20),
          Text(
            'The awesome note taking app',
            style: TextStyle(color: Colors.black),
          )
        ],
      )),
    );
  }

  void openOnBoarding() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}

//Color(0Xff242B2E)
