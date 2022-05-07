import 'package:cloud_firestore/cloud_firestore.dart';

class Snap {
  final String uid;
  final String snapId;
  final String title;
  final String username;
  final List<String> hashTag;
  final String thumbnailUrl;
  final String description;
  final int price;
  final List<String> devLanguage;
  final List<String> codeImage;
  final List<String> buyer;
  final Map<String, dynamic> codeSnippet;
  // final Buyer ???

  const Snap({
    required this.uid,
    required this.snapId,
    required this.title,
    required this.username,
    required this.hashTag,
    required this.thumbnailUrl,
    required this.description,
    required this.price,
    required this.devLanguage,
    required this.codeImage,
    required this.buyer,
    required this.codeSnippet,
  });

  static Snap fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Snap(
      uid: snapshot["uid"],
      snapId: snapshot["snapId"],
      title: snapshot["title"],
      username: snapshot["username"],
      hashTag: snapshot["hashTag"],
      thumbnailUrl: snapshot["thumbnailUrl"],
      description: snapshot["description"],
      price: snapshot["price"],
      devLanguage: snapshot["devLanguage"],
      codeImage: snapshot["codeImage"],
      buyer: snapshot["buyer"],
      codeSnippet: snapshot["codeSnippet"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "snapId": snapId,
        "title": title,
        "username": username,
        "HashTag": hashTag,
        "thumbnailUrl": thumbnailUrl,
        "description": description,
        "price": price,
        "devLanguage": devLanguage,
        "codeImage": codeImage,
        "buyer": buyer,
        "codeSnippet": codeSnippet,
      };
}
