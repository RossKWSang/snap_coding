import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';

class AddSnapScreen extends StatefulWidget {
  const AddSnapScreen({Key? key}) : super(key: key);

  @override
  State<AddSnapScreen> createState() => _AddSnapScreenState();
}

class _AddSnapScreenState extends State<AddSnapScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? _file;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: InkWell(
          child: CircleAvatar(
            radius: 5,
            backgroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/snapcoding-2.appspot.com/o/profilePics%2F8gWv58goIdb6AMux6y3lsLWEgRl2?alt=media&token=7962f19f-58d0-417a-87d4-ed9a2e5aaf1d'),
          ),
          onTap: () {},
        ),
        title: Text(
          'New 스냅코드 등록',
          style: TextStyle(
            color: secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("타이틀: "),
                ),
                Container(
                  width: 300,
                  child: TextFieldInput(
                    hintText: '타이틀을 입력하세요.',
                    textInputType: TextInputType.text,
                    textEditingController: _titleController,
                    isPass: true,
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
