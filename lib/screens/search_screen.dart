import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/models/user.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/utils/colors.dart';
import 'package:snap_coding_2/utils/utils.dart';
import 'package:snap_coding_2/widgets/text_field_input.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchKeyWord = TextEditingController();
  bool _isLoggedIn = false;

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
        clearSearchBar();
      }
      setState(() {});
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  // List<Widget> searchResult(String searchKeyWord) {}

  void clearSearchBar() {
    setState(() {
      _searchKeyWord.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context).getUser != null) {
      _isLoggedIn = true;
      final User user = Provider.of<UserProvider>(context).getUser;
      final String uid = user.uid;
      bool _searchOn = false;

      return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic> recentSearch = snapshot.data!['recentSearch'];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
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
                                recentSearch, _searchKeyWord.text);

                            updateUserSearch(uid, updatedList);
                            print('button clicked! ${recentSearch}');
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  !_searchOn
                      ? Container(
                          width: double.infinity,
                          height: 30,
                          child: ListView.builder(
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
                                    updateUserSearch(uid, recentSearch);
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          '검색 결과 나옴',
                        ),
                  // recentSearch.isEmpty
                  //     ? Text(
                  //         '최근 검색어가 없습니다.',
                  //       )
                  //     : Text(
                  //         'Loaded',
                  //       ),
                ],
              ),
            ),
          );
        },
      );
    }
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
