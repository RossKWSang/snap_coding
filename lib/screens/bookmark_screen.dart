import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import '../utils/colors.dart';
import 'snap_specific.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  bool isMarked = false;
  bool _isLoggedIn = false;
  String _curUid = '';

  // void bookmarkPost(String postId, String uid, List bookmark) async {
  //   setState(() {});
  //   try {
  //     String res = await FireStoreMethods.bookmarkPost(
  //       _,
  //   ,
  //   ,
  //     );
  //   } catch (err) {}
  // }

  @override
  Widget build(BuildContext context) {
    User? userData;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      fireAuth.User currentUser = _auth.currentUser!;
      _curUid = currentUser.uid.toString();
      _isLoggedIn = true;
      print(
        currentUser.uid.toString(),
      );
    } else {
      print('anonymous');
    }
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _isLoggedIn
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                'My 스냅 스크랩북',
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where(
                        'bookMark',
                        arrayContains: userProvider.getUser.uid,
                      )
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              List<dynamic> filteredLanguageList = snapshot
                                  .data!.docs[index]
                                  .data()['devLanguage'];
                              filteredLanguageList.remove('All');
                              return Column(
                                children: [
                                  Row(),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              _isLoggedIn
                                                  ? SnapSpecific(
                                                      snapId: snapshot
                                                          .data!.docs[index]
                                                          .data()['snapId'],
                                                      uid: userProvider
                                                          .getUser.uid,
                                                      username: userProvider
                                                          .getUser.username,
                                                    )
                                                  : SnapSpecific(
                                                      snapId: snapshot
                                                          .data!.docs[index]
                                                          .data()['snapId'],
                                                      uid: 'notloggedin',
                                                      username: 'notloggedin',
                                                    ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      height: 140,
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 120,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: SizedBox.fromSize(
                                                    child: Image.network(
                                                      snapshot.data!.docs[index]
                                                              .data()[
                                                          'thumbnailUrl'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   child: IconButton(
                                              //     icon: Icon(
                                              //       Icons.remove_circle_rounded,
                                              //       color: Colors.red[900],
                                              //     ),
                                              //     onPressed: () async {
                                              //       //isMarked = !isMarked;
                                              //       await FireStoreMethods()
                                              //           .bookmarkPost(
                                              //         snapshot.data?.docs[index]
                                              //             .data()['snapId'],
                                              //         userProvider.getUser.uid,
                                              //         snapshot.data?.docs[index]
                                              //             .data()['bookMark'],
                                              //       );

                                              //       await FireStoreMethods()
                                              //           .bookmarkforUser(
                                              //         snapshot.data?.docs[index]
                                              //             .data()['snapId'],
                                              //         userProvider.getUser.uid,
                                              //         snapshot.data?.docs[index]
                                              //             .data()['bookMark'],
                                              //       );
                                              //     },
                                              //   ),
                                              //   bottom: 0,
                                              //   right: 0,
                                              // )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.63,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          .data()['title'],
                                                      // snapshot.data!.docs[index]
                                                      //     .data()['snapId'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      onPressed: () async {
                                                        //isMarked = !isMarked;
                                                        await FireStoreMethods()
                                                            .bookmarkPost(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .data()['snapId'],
                                                          userProvider
                                                              .getUser.uid,
                                                          snapshot.data
                                                                  ?.docs[index]
                                                                  .data()[
                                                              'bookMark'],
                                                        );

                                                        await FireStoreMethods()
                                                            .bookmarkforUser(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .data()['snapId'],
                                                          userProvider
                                                              .getUser.uid,
                                                          snapshot.data
                                                                  ?.docs[index]
                                                                  .data()[
                                                              'bookMark'],
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red[900],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),

                                              Container(
                                                height: 30,
                                                width: 260,
                                                child: Wrap(
                                                  alignment: WrapAlignment
                                                      .start, // 정렬 방식

                                                  children: snapshot
                                                      .data!.docs[index]
                                                      .data()['HashTag']
                                                      .map<Widget>((hashTag) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Text(
                                                        hashTag,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              // Text(
                                              //   snapshot.data!.docs[index]
                                              //       .data()['description']
                                              //       .substring(0, 10),
                                              //   style: TextStyle(
                                              //       color: Colors.grey),
                                              // ),
                                              Container(
                                                height: 15,
                                                child: Wrap(
                                                  // spacing: 5, // 상하(좌우) 공간
                                                  // runSpacing: 2,
                                                  alignment: WrapAlignment
                                                      .start, // 정렬 방식

                                                  children: filteredLanguageList
                                                      .map<Widget>((devLang) {
                                                    if (devLang == 'All') {
                                                      return Container();
                                                    } else {
                                                      return Transform(
                                                        transform: new Matrix4
                                                            .identity()
                                                          ..scale(1.0),
                                                        child: Chip(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.2),
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade900
                                                                  .withOpacity(
                                                                      0.3),
                                                          label: Text(
                                                            devLang,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                'My 스냅 스크랩북',
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
              centerTitle: false,
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                  ),
                  Text(
                    '로그인이 필요한 서비스입니다.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '로그인 페이지로 이동하기.',
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
