import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/providers/search_provider.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/global_variables.dart';
import 'package:snap_coding_2/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  // final int? routeNum;
  const MobileScreenLayout({
    Key? key,
    // this.routeNum,
  }) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with SingleTickerProviderStateMixin {
  late TabController _mainBannerTabController;
  late PageController pageController;
  late IsSearchProvider _isSearchedProvider;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _mainBannerTabController = new TabController(length: 3, vsync: this);
    pageController = PageController();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void dispose() {
    _mainBannerTabController.dispose();
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(
      () {
        _page = page;
      },
    );
  }

  int currentIndex = 0;
  void navigationTapped(int page) {
    _isSearchedProvider.unSearched();
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    _isSearchedProvider = Provider.of<IsSearchProvider>(context);

    // if (widget.routeNum != null) {
    //   print('route done');
    //   onPageChanged(widget.routeNum!);
    //   navigationTapped(widget.routeNum!);
    // }

    // print(Provider.of<UserProvider>(context).getUser == Null);
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page, // 현재 보여주는 탭
        onTap: navigationTapped,
        selectedItemColor: blueColor, // 선택된 아이콘 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
        backgroundColor: mobileBackgroundColor,
        showSelectedLabels: false, // 선택된 항목 label 숨기기
        showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
        type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: (_page == 0) ? Colors.green : secondaryColor,
            ),
            label: '홈',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: (_page == 1) ? Colors.green : secondaryColor,
            ),
            label: '검색',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: (_page == 2) ? Colors.green : secondaryColor,
            ),
            label: '업로드',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bookmark,
              color: (_page == 3) ? Colors.green : secondaryColor,
            ),
            label: '북마크',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
