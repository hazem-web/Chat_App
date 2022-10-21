import 'package:firebaseapp/provider/control_provider.dart';
import 'package:firebaseapp/view/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/auth/login_screen.dart';

class ControlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ControlProvider>(builder: (context, value, child) {
      return value.id==null ? LoginScreen():ChatScreen();
    },);
  }
}
