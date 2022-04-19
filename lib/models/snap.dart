import 'package:cloud_firestore/cloud_firestore.dart';

class Snap {
  final String title;
  final String photoUrl;
  final String language;
  final String detail;
  final List hashtag;
  final int like;

  const Snap({
    required this.title,
    required this.photoUrl,
    required this.language,
    required this.detail,
    required this.hashtag,
    required this.like,
  });

  static Snap fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Snap(
      title: snapshot["title"],
      photoUrl: snapshot["photoUrl"],
      language: snapshot["language"],
      detail: snapshot["detail"],
      hashtag: snapshot["hashtag"],
      like: snapshot["like"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "photoUrl": photoUrl,
        "language": language,
        "detail": detail,
        "hashtag": hashtag,
        "like": like,
      };
}
