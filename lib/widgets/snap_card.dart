import 'package:flutter/material.dart';
import 'package:snap_coding_2/resources/firestore_methods.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';

class SnapCardMain extends StatefulWidget {
  final String uid;
  final String snapId;
  final String thumbnailUrl;
  final String title;
  final List<dynamic> hashTagList;
  final List<dynamic> filteredLanguageList;
  final List bookmarkList;
  final bool? bookmarkact;
  const SnapCardMain({
    Key? key,
    required this.uid,
    required this.snapId,
    required this.thumbnailUrl,
    required this.title,
    required this.hashTagList,
    required this.filteredLanguageList,
    required this.bookmarkList,
    this.bookmarkact,
  }) : super(key: key);

  @override
  State<SnapCardMain> createState() => _SnapCardMainState();
}

class _SnapCardMainState extends State<SnapCardMain> {
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
                  snapId: widget.snapId,
                  uid: 'this widget no longer used',
                  username: 'this widget no longer used',
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 140,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 105,
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
                            widget.thumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    widget.bookmarkact!
                        ? Container()
                        // Positioned(
                        //     child: IconButton(
                        //       icon: widget.bookmarkList.contains(widget.snapId)
                        //           ? Icon(
                        //               Icons.bookmark,
                        //               color: primaryColor,
                        //             )
                        //           : Icon(
                        //               Icons.bookmark_border_outlined,
                        //               color: primaryColor,
                        //             ),
                        //       onPressed: () async {
                        //         //isMarked = !isMarked;
                        //         await FireStoreMethods().bookmarkPost(
                        //           widget.snapId,
                        //           widget.uid,
                        //           widget.bookmarkList,
                        //         );

                        //         await FireStoreMethods().bookmarkforUser(
                        //           widget.snapId,
                        //           widget.uid,
                        //           widget.bookmarkList,
                        //         );
                        //         setState(() {});
                        //       },
                        //     ),
                        //     bottom: 0,
                        //     right: 0,
                        //   )
                        : Container(),
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
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 50,
                      width: 220,
                      child: Wrap(
                        alignment: WrapAlignment.start, // ?????? ??????

                        children: widget.hashTagList.map<Widget>(
                          (hashTag) {
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
                          },
                        ).toList(),
                      ),
                    ),
                    Container(
                      width: 220,
                      height: 20,
                      child: Wrap(
                        // spacing: 5, // ??????(??????) ??????
                        // runSpacing: 2,
                        alignment: WrapAlignment.start,
                        children: widget.filteredLanguageList.map<Widget>(
                          (devLang) {
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
                          },
                        ).toList(),
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
