import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

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
              onClicked: () => 
            ),
            buildMenuItem(
              text: '내가 등록한 코딩',
              icon: CupertinoIcons.check_mark_circled_solid,
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
            ),
            buildMenuItem(
              text: '고객센터',
              icon: CupertinoIcons.phone_badge_plus,
            ),
            buildMenuItem(
              text: '환경설정',
              icon: Icons.settings,
            ),
            buildMenuItem(
              text: '약관 및 정책',
              icon: CupertinoIcons.square_list_fill,
            ),
            const Divider(
              color: secondaryColor,
            ),
            buildMenuItem(
              text: '로그아웃',
              icon: Icons.logout_rounded,
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
      Navigator.of(context).push(MaterialPageRoute)
    }
  }

}
