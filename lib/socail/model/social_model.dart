import 'package:cloud_firestore/cloud_firestore.dart';

// class Social {
//   String? id;
//   String? title;
//   String? content;
//   String? userMail;
//   List images;
//   Timestamp? timestamp;

//   Social(
//       {required this.id,
//       required this.title,
//       required this.content,
//       required this.userMail,
//       required this.images,
//       required this.timestamp});

//   Social copyWith({
//     String? id,
//     String? title,
//     String? content,
//     String? userMail,
//     List? images,
//     Timestamp? timestamp,
//   }) {
//     return Social(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         content: content ?? this.content,
//         userMail: userMail ?? this.userMail,
//         timestamp: timestamp ?? this.timestamp,
//         images: []);
//   }
// }

class Social {
  String? id;
  String? title;
  String? content;
  String? userMail;
  String? userUid;
  List? images;
  Timestamp? timestamp;

  Social(
      {required this.id,
      required this.title,
      required this.content,
      required this.userMail,
      required this.userUid,
      required this.images,
      required this.timestamp});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        userMail: json['userMail'],
        userUid: json['usserUid'],
        images: json['images'],
        timestamp: json['timestamp']);
  }
}
