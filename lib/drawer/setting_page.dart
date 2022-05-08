import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _eventSwitch = false;
  bool _reviewReminder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '환경 설정',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '이벤트 혜택 알림',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                CupertinoSwitch(
                  value: _eventSwitch,
                  onChanged: (value) => setState(
                    () {
                      _eventSwitch = value;
                    },
                  ),
                  activeColor: primaryColor,
                )
              ],
            ),
          ),
          Divider(
            thickness: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '등록한 스냅에 리뷰쓰기 알림',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                CupertinoSwitch(
                  value: _reviewReminder,
                  onChanged: (value) => setState(
                    () {
                      _reviewReminder = value;
                    },
                  ),
                  activeColor: primaryColor,
                )
              ],
            ),
          ),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }
}
