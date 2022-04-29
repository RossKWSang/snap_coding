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
import 'package:provider/provider.dart';
import 'package:snap_coding_2/widgets/snap_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  late TabController _mainBannerTabController;

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
    // if (Provider.of<UserProvider>(context).getUser != null) {
    //   _isLoggedIn = true;
    //   final User user = Provider.of<UserProvider>(context).getUser;
    // }

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
