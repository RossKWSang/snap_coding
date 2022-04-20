import 'package:flutter/material.dart';
import 'package:snap_coding_2/screens/main_screen.dart';
import 'package:snap_coding_2/screens/add_snap.dart';

import '../screens/search_screen.dart';

List<Widget> homeScreenItems = [
  MainPage(),
  SearchPage(),
  const AddSnapScreen(),
  Center(child: Text('alert')),
  Center(child: Text('meetup')),
];
