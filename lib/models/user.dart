import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String usercate;
  final List skillSet;
  final List interests;
  final double devExp;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.usercate,
    required this.skillSet,
    required this.interests,
    required this.devExp,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      usercate: snapshot["usercate"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      skillSet: snapshot["skillSet"],
      interests: snapshot["interests"],
      devExp: snapshot["devExp"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "usercate": usercate,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "skillSet": skillSet,
        "interests": interests,
        "devExp": devExp,
      };
}
