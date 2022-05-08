import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

class CustomerCallPage extends StatefulWidget {
  CustomerCallPage({Key? key}) : super(key: key);

  @override
  State<CustomerCallPage> createState() => _CustomerCallPageState();
}

class _CustomerCallPageState extends State<CustomerCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '고객 센터',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            Image.asset(
              "kakaotalk.png",
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 70.0,
                ),
                child: Text(
                  '오픈 카톡 연결하기',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
