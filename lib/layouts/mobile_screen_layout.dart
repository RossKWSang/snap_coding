import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with SingleTickerProviderStateMixin {
  late TabController _mainBannerTabController;
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _mainBannerTabController = new TabController(length: 3, vsync: this);
    pageController = PageController();
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
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.person_rounded,
      //       color: secondaryColor,
      //     ),
      //     onPressed: () {},
      //   ),
      //   title: Text(
      //     'Snap Coding Main',
      //     style: TextStyle(
      //       color: secondaryColor,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: PageView(
        children: homeScreenItems,
        // [
        // SafeArea(
        //   child: Column(
        //     children: [
        //       Stack(
        //         children: [
        //           Container(
        //             width: double.infinity,
        //             height: 200,
        //             child: TabBarView(
        //               controller: _mainBannerTabController,
        //               children: [
        //                 Image.asset(
        //                   'assets/images/banner1.jpg',
        //                   fit: BoxFit.fill,
        //                 ),
        //                 Image.asset(
        //                   'assets/images/banner2.jpg',
        //                   fit: BoxFit.fill,
        //                 ),
        //                 Image.asset(
        //                   'assets/images/banner3.jpg',
        //                   fit: BoxFit.fill,
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             width: double.infinity,
        //             height: 200,
        //             child: Column(
        //               children: [
        //                 Spacer(),
        //                 TabPageSelector(
        //                   controller: _mainBannerTabController,
        //                   selectedColor: secondaryColor,
        //                 ),
        //                 SizedBox(
        //                   height: 5,
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        //   Center(child: Text('homeScreen')),
        //   Center(child: Text('search')),
        //   Center(child: Text('add')),
        //   Center(child: Text('alert')),
        //   Center(child: Text('meetup')),
        // ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page, // 현재 보여주는 탭
        onTap: navigationTapped,
        selectedItemColor: blueColor, // 선택된 아이콘 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
        backgroundColor: primaryColor,
        showSelectedLabels: false, // 선택된 항목 label 숨기기
        showUnselectedLabels: false, // 선택되지 않은 항목 label 숨기기
        type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              color: (_page == 0) ? blueColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: (_page == 1) ? blueColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: (_page == 2) ? blueColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bell_fill,
              color: (_page == 3) ? blueColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: (_page == 4) ? blueColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
