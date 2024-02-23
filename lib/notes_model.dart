// class NotesModel {
//   String? title;
//   String? description;
//   int? time;  // time ==> id

//   NotesModel({this.title, this.description, this.time});

//   NotesModel.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     description = json['description'];
//     time = json['time'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};

//     data['title'] = title;
//     data['description'] = description;
//     data['time'] = time;
//     return data;
//   }
// }

class NoteModel {
  String? title;
  String? description;
  int? time;

  NoteModel({this.title, this.description, this.time});

  NoteModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Empty Map
    data['title'] = title;
    data['description'] = description;
    data['time'] = time;
    return data;
  }
}
