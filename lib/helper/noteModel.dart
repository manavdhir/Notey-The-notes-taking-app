class NoteModel {
  int id;
  String title;
  String body;
  // ignore: non_constant_identifier_names
  DateTime creation_date;
  NoteModel({this.body, this.id, this.title, this.creation_date});

  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "title": title,
      "body": body,
      "creation_date": creation_date.toString()
    });
  }
}
