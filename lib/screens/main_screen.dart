import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/widgets/snap_card.dart';
import '../resources/firestore_methods.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  bool isMarked = false;
  List markedPost = [];

  late TabController _mainBannerTabController;

  // void bookmarkImage(String snapId, String uid) async {
  //   if (markedPosts.contains(snapId)) {
  //     markedPosts.remove(snapId);
  //   } else {
  //     markedPosts.add(snapId);
  //   }
  // }
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
  void initState() {
    super.initState();
    _mainBannerTabController = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mainBannerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isMarked = false;
    if (Provider.of<UserProvider>(context).getUser != null) {
      _isLoggedIn = true;
      bool isMarked = false;

      final User user = Provider.of<UserProvider>(context).getUser;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Image.asset(
          'SnapCoding.png',
          width: 200,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.person_rounded,
            color: secondaryColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.bell_fill,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  toolbarHeight: 0,
                  collapsedHeight: 0,
                  expandedHeight: 252,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          child: TabBarView(
                            controller: _mainBannerTabController,
                            children: [
                              Image.asset(
                                'assets/images/banner1.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/banner2.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/banner3.jpg',
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/banner4.jpg',
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 300,
                          child: Column(
                            children: [
                              Spacer(),
                              TabPageSelector(
                                controller: _mainBannerTabController,
                                selectedColor: secondaryColor,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), // 없앨 영역
                  // bottom: PreferredSize(
                  //   preferredSize: Size.fromHeight(50),
                  //   child: Container(
                  //     padding: EdgeInsets.fromLTRB(20, 25, 10, 0),
                  //     height: 60,
                  //     child: Row(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               Icons.mail_outline,
                  //               color: Colors.grey,
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text("What's New"),
                  //           ],
                  //         ),
                  //         SizedBox(width: 20),
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               CupertinoIcons.ticket,
                  //               color: Colors.grey,
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text("Coupon"),
                  //           ],
                  //         ),
                  //         Spacer(),
                  //         Stack(
                  //           children: [
                  //             Icon(
                  //               CupertinoIcons.bell,
                  //             ),
                  //             Positioned(
                  //               right: 0,
                  //               child: Container(
                  //                 width: 10,
                  //                 height: 10,
                  //                 padding: EdgeInsets.all(1),
                  //                 decoration: BoxDecoration(
                  //                     color: primaryColor,
                  //                     borderRadius: BorderRadius.circular(20)),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ), // 남길 영역
                ),
                SliverToBoxAdapter(
                  child: Column(
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
                                                  Icons
                                                      .bookmark_border_outlined,
                                                  color: markedPost.contains(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .data()['snapId'])
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                onPressed: () async {
                                                  //isMarked = !isMarked;
                                                  await FireStoreMethods()
                                                      .bookmarkforPost(
                                                    snapshot.data?.docs[index]
                                                        .data()['snapId'],
                                                    snapshot.data?.docs[index]
                                                        .data()['uid'],
                                                    snapshot.data?.docs[index]
                                                        .data()['bookMark'],
                                                  );
                                                  markedPost.contains(snapshot
                                                          .data?.docs[index]
                                                          .data()['snapId'])
                                                      ? markedPost.remove(
                                                          snapshot
                                                              .data?.docs[index]
                                                              .data()['snapId'])
                                                      : markedPost.add(snapshot
                                                          .data?.docs[index]
                                                          .data()['snapId']);
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
                                            // RichText(
                                            //     text: TextSpan(
                                            //         children: <TextSpan>[
                                            //       TextSpan(
                                            //         text: '20% ',
                                            //         style: TextStyle(
                                            //             color: Colors.red,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             fontSize: 24),
                                            //       ),
                                            //       TextSpan(
                                            //         text: '30,000',
                                            //         style: TextStyle(
                                            //             color: whiteColor,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             fontSize: 24),
                                            //       ),
                                            //     ])),
                                            // SizedBox(
                                            //   height: 8,
                                            // ),
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
