import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/main_screen.dart';
import 'package:snap_coding_2/screens/add_snap.dart';

List<Widget> homeScreenItems = [
  MainPage(),
  Center(child: Text('search')),
  const AddSnapScreen(),
  Center(child: Text('alert')),
  Center(child: Text('meetup')),
];
