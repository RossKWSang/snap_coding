import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/utils/colors.dart';

import '../providers/user_provider.dart';

class SnapSpecific extends StatefulWidget {
  final String? snapId;
  const SnapSpecific({
    Key? key,
    required this.snapId,
  }) : super(key: key);

  @override
  State<SnapSpecific> createState() => _SnapSpecificState();
}

class _SnapSpecificState extends State<SnapSpecific> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    final DocumentReference<Object?> documentSnapshot =
        _firestore.doc(widget.snapId);
    final User user = Provider.of<UserProvider>(context).getUser;
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.doc(widget.snapId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Image.asset(
                'SnapCoding.png',
                width: 200,
              ),
              centerTitle: true,
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.person_rounded,
              //     color: secondaryColor,
              //   ),
              //   onPressed: () {
              //     // Navigator.pushReplacement(text);
              //   },
              // ),
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       CupertinoIcons.bell_fill,
              //       color: secondaryColor,
              //     ),
              //     onPressed: () {
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (BuildContext context) => LoginScreen(),
              //         ),
              //       );
              //     },
              //   ),
              // ],
            ),
            body: SafeArea(
                child: Text(
                    "Full Name: ${data['title']} ${data['description']} ${data['thumbnailUrl']}")),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
        // Scaffold(
        //   appBar: AppBar(
        //     backgroundColor: mobileBackgroundColor,
        //     title: Image.asset(
        //       'SnapCoding.png',
        //       width: 200,
        //     ),
        //     centerTitle: true,
        //     // leading: IconButton(
        //     //   icon: Icon(
        //     //     Icons.person_rounded,
        //     //     color: secondaryColor,
        //     //   ),
        //     //   onPressed: () {
        //     //     // Navigator.pushReplacement(text);
        //     //   },
        //     // ),
        //     // actions: [
        //     //   IconButton(
        //     //     icon: Icon(
        //     //       CupertinoIcons.bell_fill,
        //     //       color: secondaryColor,
        //     //     ),
        //     //     onPressed: () {
        //     //       Navigator.pushReplacement(
        //     //         context,
        //     //         MaterialPageRoute(
        //     //           builder: (BuildContext context) => LoginScreen(),
        //     //         ),
        //     //       );
        //     //     },
        //     //   ),
        //     // ],
        //   ),
        //   body: Text(
        //     // documentSnapshot.snapshots().toString(),

        //   ),
        // );
      },
    );
  }
}
