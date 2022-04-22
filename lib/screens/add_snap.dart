import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class AddSnapScreen extends StatefulWidget {
  const AddSnapScreen({Key? key}) : super(key: key);

  @override
  State<AddSnapScreen> createState() => _AddSnapScreenState();
}

class _AddSnapScreenState extends State<AddSnapScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  Uint8List? _file;
  bool isLoading = false;

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

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        extractHashTags(_hashtagController.text),
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
        clearText();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(
      () {
        _file = null;
      },
    );
  }

  void clearText() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _hashtagController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

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
        actions: <Widget>[
          TextButton(
            onPressed: () => postImage(
              userProvider.getUser.uid,
              userProvider.getUser.username,
              userProvider.getUser.photoUrl,
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("타이틀: "),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFieldInput(
                    hintText: '타이틀을 입력하세요.',
                    textInputType: TextInputType.text,
                    textEditingController: _titleController,
                    isPass: false,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("설명: "),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: HashTagTextField(
                    basicStyle: TextStyle(fontSize: 15, color: Colors.white),
                    decoratedStyle: TextStyle(fontSize: 15, color: Colors.blue),
                    keyboardType: TextInputType.multiline,

                    /// Called when detection (word starts with #, or # and @) is being typed
                    onDetectionTyped: (text) {
                      print(_hashtagController.text);
                    },

                    /// Called when detection is fully typed
                    onDetectionFinished: () {
                      print("detection finished");
                    },
                    maxLines: 10,
                    controller: _hashtagController,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("썸네일: "),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: secondaryColor,
                            // style: BorderStyle.,
                            width: 1,
                          ),
                        ),
                        child: _file != null
                            ? Image.memory(_file!)
                            : Image.asset('assets/images/banner4.jpg'),
                      ),
                      IconButton(
                        onPressed: () => _selectImage(context),
                        icon: const Icon(Icons.add_a_photo),
                      )
                    ],
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
