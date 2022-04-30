import 'package:flutter/widgets.dart';
import 'package:snap_coding_2/resources/auth_methods.dart';

class IsSearchProvider with ChangeNotifier {
  bool _isSearched = false;
  bool get isSearched => _isSearched;

  void searched() {
    _isSearched = true;
    notifyListeners();
  }

  void unSearched() {
    _isSearched = false;
    notifyListeners();
  }
}
