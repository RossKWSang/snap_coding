import 'dart:typed_data';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:snap_coding_2/models/user.dart' as model;
import 'package:snap_coding_2/resources/storage_method.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User? currentUser = _auth.currentUser!;
    if (currentUser == false || currentUser.isAnonymous) {
      model.User dummyUser = model.User(
        email: "dummy",
        uid: "dummy",
        username: "dummy",
        usercate: "dummy",
        postSnapId: [],
        skillSet: [],
        interests: [],
        bookMark: [],
        devExp: "dummy",
        recentSearch: [],
      );
      return dummyUser;
    }

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String usercate,
    required String devExp,
    required List skillSets,
  }) async {
    String res = "Some error Occurred";
    List<String> bookmark = [];
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          usercate.isNotEmpty ||
          skillSets != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User _user = model.User(
          username: username,
          usercate: usercate,
          uid: cred.user!.uid,
          // photoUrl: photoUrl,
          postSnapId: [],
          email: email,
          skillSet: skillSets,
          bookMark: bookmark,
          interests: [],
          devExp: devExp,
          recentSearch: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> recentSearchUpdate({
    required String userId,
    required List<dynamic> searchKeyWord,
  }) async {
    String res = "success";
    try {
      _firestore.collection('users').doc(userId).update(
        {
          'recentSearch': searchKeyWord,
        },
      );
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> recentSearchInitialize({
    required String userId,
  }) async {
    String res = "success";
    List<dynamic> _initializedList = [];
    try {
      _firestore.collection('users').doc(userId).update(
        {
          'recentSearch': _initializedList,
        },
      );
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> changePassword(
    String userEmail,
    String currentPassword,
    String newPassword,
  ) async {
    String res = "success";

    final User? user = await FirebaseAuth.instance.currentUser!;
    if (user == null) {
      return 'User is null';
    }
    final cred = EmailAuthProvider.credential(
      email: userEmail,
      password: currentPassword,
    );

    user.reauthenticateWithCredential(cred).then(
      (value) {
        user.updatePassword(newPassword).then(
          (_) {
            return "success";
            //Success, do something
          },
        ).catchError(
          (error) {
            return "error".toString();
          },
        );
      },
    ).catchError(
      (err) {
        return "err".toString();
      },
    );
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
