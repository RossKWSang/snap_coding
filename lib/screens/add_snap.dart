import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:code_editor/code_editor.dart';
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
  final List<String> _devLanguage = [
    'All',
  ];
  Map<String, String> codeSnippet = {};
  final String dropdownValue = '언어를 선택하세요';
  final List chipSkillSets = [
    'C',
    'C++',
    'C#',
    'Java',
    'Python',
    'Ruby',
    'PHP',
    'Javascript',
    'dart',
    'go',
    'rust',
    'html',
    'css',
    'bash',
    'typescript',
    'R',
  ];

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
        extractHashTags(_descriptionController.text),
        _devLanguage,
        _file!,
        uid,
        username,
        profImage,
        codeSnippet,
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
    List<String> contentOfPage1 = [
      "#include <stdio.h>",
      "",
      "int main(void){",
      "\tprintf(\"Hello world\");",
      "\treturn 0;",
      "}",
    ];

    List<String> contentOfPage2 = [
      "public class HelloWorld {",
      "\tpublic class void main(String[] args) {",
      "\t\tSystem.out.println(\"Hello, world!\");",
      "\t}",
      "}",
    ];

    List<FileEditor> files = [
      new FileEditor(
        name: "C",
        language: "C",
        code: contentOfPage1.join("\n"),
      ),
      new FileEditor(
        name: "C++",
        language: "C++",
        code: contentOfPage1.join("\n"),
      ),
      new FileEditor(
        name: "C#",
        language: "C#",
        code: contentOfPage1.join("\n"),
      ),
      new FileEditor(
        name: "Java",
        language: "java",
        code: contentOfPage2.join("\n"),
      ),
      new FileEditor(
        name: "Python",
        language: "python",
        code: "print(\"Hello world!\")",
      ),
      new FileEditor(
        name: "css",
        language: "css",
        code: "a { color: red; }",
      ),
    ];

    EditorModel model = new EditorModel(
      files: files,
      styleOptions: new EditorModelStyleOptions(
        fontSize: 13,
        editorColor: mobileBackgroundColor,
        editorBorderColor: mobileBackgroundColor,
        // theme: TextTheme(),
      ),
    );

    // since 1.3.1
    model.styleOptions?.defineEditButtonPosition(top: 250.0, right: 10.0);

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
                  width: MediaQuery.of(context).size.width * 0.75,
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: HashTagTextField(
                    basicStyle: TextStyle(fontSize: 15, color: Colors.white),
                    decoratedStyle: TextStyle(fontSize: 15, color: Colors.blue),
                    keyboardType: TextInputType.multiline,

                    /// Called when detection (word starts with #, or # and @) is being typed
                    onDetectionTyped: (text) {
                      print(_descriptionController.text);
                    },

                    /// Called when detection is fully typed
                    onDetectionFinished: () {
                      print("detection finished");
                    },
                    maxLines: 10,
                    controller: _descriptionController,
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
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
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("언어: "),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Wrap(
                    children: chipSkillSets.map(
                      (chipskills) {
                        bool isSelected = false;
                        if (_devLanguage.contains(chipskills)) {
                          isSelected = true;
                        }
                        return GestureDetector(
                          onTap: () {
                            if (_devLanguage.contains(chipskills)) {
                              _devLanguage.removeWhere(
                                  (element) => element == chipskills);
                              setState(() {});
                            } else {
                              if (_devLanguage.length < 6) {
                                _devLanguage.add(chipskills);
                                setState(() {});
                              } else {
                                setState(
                                  (() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: Text("경고"),
                                          content: Text("5개를 초과할 수 없습니다."),
                                          actions: <Widget>[],
                                        );
                                      },
                                    );
                                  }),
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              decoration: BoxDecoration(
                                  color:
                                      isSelected ? primaryColor : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey,
                                      width: 2)),
                              child: Text(
                                chipskills,
                                style: TextStyle(
                                    color:
                                        isSelected ? Colors.white : Colors.grey,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("코드입력: "),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CodeEditor(
                    model: model,
                    onSubmit: (String? language, String? value) {
                      codeSnippet[language!] = value!;
                      // print("language = $language");
                      // print("value = '$value'");
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
