import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_coding_2/providers/user_provider.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';

class MySnapPage extends StatefulWidget {
  MySnapPage({Key? key}) : super(key: key);

  @override
  State<MySnapPage> createState() => _MySnapPageState();
}

class _MySnapPageState extends State<MySnapPage> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    // if (userProvider().getUser != null) {

    // }
    List<dynamic> postSnapId = userProvider.getUser.postSnapId;
    print(postSnapId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          '내가 등록한 스냅',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy(
              'created',
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            filteredSnap = snapshot.data!.docs;
                        List<dynamic> filteredLanguageList =
                            filteredSnap[index].data()['devLanguage'];
                        filteredLanguageList.remove('All');
                        bool _ismine = false;

                        if (postSnapId
                            .contains(filteredSnap[index].data()['snapId'])) {
                          _ismine = true;
                        }

                        // print(filteredLanguageList);
                        return _ismine
                            ? Column(
                                children: [
                                  Row(),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SnapSpecific(
                                            snapId: filteredSnap[index]
                                                .data()['snapId'],
                                            uid: 'notloggedin',
                                            username: 'notloggedin',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      height: 140,
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 120,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: SizedBox.fromSize(
                                                    child: Image.network(
                                                      filteredSnap[index]
                                                              .data()[
                                                          'thumbnailUrl'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                child: IconButton(
                                                  icon: filteredSnap[index]
                                                          .data()['bookMark']
                                                          .contains(
                                                            userProvider
                                                                .getUser.uid,
                                                          )
                                                      ? Icon(
                                                          Icons.bookmark,
                                                          color: primaryColor,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .bookmark_border_outlined,
                                                          color: primaryColor,
                                                        ),
                                                  onPressed: () async {
                                                    //isMarked = !isMarked;

                                                    await FireStoreMethods()
                                                        .bookmarkPost(
                                                      filteredSnap[index]
                                                          .data()['snapId'],
                                                      userProvider.getUser.uid,
                                                      filteredSnap[index]
                                                          .data()['bookMark'],
                                                    );

                                                    await FireStoreMethods()
                                                        .bookmarkforUser(
                                                      filteredSnap[index]
                                                          .data()['snapId'],
                                                      userProvider.getUser.uid,
                                                      userProvider
                                                          .getUser.bookMark,
                                                    );
                                                    //  setState(() {});
                                                  },
                                                ),
                                                bottom: 0,
                                                right: 0,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                filteredSnap[index]
                                                    .data()['title'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Container(
                                                height: 50,
                                                width: 260,
                                                child: Wrap(
                                                  alignment: WrapAlignment
                                                      .start, // 정렬 방식

                                                  children: filteredSnap[index]
                                                      .data()['HashTag']
                                                      .map<Widget>((hashTag) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Text(
                                                        hashTag,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Container(
                                                height: 15,
                                                child: Wrap(
                                                  // spacing: 5, // 상하(좌우) 공간
                                                  // runSpacing: 2,
                                                  alignment: WrapAlignment
                                                      .start, // 정렬 방식

                                                  children: filteredLanguageList
                                                      .map<Widget>((devLang) {
                                                    return Transform(
                                                      transform:
                                                          new Matrix4.identity()
                                                            ..scale(1.0),
                                                      child: Chip(
                                                        padding:
                                                            EdgeInsets.all(0.5),
                                                        backgroundColor: Colors
                                                            .green.shade900
                                                            .withOpacity(0.3),
                                                        label: Text(
                                                          devLang,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
