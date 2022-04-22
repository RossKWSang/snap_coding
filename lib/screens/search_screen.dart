import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
<<<<<<< HEAD
  SearchPage({Key? key}) : super(key: key);
=======
  const SearchPage({Key? key}) : super(key: key);
>>>>>>> 568f8d46240fb56f2ea98bb544bc55107cfab35f

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Text('text'),
=======
    return Container(
      child: Text('Search Page'),
>>>>>>> 568f8d46240fb56f2ea98bb544bc55107cfab35f
    );
  }
}
