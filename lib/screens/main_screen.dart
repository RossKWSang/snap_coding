import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
// import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

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
    _mainBannerTabController = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mainBannerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    // print(userProvider.getUser.username);
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
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
                  Divider(),
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
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
