import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

import 'package:code_editor/code_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/screens/code_display.dart';
import 'package:snap_coding_2/screens/comment_specific.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/screens/main_screen.dart';
import 'package:snap_coding_2/screens/snap_description.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';
import 'package:snap_coding_2/widgets/comment_card.dart';

import '../providers/user_provider.dart';

class SnapSpecific extends StatefulWidget {
  final String snapId;
  final String uid;
  final String username;
  const SnapSpecific({
    Key? key,
    required this.snapId,
    required this.uid,
    required this.username,
  }) : super(key: key);

  @override
  State<SnapSpecific> createState() => _SnapSpecificState();
}

class _SnapSpecificState extends State<SnapSpecific> {
  bool _isLoggedin = false;
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('posts');

  final TextEditingController _commentController = TextEditingController();

  void postComment(String uid, String name) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.snapId,
        _commentController.text,
        uid,
        name,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        _commentController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final DocumentReference<Object?> documentSnapshot =
    //    _firestore.doc(widget.snapId);
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;

    if (_auth.currentUser != null) {
      _isLoggedin = true;
    }

    // if (Provider.of<UserProvider>(context).getUser != null) {}

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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(''),
              centerTitle: false,
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snapId)
                  .collection('comments')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                print(snapshot.data!.docs.length);
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 140,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 110,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border:
                                            Border.all(color: Colors.white)),
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
                                    width: 200,
                                    child: Text(
                                      "Author: " + data['username'],
                                    ),
                                  ),
                                  Container(
                                    height: 15,
                                    child: Wrap(
                                      // spacing: 5, // 상하(좌우) 공간
                                      // runSpacing: 2,
                                      alignment: WrapAlignment.start, // 정렬 방식
                                      children:
                                          filteredLanguageList.map<Widget>(
                                        (devLang) {
                                          return Transform(
                                            transform: new Matrix4.identity()
                                              ..scale(1.0),
                                            child: Chip(
                                              padding: EdgeInsets.all(0.5),
                                              backgroundColor: Colors
                                                  .green.shade900
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
                              widget.uid == data['uid']
                                  ? PopupMenuButton(
                                      icon: Icon(Icons.more_vert),
                                      onSelected: (result) {
                                        if (result == 0) {
                                          FireStoreMethods()
                                              .deletePost(widget.snapId);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage()));
                                        } else {}
                                      },
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text('삭제하기'),
                                              value: 0,
                                            ),
                                            PopupMenuItem(child: Text('수정하기')),
                                          ])
                                  : PopupMenuButton(
                                      icon: Icon(Icons.more_vert),
                                      onSelected: (result) {
                                        if (result == 0) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('신고 접수 완료'),
                                                  content:
                                                      Text('검토 후 조치하겠습니다.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () => {
                                                              Navigator.pop(
                                                                  context)
                                                            },
                                                        child: Text('확인'))
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text('신고하기'),
                                              value: 0,
                                            ),
                                          ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.bookmark_fill,
                                  color: secondaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '스크랩 ${data['bookMark'].length}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.chat_bubble_fill,
                                  color: secondaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '리뷰수 ${snapshot.data!.docs.length}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CodeDisplay(
                                    codeSnippet: data['codeSnippet'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '코드보러 가기',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Text(
                            '스냅 정보',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: data['description'].length > 100
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HashTagText(
                                      text: data['description']
                                              .substring(0, 100) +
                                          ' ...',
                                      decoratedStyle: TextStyle(
                                        fontSize: 15,
                                        color: primaryColor,
                                      ),
                                      basicStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SnapDescription(
                                              authorName: data['username'],
                                              reviewNum:
                                                  snapshot.data!.docs.length,
                                              snapId: widget.snapId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '펼쳐보기',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HashTagText(
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
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // width: double.infinity,
                          child: Text(
                            '리뷰 작성하기',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFieldComment(
                          textEditingController: _commentController,
                          hintText: '리뷰 내용을 작성해주세요.',
                          textInputType: TextInputType.text,
                          cursorColor: primaryColor,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        _isLoggedin
                            ? InkWell(
                                onTap: () => postComment(
                                  widget.uid,
                                  widget.username,
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  // width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '리뷰쓰기',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen(),
                                  ),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  // width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '리뷰를 쓰려면 로그인 하세요.',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // width: double.infinity,
                          child: Text(
                            '리뷰 ${snapshot.data!.docs.length}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          // height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length >= 3
                                ? 3
                                : snapshot.data!.docs.length != 0
                                    ? snapshot.data!.docs.length
                                    : 1,
                            //snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return snapshot.data!.docs.length != 0
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            commentCard(
                                              snapId: snapshot.data!.docs[index]
                                                  ['uid'],
                                              username: snapshot
                                                  .data!.docs[index]['name'],
                                              comment: snapshot
                                                  .data!.docs[index]['text'],
                                              datePublished: snapshot.data!
                                                  .docs[index]['datePublished'],
                                              isReported: false,
                                            ),
                                            widget.uid ==
                                                    snapshot.data!.docs[index]
                                                        ['uid']
                                                ? PopupMenuButton(
                                                    icon: Icon(Icons.more_vert),
                                                    onSelected: (result) {
                                                      if (result == 0) {
                                                        FireStoreMethods()
                                                            .deleteComment(
                                                          widget.snapId,
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['commentId'],
                                                        );
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text('삭제하기'),
                                                        value: 0,
                                                      ),
                                                    ],
                                                  )
                                                : PopupMenuButton(
                                                    icon: Icon(Icons.more_vert),
                                                    onSelected: (result) {
                                                      if (result == 0) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    '신고 접수 완료'),
                                                                content: Text(
                                                                    '검토 후 조치하겠습니다.'),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                                Navigator.pop(context)
                                                                              },
                                                                      child: Text(
                                                                          '확인'))
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    },
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text('신고하기'),
                                                        value: 0,
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: Text(
                                        '리뷰가 없네요 .. 의견을 남겨보세요!',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        snapshot.data!.docs.length != 0
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CommentSpecific(
                                          snapId: widget.snapId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '펼쳐보기',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 20,
                              ),
                      ],
                    ),
                  ),
                );
              },
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
