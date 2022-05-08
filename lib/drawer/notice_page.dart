import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map<String, String>> notices = [
    {
      'title': '[긴급] [구인] Flutter 개발자 급구',
      'datetime': '22-05-07',
      'content':
          '공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항',
    },
    {
      'title': '[공지] [스냅 해커톤 개최] 22년 하반기',
      'datetime': '22-05-08',
      'content':
          '공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항',
    },
    {
      'title': '[이벤트] [아름다운 코드 공모] 당첨자 발표',
      'datetime': '22-05-09',
      'content':
          '김원상 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항 공지사항',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '공지 사항',
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1.0,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notices.length,
          itemBuilder: (context, index) {
            print(notices[index]['title']);

            return ExpansionTile(
              iconColor: primaryColor,
              title: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notices[index]['title'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      notices[index]['datetime'].toString(),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    notices[index]['content'].toString(),
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
