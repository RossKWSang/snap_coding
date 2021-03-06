import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/providers/search_provider.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/widgets/snap_card.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchKeyWord = TextEditingController();
  bool _isLoggedIn = false;
  late IsSearchProvider _isSearchedProvider;
  final List _skillSets = [];
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

  List<dynamic> queueRecentSearchList(
      List<dynamic> currentQueue, String recentKeyword) {
    if (currentQueue.length < 10) {
      currentQueue.insert(0, recentKeyword);
    } else {
      currentQueue.insert(0, recentKeyword);
      currentQueue.removeLast();
    }
    return currentQueue;
  }

  @override
  void dispose() {
    _searchKeyWord.dispose();
    super.dispose();
  }

  void initializeUserSearch(
    String uid,
  ) async {
    try {
      String res = await AuthMethods().recentSearchInitialize(userId: uid);

      if (res != 'success') {
        showSnackBar(
          context,
          '최근검색어가 초기화되었습니다.',
        );
      }
      setState(() {});
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void updateUserSearch(String uid, List<dynamic> updatedUserSearch) async {
    try {
      String res = await AuthMethods().recentSearchUpdate(
        userId: uid,
        searchKeyWord: updatedUserSearch,
      );

      if (res != 'success') {
        //clearSearchBar();
      }
      setState(() {});
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  // AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> searchSnapshot(
  //   String searchKeyword,
  // ) async {}

  // List<Widget> searchResult(String searchKeyWord) {}

  void clearSearchBar() {
    setState(() {
      _searchKeyWord.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // String uid = 'null_uid';
    // User? user = null;
    // if (Provider.of<UserProvider>(context).getUser != null) {
    //   final User user = Provider.of<UserProvider>(context).getUser;
    //   String uid = user.uid;

    //   _isSearchedProvider = Provider.of<IsSearchProvider>(context);
    //   final UserProvider? userProvider = Provider.of<UserProvider>(context);
    // final String uid = userProvider!.getUser.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final fireAuth.FirebaseAuth _auth = fireAuth.FirebaseAuth.instance;
    fireAuth.User currentUser = _auth.currentUser!;
    if (currentUser.uid != null) {
      _isLoggedIn = true;
    }
    String uid = 'demo';
    // String uid = currentUser.uid;
    // DocumentSnapshot documentSnapshot =
    //     await _firestore.collection('users').doc(currentUser.uid).get();

    // User userData = User.fromSnap(documentSnapshot);

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<dynamic> recentSearch = snapshot.data!['recentSearch'];
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 5,
              ),
              child: Column(
                children: [
                  Container(
                    height: 35,
                    child: TextField(
                      controller: _searchKeyWord,
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        focusColor: secondaryColor,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          // borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          // borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.search,
                            color: secondaryColor,
                          ),
                          onTap: () {
                            List<dynamic> updatedList = queueRecentSearchList(
                              recentSearch,
                              _searchKeyWord.text,
                            );

                            updateUserSearch(uid, updatedList);
                            print('button clicked! ${recentSearch}');
                            _isSearchedProvider.searched();
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  !_isSearchedProvider.isSearched
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '최근 검색어',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    initializeUserSearch(
                                      uid,
                                    );
                                  },
                                  child: Text(
                                    '전체삭제',
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              height: 30,
                              child: recentSearch.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: false,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recentSearch.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          height: 30,
                                          child: InputChip(
                                            padding: EdgeInsets.all(1.0),
                                            label: Text(
                                              recentSearch[index],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onDeleted: () {
                                              recentSearch.removeAt(index);
                                              updateUserSearch(
                                                  uid, recentSearch);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      height: 30,
                                      child: Text(
                                        '최근 검색 키워드가 없습니다.',
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(
                                  '현재 사람들이 많이 찾는 검색어',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              width: double.infinity,
                              height: 30,
                              child: Text(
                                '최근 검색 키워드가 없습니다.',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(
                                  '검색 언어 선택',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
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
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AlertDialog(
                                                    title: Text("경고"),
                                                    content:
                                                        Text("5개를 초과할 수 없습니다."),
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
                                            color: isSelected
                                                ? primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: isSelected
                                                    ? primaryColor
                                                    : Colors.grey,
                                                width: 2)),
                                        child: Text(
                                          chipskills,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .where(
                                'HashTag',
                                arrayContains: _searchKeyWord.text,
                              )
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              width: double.infinity,
                              child: snapshot.data!.docs.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        List<
                                                QueryDocumentSnapshot<
                                                    Map<String, dynamic>>>
                                            filteredSnap = snapshot.data!.docs;
                                        List<dynamic> filteredLanguageList =
                                            filteredSnap[index]
                                                .data()['devLanguage'];
                                        filteredLanguageList.remove('All');
                                        // print(filteredLanguageList);
                                        return Text('null');
                                        // SnapCardMain(
                                        //   snapId: filteredSnap[index]
                                        //       .data()['snapId'],
                                        //   thumbnailUrl: filteredSnap[index]
                                        //       .data()['thumbnailUrl'],
                                        //   title: filteredSnap[index]
                                        //       .data()['title'],
                                        //   hashTagList: filteredSnap[index]
                                        //       .data()['HashTag'],
                                        //   filteredLanguageList:
                                        //       filteredLanguageList,
                                        // );
                                      },
                                    )
                                  : Builder(
                                      builder: (context) {
                                        String _failedSearchKeyWord =
                                            _searchKeyWord.text;
                                        // _searchKeyWord.;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text:
                                                      "\'${_failedSearchKeyWord}\'",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: primaryColor,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '에 대한\n검색결과가 없습니다',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 25,
                                                        color: secondaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '·  단어의 철자가 정확한지 확인해 보세요.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '·  한글을 영어로 혹은 영어를 한글로 입력했는지\n   확인해 보세요.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '·  검색어의 단어 수를 줄이거나,\n   보다 일반적인 검색어로 다시 검색해 보세요.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '·  띄어쓰기를 확인해 보세요.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  '·  검색 옵션을 변경해서 다시 검색해 보세요.',
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 17,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            );
                          },
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
    // }
    return Text('Please Log In');
  }
}

//     SafeArea(
//   child: Column(
//     children: [
//       Container(
//         height: 35,
//         child: TextFieldSearch(
//           textEditingController: _searchKeyWord,
//           textInputType: TextInputType.text,
//         ),
//       ),

//       Text('${user.uid}'),
//     ],
//   ),
// );

//     return SafeArea(
//       child: Column(
//         children: [
//           Container(
//             height: 35,
//             child: TextFieldSearch(
//               textEditingController: _searchKeyWord,
//               textInputType: TextInputType.text,
//             ),
//           ),
//           Text('로그인하세요'),
//         ],
//       ),
//     );
//   }
// }

