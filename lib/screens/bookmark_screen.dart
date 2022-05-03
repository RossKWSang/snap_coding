import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';

import '../utils/colors.dart';
import 'snap_specific.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  bool isMarked = false;

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
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
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
                  .where('bookMark', arrayContains: userProvider.getUser.uid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                                          SnapSpecific(
                                        snapId: snapshot.data!.docs[index]
                                            .data()['snapId'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 140,
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: SizedBox.fromSize(
                                                child: Image.network(
                                                  snapshot.data!.docs[index]
                                                      .data()['thumbnailUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.bookmark_border_outlined,
                                                // color: markedPost.contains(
                                                //         snapshot
                                                //             .data?.docs[index]
                                                //             .data()['snapId'])
                                                //     ? Colors.white
                                                //     : Colors.black,
                                              ),
                                              onPressed: () async {
                                                //isMarked = !isMarked;
                                                await FireStoreMethods()
                                                    .bookmarkforPost(
                                                  snapshot.data?.docs[index]
                                                      .data()['snapId'],
                                                  userProvider.getUser.uid,
                                                  snapshot.data?.docs[index]
                                                      .data()['bookMark'],
                                                );

                                                await FireStoreMethods()
                                                    .bookmarkforUser(
                                                  snapshot.data?.docs[index]
                                                      .data()['snapId'],
                                                  userProvider.getUser.uid,
                                                  snapshot.data?.docs[index]
                                                      .data()['bookMark'],
                                                );
                                              },
                                            ),
                                            bottom: 0,
                                            right: 0,
                                          )
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
                                          Text(
                                            snapshot.data!.docs[index]
                                                .data()['title'],
                                            // snapshot.data!.docs[index]
                                            //     .data()['snapId'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                .data()['description']
                                                .substring(0, 30),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Chip(
                                                backgroundColor: Colors
                                                    .green.shade900
                                                    .withOpacity(0.3),
                                                label: Text(
                                                  '#JavaScript',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Chip(
                                                backgroundColor: Colors
                                                    .green.shade900
                                                    .withOpacity(0.3),
                                                label: Text(
                                                  '#마켓컬리',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ],
                                          )
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
        ));
  }
}
