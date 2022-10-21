import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ControlProvider with ChangeNotifier {

FirebaseAuth still_login = FirebaseAuth.instance;
String? id;
ControlProvider(){
  getid();
}
void getid(){
  id=still_login.currentUser?.uid??null;
  notifyListeners();
}


}