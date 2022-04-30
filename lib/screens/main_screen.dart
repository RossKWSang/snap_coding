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
<<<<<<< HEAD

=======
>>>>>>> 6bd2761f9892354b256a5242b4e394ac8cc72fd2
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

  final List<String> chipSkillSets = [
    'All',
    'C',
    'C++',
    'C#',
    'Java',
    'Python',
    'Ruby',
    'PHP',
    'Javascript',
    'dart',
    'go',
    'rust',
    'html',
    'css',
    'bash',
    'typescript',
    'R',
  ];

  String curLanguage = 'All';

  @override
  Widget build(BuildContext context) {
    // isMarked = false;
    if (Provider.of<UserProvider>(context).getUser != null) {
      _isLoggedIn = true;
      bool isMarked = false;

      final User user = Provider.of<UserProvider>(context).getUser;
      markedPost = user.bookMark;
      print(
        user.recentSearch,
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Image.asset(
          'FramesnapCodingLogo.png',
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
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where(
              'devLanguage',
              arrayContains: curLanguage,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                toolbarHeight: 0,
                collapsedHeight: 70,
                expandedHeight: 400,
                backgroundColor: mobileBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        width: double.infinity,
<<<<<<< HEAD
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

                                                  // bookmarkImage(
                                                  //     snapshot
                                                  //         .data?.docs[index]
                                                  //         .data()['snapId'],
                                                  //     snapshot
                                                  //         .data?.docs[index]
                                                  //         .data()['uid']);
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
=======
                        height: 350,
                        child: TabBarView(
                          controller: _mainBannerTabController,
                          children: [
                            Image.asset(
                              'assets/images/banner1.png',
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              'assets/images/banner2.png',
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
                        height: 350,
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
>>>>>>> 6bd2761f9892354b256a5242b4e394ac8cc72fd2
                        ),
                      ),
                    ],
                  ),
                ), // 없앨 영역
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(
                    // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    height: 40,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: chipSkillSets.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  curLanguage = chipSkillSets[index];
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                    color: chipSkillSets[index] == curLanguage
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color:
                                            chipSkillSets[index] == curLanguage
                                                ? primaryColor
                                                : Colors.grey,
                                        width: 2)),
                                child: Text(
                                  chipSkillSets[index],
                                  style: TextStyle(
                                      color: chipSkillSets[index] == curLanguage
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ), // 남길 영역
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
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              filteredSnap = snapshot.data!.docs;
                          List<dynamic> filteredLanguageList =
                              filteredSnap[index].data()['devLanguage'];
                          filteredLanguageList.remove('All');

                          // print(filteredLanguageList);
                          return SnapCardMain(
                            snapId: filteredSnap[index].data()['snapId'],
                            thumbnailUrl:
                                filteredSnap[index].data()['thumbnailUrl'],
                            title: filteredSnap[index].data()['title'],
                            hashTagList: filteredSnap[index].data()['HashTag'],
                            filteredLanguageList: filteredLanguageList,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
