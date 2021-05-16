import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notey_the_notes_application/colors.dart';
import 'package:notey_the_notes_application/screens/HomePage.dart';
import 'package:notey_the_notes_application/screens/videoScreen.dart';

class EditNote extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditNote(this.docToEdit);
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController videoLink = TextEditingController();

  CollectionReference new_ref =
      FirebaseFirestore.instance.collection('deleted notes');

  @override
  void initState() {
    title = TextEditingController(text: widget.docToEdit['title']);
    description = TextEditingController(text: widget.docToEdit['description']);
    if (widget.docToEdit['video'] != null) {
      videoLink = TextEditingController(text: widget.docToEdit['video']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xffffcdab),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text('Edit Your note',
              style: GoogleFonts.bungee(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height),
                color: Color(0xffffcdab),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Title for the note",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //title textfield
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.all(10),
                          child: TextField(
                            controller: title,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                hintText: 'Title', border: InputBorder.none),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //description textField
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: description,
                              maxLines: 6,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: 'Add description here',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),

                      //add video logic

                      Visibility(
                        visible: widget.docToEdit['video'] != "",
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Link for the video",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            //video link textfield
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: videoLink,
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                      hintText: 'Video link',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            //play video button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            VideoScreen(videoLink.text)));
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  width: 300,
                                  child: Center(
                                    child: Text(
                                      "Play Video",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                      //add note to firebase button
                      ,
                      InkWell(
                        onTap: () {
                          if (title.text == '') {
                            Fluttertoast.showToast(
                                msg: "Title cannot be empty");
                          } else {
                            widget.docToEdit.reference.update({
                              'title': title.text,
                              'description': description.text
                            }).whenComplete(() => {
                                  Fluttertoast.showToast(msg: "Changes saved"),
                                  Navigator.pop(context)
                                });
                          }
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: 300,
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffffcdab),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //delete button
                      InkWell(
                        onTap: () {
                          _showAlertDailog(context);
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: 300,
                            child: Center(
                              child: Text(
                                "Delete this note ?",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _showAlertDailog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Are you sure you want to delete this note',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              new FlatButton(
                  onPressed: () {
                    new_ref.add({
                      'title': title.text,
                      'description': description.text,
                      'video': videoLink.text
                    });
                    widget.docToEdit.reference.delete().whenComplete(
                        () => {Fluttertoast.showToast(msg: 'Note deleted')});

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: new Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  )),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}
