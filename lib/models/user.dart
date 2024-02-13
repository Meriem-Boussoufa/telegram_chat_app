import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String nickname;
  final String photoUrl;
  final String createAt;

  User(
      {required this.id,
      required this.nickname,
      required this.photoUrl,
      required this.createAt});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      photoUrl: doc['photoUrl'],
      nickname: doc['nickname'],
      createAt: doc['createAt'],
    );
  }
}
