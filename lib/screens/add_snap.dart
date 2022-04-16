import 'package:flutter/material.dart';
import 'package:snap_coding_2/utils/colors.dart';

class AddSnapScreen extends StatefulWidget {
  const AddSnapScreen({Key? key}) : super(key: key);

  @override
  State<AddSnapScreen> createState() => _AddSnapScreenState();
}

class _AddSnapScreenState extends State<AddSnapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          'New 스냅코드 등록',
          style: TextStyle(
            color: secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // isLoading
          //   ? const LinearProgressIndicator()
          //   : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1649706796644-c507eb2835bb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
