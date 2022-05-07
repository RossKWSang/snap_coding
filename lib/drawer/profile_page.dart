import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';

class ProfileUpdate extends StatefulWidget {
  ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _devexpController = TextEditingController();
  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _newPasswordConfirm = TextEditingController();

  bool _nicknameEnabled = false;
  bool _passwordConfirmed = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _devexpController.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _newPasswordConfirm.dispose();
    super.dispose();
  }

  void _inspectNickname() {
    setState(
      () {
        if (_devexpController.text != "" && _nicknameController.text != "") {
          _nicknameEnabled = true;
        } else {
          _nicknameEnabled = false;
        }
      },
    );
  }

  void _inspectPassword() {
    setState(
      () {
        if (_newPassword.text == _newPasswordConfirm.text) {
          _passwordConfirmed = true;
        } else {
          _passwordConfirmed = false;
        }
      },
    );
  }

  void updateUserInfos(
    String uid,
    String name,
    String devExp,
    // String profilePic
  ) async {
    try {
      String res = await FireStoreMethods().updateUserInfo(
        uid,
        name,
        devExp,
      );

      if (res == 'success') {
        showSnackBar(context, res);
        _nicknameController.clear();
        _devexpController.clear();
        _nicknameEnabled = false;
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('프로필 설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '이메일',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                userProvider.getUser.email,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '닉네임',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nicknameController,
                onChanged: (text) {
                  _inspectNickname();
                },
                style: TextStyle(
                  color: secondaryColor,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: userProvider.getUser.username,
                  focusColor: secondaryColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        _nicknameController.clear();
                        _nicknameEnabled = false;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '개발연차',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _devexpController,
                onChanged: (text) {
                  _inspectNickname();
                },
                style: TextStyle(
                  color: secondaryColor,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusColor: secondaryColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        _devexpController.clear();
                        _nicknameEnabled = false;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: _nicknameEnabled
                    ? ElevatedButton.styleFrom(
                        primary: primaryColor,
                      )
                    : ElevatedButton.styleFrom(
                        primary: Colors.grey[200],
                      ),
                onPressed: () {
                  if (_nicknameEnabled) {
                    updateUserInfos(
                      userProvider.getUser.uid,
                      _nicknameController.text,
                      _devexpController.text,
                    );
                  } else {}
                },
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '변경사항 저장',
                      style: TextStyle(
                        color:
                            _nicknameEnabled ? Colors.white : Colors.grey[900],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                '현재 비밀번호',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _currentPassword,
                obscureText: true,
                style: TextStyle(
                  color: secondaryColor,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusColor: secondaryColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      setState(
                        () {
                          _currentPassword.clear();
                        },
                      );
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '새 비밀번호',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _newPassword,
                obscureText: true,
                onChanged: (text) {
                  _inspectPassword();
                },
                style: TextStyle(
                  color: secondaryColor,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusColor: secondaryColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        _newPassword.clear();
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '새 비밀번호 확인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _newPasswordConfirm,
                obscureText: true,
                onChanged: (text) {
                  _inspectPassword();
                },
                style: TextStyle(
                  color: secondaryColor,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusColor: secondaryColor,
                  border: OutlineInputBorder(
                    borderSide: !_passwordConfirmed
                        ? BorderSide(
                            color: Color.fromARGB(255, 194, 51, 51),
                          )
                        : BorderSide(
                            color: mobileBackgroundColor,
                          ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: !_passwordConfirmed
                        ? BorderSide(
                            color: Color.fromARGB(255, 194, 51, 51),
                          )
                        : BorderSide(
                            color: mobileBackgroundColor,
                          ),
                    // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: !_passwordConfirmed
                        ? BorderSide(
                            color: Color.fromARGB(255, 194, 51, 51),
                          )
                        : BorderSide(
                            color: mobileBackgroundColor,
                          ), // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: secondaryColor,
                    ),
                    onTap: () {
                      setState(
                        () {
                          _newPasswordConfirm.clear();
                        },
                      );
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              !_passwordConfirmed
                  ? Text(
                      '새 비밀번호가 일치하지 않습니다.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 194, 51, 51),
                      ),
                    )
                  : SizedBox(height: 30),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: _passwordConfirmed
                    ? ElevatedButton.styleFrom(
                        primary: primaryColor,
                      )
                    : ElevatedButton.styleFrom(
                        primary: Colors.grey[200],
                      ),
                onPressed: () {
                  if (_passwordConfirmed) {
                  } else {}
                },
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '변경사항 저장',
                      style: TextStyle(
                        color: _passwordConfirmed
                            ? Colors.white
                            : Colors.grey[900],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
