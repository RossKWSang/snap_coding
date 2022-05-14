import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/models/user.dart' as model;
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/widgets/snap_card.dart';

import '../drawer/navigation_drawer_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _mainBannerTabController = new TabController(length: 3, vsync: this);
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

  String uid = '';
  String username = '';
  List bookmark = [];

  Future<void> getUserInfo() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;

    if (_auth.currentUser == null) {
      return;
    }
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    uid = model.User.fromSnap(documentSnapshot).uid;
    username = model.User.fromSnap(documentSnapshot).username;
    bookmark = model.User.fromSnap(documentSnapshot).bookMark;
  }

  @override
  Widget build(BuildContext context) {
    setState(
      () {
        getUserInfo();
      },
    );

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      fireAuth.User currentUser = _auth.currentUser!;
      _isLoggedIn = true;
      uid = currentUser.uid;
      // print(
      //   currentUser.uid.toString(),
      // );
    } else {
      // print('anonymous');
    }

    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Image.asset(
          'FramesnapCodingLogo.png',
          width: 200,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.person_rounded,
                color: secondaryColor,
              ),
              onPressed: () =>
                  //{
                  _isLoggedIn
                      ? Scaffold.of(context).openDrawer()
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                        ),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
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
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => LoginScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy(
              'created',
              descending: true,
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
                expandedHeight: 350,
                backgroundColor: mobileBackgroundColor,
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
                              'assets/images/banner1.png',
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              'assets/images/banner2.png',
                              fit: BoxFit.fill,
                            ),
                            Image.asset(
                              'assets/images/banner3.png',
                              fit: BoxFit.fill,
                            ),
                            // Image.asset(
                            //   'assets/images/banner4.jpg',
                            //   fit: BoxFit.fill,
                            // ),
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(
                    // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    height: 40,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: mobileBackgroundColor,
                      ),
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
                          // filteredLanguageList.remove('All');

                          // print(filteredLanguageList);
                          return filteredLanguageList.contains(curLanguage)
                              ? Column(
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
                                                        snapId: filteredSnap[
                                                                index]
                                                            .data()['snapId'],
                                                        uid: userProvider
                                                            .getUser.uid,
                                                        username: userProvider
                                                            .getUser.username,
                                                      )
                                                    : SnapSpecific(
                                                        snapId: filteredSnap[
                                                                index]
                                                            .data()['snapId'],
                                                        uid: 'notloggedin',
                                                        username: 'notloggedin',
                                                      ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                        BorderRadius.circular(
                                                      16,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: SizedBox.fromSize(
                                                      child: Image.network(
                                                        filteredSnap[index]
                                                                .data()[
                                                            'thumbnailUrl'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                !_isLoggedIn
                                                    ? Container()
                                                    : Positioned(
                                                        child: IconButton(
                                                          icon: filteredSnap[
                                                                      index]
                                                                  .data()[
                                                                      'bookMark']
                                                                  .contains(
                                                                    userProvider
                                                                        .getUser
                                                                        .uid,
                                                                  )
                                                              ? Icon(
                                                                  Icons
                                                                      .bookmark,
                                                                  color:
                                                                      primaryColor,
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .bookmark_border_outlined,
                                                                  color:
                                                                      primaryColor,
                                                                ),

                                                          // Icon(
                                                          //   Icons.bookmark_border_outlined,
                                                          //   color: filteredSnap[index]
                                                          //           .data()['bookMark']
                                                          //           .contains(
                                                          //             userProvider
                                                          //                 .getUser.uid,
                                                          //           )
                                                          //       ? Colors.white
                                                          //       : Colors.black,
                                                          // ),
                                                          onPressed: () async {
                                                            //isMarked = !isMarked;
                                                            if (_isLoggedIn) {
                                                              await FireStoreMethods()
                                                                  .bookmarkPost(
                                                                filteredSnap[
                                                                            index]
                                                                        .data()[
                                                                    'snapId'],
                                                                userProvider
                                                                    .getUser
                                                                    .uid,
                                                                filteredSnap[
                                                                            index]
                                                                        .data()[
                                                                    'bookMark'],
                                                              );

                                                              await FireStoreMethods()
                                                                  .bookmarkforUser(
                                                                filteredSnap[
                                                                            index]
                                                                        .data()[
                                                                    'snapId'],
                                                                userProvider
                                                                    .getUser
                                                                    .uid,
                                                                userProvider
                                                                    .getUser
                                                                    .bookMark,
                                                              );
                                                            } else {}
                                                            ;
                                                            //  setState(() {});
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
                                                  filteredSnap[index]
                                                      .data()['title'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: 260,
                                                  child: Wrap(
                                                    alignment: WrapAlignment
                                                        .start, // 정렬 방식

                                                    children:
                                                        filteredSnap[index]
                                                            .data()['HashTag']
                                                            .map<Widget>(
                                                                (hashTag) {
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
                                                Container(
                                                  height: 15,
                                                  child: Wrap(
                                                    // spacing: 5, // 상하(좌우) 공간
                                                    // runSpacing: 2,
                                                    alignment: WrapAlignment
                                                        .start, // 정렬 방식

                                                    children:
                                                        filteredLanguageList
                                                            .map<Widget>(
                                                                (devLang) {
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
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container();
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
