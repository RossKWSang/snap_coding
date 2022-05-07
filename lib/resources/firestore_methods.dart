import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_coding_2/models/snap.dart';
import 'package:snap_coding_2/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String title,
    String description,
    List<String> hashTag,
    List<String> devLanguage,
    Uint8List file,
    String uid,
    String username,
    // String profImage,
    List<String> bookMark,
    Map<String, dynamic> codeSnippet,
  ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String thumbnailUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String snapId = const Uuid().v1(); // creates unique id based on time
      Snap post = Snap(
        uid: uid,
        snapId: snapId,
        title: title,
        username: username,
        hashTag: hashTag,
        thumbnailUrl: thumbnailUrl,
        description: description,
        price: 10000,
        devLanguage: devLanguage,
        codeImage: [],
        buyer: [],
        codeSnippet: codeSnippet,
      );
      _firestore.collection('posts').doc(snapId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> bookmarkPost(
    String snapId,
    String uid,
    List bookmarkPost,
  ) async {
    String res = "Some error occurred";
    try {
      if (bookmarkPost.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(snapId).update(
          {
            'bookMark': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(snapId).update(
          {
            'bookMark': FieldValue.arrayUnion([uid]),
          },
        );
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> bookmarkforUser(
    //add bookMark to posts collection
    String snapId,
    String uid,
    List bookmarkUser,
  ) async {
    String res = "Some error occurred";
    try {
      if (bookmarkUser.contains(snapId)) {
        // check if list of bookmark contains uid
        // if the likes list contains the user uid, we need to remove it
        await _firestore.collection('users').doc(uid).update(
          {
            'bookMark': FieldValue.arrayRemove([snapId]),
          },
        );
        // await _firestore.collection('posts').doc(snapId).update(
        //   {
        //     'bookMark': FieldValue.arrayRemove([uid]),
        //   },
        // );
      } else {
        // else we need to add uid to the likes array
        await _firestore.collection('users').doc(uid).update(
          {
            'bookMark': FieldValue.arrayUnion([snapId])
          },
        );
        // await _firestore.collection('posts').doc(snapId).update(
        //   {
        //     'bookMark': FieldValue.arrayUnion([uid])
        //   },
        // );
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'reported': [],
            'datePublished': DateTime.now(),
          },
        );
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<void> followUser(String uid, String followId) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('users').doc(uid).get();
  //     List following = (snap.data()! as dynamic)['following'];

  //     if (following.contains(followId)) {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayRemove([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayUnion([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
