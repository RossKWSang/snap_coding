import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/snap_specific.dart';
import 'package:snap_coding_2/utils/colors.dart';

class commentCard extends StatelessWidget {
  final String snapId;
  final String username;
  final String comment;
  final Timestamp datePublished;
  final bool isReported;
  const commentCard({
    Key? key,
    required this.snapId,
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.isReported,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = datePublished.toDate();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          width: MediaQuery.of(context).size.width * 0.95,
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('yy/MM/dd').format(dateTime),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                comment,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
