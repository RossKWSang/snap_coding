import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:code_editor/code_editor.dart';
import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/language_template.dart';
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
  final TextEditingController _snapTitleController = TextEditingController();
  // final TextEditingController _snapLanguageController = TextEditingController();

  String uploadedSnapId = '';
  Uint8List? _file;
  bool isLoading = false;
  bool _isLoggedIn = false;
  List<String> _devLanguage = [
    'All',
  ];
  List<String> _dropDownOption = [
    '언어',
  ];
  String _selectedDropDownOption = '언어';
  Map<String, dynamic> codeSnippet = {};
  List<String> bookMark = [];
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

  void postImage(
    String uid,
    String username,
    // String profImage\
  ) async {
    setState(
      () {
        isLoading = true;
      },
    );
    // start the loading
    try {
      // upload to storage and db
      List<dynamic> res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        extractHashTags(_descriptionController.text),
        _devLanguage,
        _file!,
        uid,
        username,
        // profImage,
        bookMark,
        codeSnippet,
      );
      if (res[0] == 0) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
        clearText();
        final List<String> _devLanguage = [
          'All',
        ];
        final List<String> _dropDownOption = [
          '언어',
        ];
        _snapTitleController.clear();
        _selectedDropDownOption = '언어';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => _isLoggedIn
                ? SnapSpecific(
                    snapId: res[1],
                    uid: uid,
                    username: username,
                  )
                : SnapSpecific(
                    snapId: res[1],
                    uid: "notloggedin",
                    username: "notloggedin",
                  ),
          ),
        );
      } else {
        showSnackBar(context, res[0]);
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

  void addCodeSnippet() {
    setState(
      () {
        if (_selectedDropDownOption == '언어') {
          showSnackBar(
            context,
            '언어를 선택하세요!!',
          );
          return;
        }
        codeSnippet[_snapTitleController.text] = [
          _selectedDropDownOption,
          languageTemplate[_selectedDropDownOption].join("\n"),
        ];
        _snapTitleController.clear();
        _selectedDropDownOption = '언어';
      },
    );
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
      _devLanguage = [
        'All',
      ];
      _dropDownOption = [
        '언어',
      ];
      codeSnippet = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      fireAuth.User currentUser = _auth.currentUser!;
      _isLoggedIn = true;
      print(
        currentUser.uid.toString(),
      );
    } else {}
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    EditorModel modelMaker(widName, widLanguage, codeInput) {
      List<FileEditor> file_formed = [
        FileEditor(
          name: widName,
          language: widLanguage,
          code: codeInput,
        )
      ];
      return new EditorModel(
        files: file_formed,
        styleOptions: EditorModelStyleOptions(
          theme: {
            'root': TextStyle(
              backgroundColor: mobileDrawerColor,
              color: Color(0xffdddddd),
            ),
            'keyword': TextStyle(color: keywordColor),
            'params': TextStyle(color: Color(0xffde935f)),
            'selector-tag': TextStyle(color: attrColor),
            'selector-id': TextStyle(color: idColor),
            'selector-class': TextStyle(color: classColor),
            'regexp': TextStyle(color: Color(0xffcc6666)),
            'literal': TextStyle(color: Colors.white),
            'section': TextStyle(color: Colors.white),
            'link': TextStyle(color: Colors.white),
            'subst': TextStyle(color: Color(0xffdddddd)),
            'string': TextStyle(color: quoteColor),
            'title': TextStyle(color: titlesColor),
            'name': TextStyle(color: tagColor),
            'type': TextStyle(color: tagColor),
            'attribute': TextStyle(color: propertyColor),
            'symbol': TextStyle(color: tagColor),
            'bullet': TextStyle(color: tagColor),
            'built_in': TextStyle(color: methodsColor),
            'addition': TextStyle(color: tagColor),
            'variable': TextStyle(color: tagColor),
            'template-tag': TextStyle(color: tagColor),
            'template-variable': TextStyle(color: tagColor),
            'comment': TextStyle(color: Color(0xff777777)),
            'quote': TextStyle(color: Color(0xff777777)),
            'deletion': TextStyle(color: Color(0xff777777)),
            'meta': TextStyle(color: Color(0xff777777)),
            'emphasis': TextStyle(fontStyle: FontStyle.italic),
          },
          padding: EdgeInsets.all(
            3,
          ),
          tabSize: 4,
          fontSize: 13,
          editorColor: mobileDrawerColor,
          // editorBorderColor: mobileBackgroundColor,
        ),
      );
    }

    print(codeSnippet);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '    스냅 등록',
          style: TextStyle(
            color: secondaryColor,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          _isLoggedIn
              ? TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    // userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "등록하기",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                  ),
                  child: const Text(
                    "로그인",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _selectImage(context),
                            icon: const Icon(Icons.add_a_photo),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    _file != null
                        ? Container(
                            height: 120,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                _file!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: TextFieldInput(
                  hintText: '제목을 입력하세요.',
                  textInputType: TextInputType.text,
                  textEditingController: _titleController,
                  isPass: false,
                  cursorColor: primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: HashTagTextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '#해시태그_등록',
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: Divider.createBorderSide(context),
                    ),
                  ),
                  cursorColor: primaryColor,
                  basicStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  decoratedStyle: TextStyle(
                    fontSize: 15,
                    color: primaryColor,
                  ),
                  keyboardType: TextInputType.multiline,

                  /// Called when detection (word starts with #, or # and @) is being typed
                  onDetectionTyped: (text) {
                    print(_descriptionController.text);
                  },

                  /// Called when detection is fully typed
                  onDetectionFinished: () {
                    print("detection finished");
                  },
                  minLines: 10,
                  maxLines: 10,
                  controller: _descriptionController,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                  "개발 언어 선택",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
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
                            _dropDownOption.removeWhere(
                                (element) => element == chipskills);
                            setState(() {});
                          } else {
                            if (_devLanguage.length < 6) {
                              _devLanguage.add(chipskills);
                              _dropDownOption.add(chipskills);
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
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? primaryColor : Colors.grey[900],
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color:
                                      isSelected ? primaryColor : Colors.grey,
                                  width: 2),
                            ),
                            child: Text(
                              chipskills,
                              style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.white,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                  "코드 스니펫 등록",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      addCodeSnippet();
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: TextFieldInput(
                      hintText: '코드스니펫 이름',
                      textInputType: TextInputType.text,
                      textEditingController: _snapTitleController,
                      isPass: false,
                      cursorColor: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: mobileDrawerColor,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: DropdownButton(
                      value: _selectedDropDownOption,
                      items: _dropDownOption.map(
                        (value) {
                          print(_selectedDropDownOption);
                          return DropdownMenuItem(
                            value: value,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: 73,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryColor,
                                  background: Paint()
                                    ..color = Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (String? value) {
                        setState(
                          () {
                            _selectedDropDownOption = value!;
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: codeSnippet.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Stack(
                          children: [
                            CodeEditor(
                              model: modelMaker(
                                codeSnippet.keys.elementAt(index),
                                codeSnippet[codeSnippet.keys.elementAt(index)]
                                    [0],
                                codeSnippet[codeSnippet.keys.elementAt(index)]
                                    [1],
                              ),
                              onSubmit: (String? language, String? value) {
                                codeSnippet[codeSnippet.keys.elementAt(index)]
                                    [1] = value!;
                              },
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      codeSnippet.remove(
                                        codeSnippet.keys.elementAt(index),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  );
                },
              )
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.95,
              //   child: CodeEditor(
              //     model: model,
              //     onSubmit: (String? language, String? value) {
              //       codeSnippet[language!] = value!;
              //       // print("language = $language");
              //       // print("value = '$value'");
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
