import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/drawer/contract_policy_page.dart';
import 'package:snap_coding_2/drawer/customer_call_page.dart';
import 'package:snap_coding_2/drawer/my_snap_page.dart';
import 'package:snap_coding_2/drawer/profile_page.dart';
import 'package:snap_coding_2/drawer/setting_page.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/drawer/notice_page.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: mobileDrawerColor,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            const SizedBox(
              height: 100,
            ),
            buildMenuItem(
              text: '프로필',
              icon: CupertinoIcons.person_2_fill,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: '내가 등록한 코딩',
              icon: CupertinoIcons.check_mark_circled_solid,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              color: secondaryColor,
            ),
            buildMenuItem(
              text: '공지사항',
              icon: Icons.campaign_rounded,
              onClicked: () => selectedItem(context, 2),
            ),
            buildMenuItem(
              text: '고객센터',
              icon: CupertinoIcons.phone_badge_plus,
              onClicked: () => selectedItem(context, 3),
            ),
            buildMenuItem(
              text: '환경설정',
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 4),
            ),
            buildMenuItem(
              text: '약관 및 정책',
              icon: CupertinoIcons.square_list_fill,
              onClicked: () => selectedItem(context, 5),
            ),
            const Divider(
              color: secondaryColor,
            ),
            buildMenuItem(
              text: '로그아웃',
              icon: Icons.logout_rounded,
              onClicked: () => {
                AuthMethods().signOut(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: secondaryColor,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: secondaryColor,
        ),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileUpdate(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MySnapPage(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoticePage(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CustomerCallPage(),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingPage(),
          ),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PolicyPage(),
          ),
        );
        break;
    }
  }
}
