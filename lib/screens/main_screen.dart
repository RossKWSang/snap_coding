import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
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
                    builder: (BuildContext context) => LoginScreen()));
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
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
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
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
          ],
        ),
      ),
    );
  }
}
