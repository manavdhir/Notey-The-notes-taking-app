import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:notey_the_notes_application/colors.dart';
import 'package:notey_the_notes_application/screens/HomePage.dart';
import 'package:notey_the_notes_application/screens/addNotesScreen.dart';

class TrashedNotesScreen extends StatefulWidget {
  @override
  _TrashedNotesScreenState createState() => _TrashedNotesScreenState();
}

class _TrashedNotesScreenState extends State<TrashedNotesScreen> {
  final ref = FirebaseFirestore.instance.collection('deleted notes');
  var random = new Random();
  final new_ref = FirebaseFirestore.instance.collection('notes');

  final delete_note_ref =
      FirebaseFirestore.instance.collection('deleted notes');

  getDocumentLength(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      final List<DocumentSnapshot> documents = snapshot.data!.docs;
      return documents.length;
    } else {
      return 0;
    }
  }

  getDocumentsItems(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    if (snapshot.hasData) {
      final List<DocumentSnapshot> documents = snapshot.data!.docs;
      return documents[index];
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0XffFFD39E),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNotesScreen()));
            },
            child: Icon(
              Icons.add,
              size: 25,
              color: Colors.black,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: PreferredSize(
              child: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => HomePage()));
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                ),
                actions: [
                  Image.network(
                    'https://github.com/manavdhir/pictures-for-projects/blob/master/%E2%80%94Pngtree%E2%80%94user%20cartoon%20avatar%20pattern%20flat_4492883.png?raw=true',
                    height: 70,
                    width: 70,
                  )
                ],
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  'Trashed Notes',
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
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
          body: Stack(
            children: [
              StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return getDocumentLength(snapshot) != 0
                        ? GridView.builder(
                            clipBehavior: Clip.hardEdge,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: getDocumentLength(snapshot),
                            itemBuilder: (_, index) {
                              return Slidable(
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'Restore',
                                    color: Colors.green[100],
                                    icon: Icons.restore,
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text(
                                                'Are you sure you want to restore this note ?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: [
                                                new FlatButton(
                                                    onPressed: () {
                                                      new_ref.add({
                                                        'title':
                                                            getDocumentsItems(
                                                                snapshot,
                                                                index)['title'],
                                                        'description':
                                                            getDocumentsItems(
                                                                    snapshot,
                                                                    index)[
                                                                'description']
                                                      });
                                                      snapshot.data!.docs[index]
                                                          .reference
                                                          .delete()
                                                          .whenComplete(() => {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                HomePage())),
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Note sucessfully restored")
                                                              });
                                                    },
                                                    child: new Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                                new FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: new Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            );
                                          });
                                    },
                                  )
                                ],
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.3,
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                      color: randomColors[random.nextInt(8)],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  margin: EdgeInsets.only(
                                      left: 20, top: 20, bottom: 20, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getDocumentsItems(
                                              snapshot, index)['title'],
                                          style: GoogleFonts.bungee(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 90, bottom: 30),
                                width: double.infinity,
                                child: Text(
                                    'Swipe the cards to restore the notes'),
                              ),
                              LottieBuilder.network(
                                'https://assets6.lottiefiles.com/packages/lf20_2qhrg6e8.json',
                                height: 500,
                                width: 500,
                              ),
                              Text(
                                'No trash notes present',
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
                                Icons.home,
                                color: Colors.grey,
                              ),
                            ),
                            Text('Home',
                                style: TextStyle(
                                  color: Colors.grey,
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
                                child: Icon(Icons.delete,
                                    size: 25, color: Color(0XffFFD39E)),
                              ),
                              Text('Trashed Tasks',
                                  style: TextStyle(
                                      color: Color(0XffFFD39E),
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          )),
    );
  }
}
