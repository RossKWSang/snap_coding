import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';

import 'package:snap_coding_2/screens/login_screen.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';
import 'package:snap_coding_2/layouts/mobile_screen_layout.dart';

enum MembershipCate { individual, enterprise }

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  double _developerExperience = 0.0;
  MembershipCate _membershipCate = MembershipCate.individual;
  bool _isLoading = false;
  Uint8List? _image;
  final List _skillSets = [];
  String dropdownValue = '언어를 선택하세요';
  List chipSkillSets = [
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
    'rust'
  ];

  // final _skillSets = [];
  // String dropdownValue = '언어를 선택하세요';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        usercate: _membershipCate == MembershipCate.individual
            ? 'individual'
            : 'enterprise',
        devExp: _developerExperience * 30,
        skillSets: _skillSets,
        file: _image!);
    // if string returned is success, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MobileScreenLayout(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'SnapCoding.png',
                ),
                Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://i.stack.imgur.com/l60Hf.png'),
                              backgroundColor: Colors.red,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: '계정 이름을 입력하세요.',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldInput(
                  hintText: '이메일을 입력하세요.',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldInput(
                  hintText: '비밀번호를 입력하세요.',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '개인/기업 회원',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '개인',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Radio(
                        value: MembershipCate.individual,
                        groupValue: _membershipCate,
                        onChanged: (value) {
                          setState(
                            () {
                              _membershipCate = MembershipCate.individual;
                              print(_membershipCate);
                            },
                          );
                        },
                        activeColor: primaryColor,
                      ),
                      Spacer(),
                      Text(
                        '기업',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Radio(
                        value: MembershipCate.enterprise,
                        groupValue: _membershipCate,
                        onChanged: (value) {
                          setState(
                            () {
                              _membershipCate = MembershipCate.enterprise;
                              print(_membershipCate);
                            },
                          );
                        },
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                ),
                Text(
                  '개발 경력',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('0'),
                    Container(
                      width: 300,
                      child: Slider(
                        value: _developerExperience,
                        onChanged: (newRating) {
                          setState(
                            () => _developerExperience = newRating,
                          );
                        },
                        divisions: 30,
                        label: "${(_developerExperience * 30).round()} 년차",
                        activeColor: primaryColor,
                      ),
                    ),
                    Text('30'),
                  ],
                ),
                Text(
                  '사용 언어/프레임워크',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Wrap(
                  children: chipSkillSets.map(
                    (chipskills) {
                      bool isSelected = false;
                      if (_skillSets.contains(chipskills)) {
                        isSelected = true;
                      }
                      return GestureDetector(
                        onTap: () {
                          if (_skillSets.contains(chipskills)) {
                            _skillSets.removeWhere(
                                (element) => element == chipskills);
                            setState(() {});
                          } else {
                            if (_skillSets.length < 5) {
                              _skillSets.add(chipskills);
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
                            )),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  child: Container(
                    child: !_isLoading
                        ? const Text(
                            'Sign up',
                          )
                        : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: secondaryColor,
                    ),
                  ),
                  onTap: signUpUser,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Already have an account?',
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        child: const Text(
                          ' Login.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
