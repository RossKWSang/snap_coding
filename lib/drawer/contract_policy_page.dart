import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

class PolicyPage extends StatefulWidget {
  PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  List<Map<String, String>> policies = [
    {
      'title': '개인정보 보호 약관',
      'content':
          '개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 개인정보 보호 약관 '
    },
    {
      'title': '약관 및 정책 1',
      'content':
          '약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 약관 및 정책 1 ',
    },
    {
      'title': '약관 및 정책 2',
      'content':
          '약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 약관 및 정책 2 ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '약관 및 정책',
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: policies.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              iconColor: primaryColor,
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policies[index]['title'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    policies[index]['content'].toString(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
