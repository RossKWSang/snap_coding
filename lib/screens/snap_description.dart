import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';

import '../providers/user_provider.dart';

class SnapDescription extends StatefulWidget {
  final String snapId;
  final String authorName;

  final int reviewNum;
  const SnapDescription({
    Key? key,
    required this.snapId,
    required this.authorName,
    required this.reviewNum,
  }) : super(key: key);

  @override
  State<SnapDescription> createState() => _SnapDescriptionState();
}

class _SnapDescriptionState extends State<SnapDescription> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('posts');

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final DocumentReference<Object?> documentSnapshot =
    //    _firestore.doc(widget.snapId);
    final User? user = Provider.of<UserProvider>(context).getUser;
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

          // List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredSnap =
          //     snapshot.data!.docs;
          List<dynamic> filteredLanguageList = data['devLanguage'];
          filteredLanguageList.remove('All');

          return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text('?????? ??????'),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 140,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 120,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox.fromSize(
                                    child: Image.network(
                                      data['thumbnailUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Icon(Icons.bookmark_border_outlined),
                                bottom: 8,
                                right: 8,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                data['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                width: 260,
                                child: Text(
                                  "Author: " + widget.authorName,
                                ),
                              ),
                              Container(
                                height: 15,
                                child: Wrap(
                                  alignment: WrapAlignment.start, // ?????? ??????
                                  children: filteredLanguageList.map<Widget>(
                                    (devLang) {
                                      return Transform(
                                        transform: new Matrix4.identity()
                                          ..scale(1.0),
                                        child: Chip(
                                          padding: EdgeInsets.all(0.5),
                                          backgroundColor: Colors.green.shade900
                                              .withOpacity(0.3),
                                          label: Text(
                                            devLang,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: HashTagText(
                        text: data['description'],
                        decoratedStyle: TextStyle(
                          fontSize: 15,
                          color: primaryColor,
                        ),
                        basicStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
