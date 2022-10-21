import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/models/user_model.dart';
import 'package:firebaseapp/view/screens/auth/login_screen.dart';
import 'package:firebaseapp/view/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;
GoogleSignIn googleSignIn=GoogleSignIn();

void login({required String email ,required String password})async{
try {await auth.signInWithEmailAndPassword(email: email, password: password);
 Get.offAll(ChatScreen());}
catch(e){
    Get.snackbar("login error", e.toString(),snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
}
}

void signout()async{
  await auth.signOut();
  await googleSignIn.signOut();
  Get.offAll(LoginScreen());
}

void register({required String email ,required String password,required String name})async{
  try{
  await auth.createUserWithEmailAndPassword(email: email, password: password).then((user)async{
    print(user);
    saveuser(user,name);
  });
  Get.offAll(ChatScreen());
  }
      catch(e){
        Get.snackbar("login error", e.toString(),snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);
      }
}
void googlesignin()async{
  final GoogleSignInAccount? googleuser = await googleSignIn.signIn();

  GoogleSignInAuthentication google = await googleuser!.authentication;

  var credintal=GoogleAuthProvider.credential(idToken:google.idToken ,accessToken: google.accessToken);
  await auth.signInWithCredential(credintal).then((value) {
    saveuser(value,"");
    Get.offAll(ChatScreen());
  });
}

void saveuser(UserCredential user,String name)async{
  UserModel userModel = UserModel(name: name==""?user.user!.displayName!:name, email: "", image: "", userId: user.user!.uid);
  await database.collection("users").doc(user.user!.uid).set(userModel.toJson());

}
}
