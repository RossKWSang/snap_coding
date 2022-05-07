import 'package:flutter/material.dart';

class PolicyPage extends StatefulWidget {
  PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('약관 및 정책')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '약관 추가 부탁염 ~~',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
