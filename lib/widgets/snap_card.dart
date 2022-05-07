import 'package:flutter/material.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';

class SnapCardMain extends StatelessWidget {
  final String uid;
  final String snapId;
  final String thumbnailUrl;
  final String title;
  final List<dynamic> hashTagList;
  final List<dynamic> filteredLanguageList;
  final List<String> bookmarkList;
  const SnapCardMain({
    Key? key,
    required this.uid,
    required this.snapId,
    required this.thumbnailUrl,
    required this.title,
    required this.hashTagList,
    required this.filteredLanguageList,
    required this.bookmarkList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SnapSpecific(
                  snapId: snapId,
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 140,
            child: Row(
              children: [
                Stack(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox.fromSize(
                          child: Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(
                          Icons.bookmark_border_outlined,
                          // color: markedPost.contains(
                          //         snapshot
                          //             .data?.docs[index]
                          //             .data()['snapId'])
                          //     ? Colors.white
                          //     : Colors.black,
                        ),
                        onPressed: () async {
                          //isMarked = !isMarked;
                          await FireStoreMethods().bookmarkPost(
                            snapId,
                            uid,
                            bookmarkList,
                          );

                          await FireStoreMethods().bookmarkforUser(
                            snapId,
                            uid,
                            bookmarkList,
                          );
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 50,
                      width: 260,
                      child: Wrap(
                        alignment: WrapAlignment.start, // 정렬 방식

                        children: hashTagList.map<Widget>((hashTag) {
                          return Container(
                            padding: EdgeInsets.all(2),
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
                        alignment: WrapAlignment.start, // 정렬 방식

                        children: filteredLanguageList.map<Widget>((devLang) {
                          return Transform(
                            transform: new Matrix4.identity()..scale(1.0),
                            child: Chip(
                              padding: EdgeInsets.all(0.5),
                              backgroundColor:
                                  Colors.green.shade900.withOpacity(0.3),
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
    );
  }
}
