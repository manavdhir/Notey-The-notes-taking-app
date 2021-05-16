import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notey_the_notes_application/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OflineNoteList extends StatefulWidget {
  @override
  _OflineNoteListState createState() => _OflineNoteListState();
}

class _OflineNoteListState extends State<OflineNoteList> {
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getNotes(),
            builder: (context, noteData) {
              switch (noteData.connectionState) {
                case ConnectionState.waiting:
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                case ConnectionState.done:
                  {
                    if (noteData.data == Null) {
                      return Center(
                        child: Text(
                            'You dont have any notes yet ! Connect to internet to create one'),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: noteData.data.length,
                            itemBuilder: (context, index) {
                              String title = noteData.data[index]['title'];
                              int id = noteData.data[index]['id'];
                              String body = noteData.data[index]['body'];
                              String creation_date =
                                  noteData.data[index]['creation_date'];

                              return Card(
                                elevation: 8,
                                child: ListTile(
                                  title: Text(title,
                                      style: GoogleFonts.bungee(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  subtitle: Text(body),
                                ),
                              );
                            }),
                      );
                    }
                  }
              }
            }));
  }
}
