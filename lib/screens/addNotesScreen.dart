import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNotesScreen extends StatefulWidget {
  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0XffFFD39E),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            'Add a new note',
            style: GoogleFonts.bungee(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height),
                color: Color(0XffFFD39E),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Add the title for the note",
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
                      //add note to firebase button
                      InkWell(
                        onTap: () {
                          if (title.text == '') {
                            Fluttertoast.showToast(
                                msg: "Title cannot be empty");
                          } else {
                            ref.add({
                              'title': title.text,
                              'description': description.text
                            }).whenComplete(() => {
                                  Fluttertoast.showToast(msg: "Note saved"),
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
                                "Add Task",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0XffFFD39E),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
