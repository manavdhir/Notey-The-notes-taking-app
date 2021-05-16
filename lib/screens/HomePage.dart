import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notey_the_notes_application/colors.dart';
import 'package:notey_the_notes_application/database_helper.dart';
import 'package:notey_the_notes_application/helper/OflineNoteList.dart';
import 'package:notey_the_notes_application/screens/addNotesScreen.dart';
import 'package:notey_the_notes_application/screens/editNotesScreen.dart';
import 'package:notey_the_notes_application/screens/trashedNotesScreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'avenir',
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ref = FirebaseFirestore.instance.collection('notes');

  getDocumentLength(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      final List<DocumentSnapshot> documents = snapshot.data.docs;
      return documents.length;
    } else {
      return 0;
    }
  }

  getDocumentsItems(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    if (snapshot.hasData) {
      final List<DocumentSnapshot> documents = snapshot.data.docs;
      return documents[index];
    } else {
      return 0;
    }
  }

  int index = 0;
  var random = new Random();
  bool isConnected = false;
  StreamSubscription sub;

  // ignore: deprecated_member_use
  List<Widget> pageList = [HomePage(), TrashedNotesScreen()];
  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        // ignore: unrelated_type_equality_checks
        isConnected = (event != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XffFFD39E),
          onPressed: () {
            isConnected
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNotesScreen()))
                : Fluttertoast.showToast(
                    msg:
                        'Sorry you are offline ! check your internet connection');
          },
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: PreferredSize(
            child: AppBar(
              actions: [
                GestureDetector(
                    onTap: () {},
                    child: isConnected
                        ? Image.network(
                            'https://github.com/manavdhir/pictures-for-projects/blob/master/%E2%80%94Pngtree%E2%80%94user%20cartoon%20avatar%20pattern%20flat_4492883.png?raw=true',
                            height: 70,
                            width: 70,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'asset/images/profile.png',
                              height: 70,
                              width: 70,
                            ),
                          ))
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text('Notey',
                  style: GoogleFonts.bungee(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1.0),
                        blurRadius: 5.0,
                        color: Colors.grey,
                      ),
                    ],
                  )),
            ),
            preferredSize: Size.fromHeight(60.0)),
        body: isConnected
            ? Stack(
                children: [
                  StreamBuilder(
                      stream: ref.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return getDocumentLength(snapshot) != 0
                            ? GridView.builder(
                                padding: EdgeInsets.only(bottom: 20),
                                clipBehavior: Clip.hardEdge,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: getDocumentLength(snapshot),
                                itemBuilder: (_, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EditNote(
                                                  getDocumentsItems(
                                                      snapshot, index))));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                          color:
                                              randomColors[random.nextInt(8)],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      margin: EdgeInsets.all(20),
                                      height: 150,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  getDocumentsItems(
                                                      snapshot, index)['title'],
                                                  style: GoogleFonts.bungee(
                                                      fontSize: 20,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                getDocumentsItems(snapshot,
                                                    index)['description'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : Center(
                                child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.network(
                                    'https://assets3.lottiefiles.com/packages/lf20_W4M8Pi.json',
                                    height: 500,
                                    width: 500,
                                  ),
                                  Text(
                                    'Tap on the plus button to add your notes',
                                    style: TextStyle(),
                                  )
                                ],
                              ));
                      }),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: .10,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                  child: Icon(
                                    Icons.home_max_rounded,
                                    size: 25,
                                    color: Color(0XffFFD39E),
                                  ),
                                ),
                                Text('Home',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XffFFD39E),
                                    ))
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrashedNotesScreen()));
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text('Trashed Tasks',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              )
            : Stack(
                children: [
                  OflineNoteList(),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: .10,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        height: 65,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                  child: Icon(
                                    Icons.home_max_rounded,
                                    size: 25,
                                    color: Color(0XffFFD39E),
                                  ),
                                ),
                                Text('Home',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XffFFD39E),
                                    ))
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 100),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Sorry you are offline ! check your internet connection");
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text('Trashed Tasks',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ));
  }
}

// [
//   {'id':1,'title':'title','desc':desc},
//   {'id':1,'title':'title','desc':desc},
//   {'id':1,'title':'title','desc':desc},
//   {'id':1,'title':'title','desc':desc},
// ]
