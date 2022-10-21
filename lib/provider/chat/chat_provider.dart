import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/models/chat_model.dart';
import 'package:firebaseapp/models/user_model.dart';
import 'package:flutter/material.dart';


class ChatProvider extends ChangeNotifier {
FirebaseFirestore message = FirebaseFirestore.instance;
FirebaseAuth userid = FirebaseAuth.instance;


Stream<List<ChatModel>> getmessage(){
  return message
      .collection('message').orderBy('time',descending: true).
      snapshots().
  map((event){
    return List<ChatModel>.from(event.docs.map((e)=>ChatModel.fromJson(e.data())));}
  );
}

sendmessage(ChatModel chatModel)async{
  await message.collection("message").add(chatModel.toJson());
}
UserModel userModel = UserModel(name: "", email: "", image: "", userId: "");
getuser()async{
  await message.collection('users').doc(userid.currentUser!.uid).get().then((value) {
   userModel= UserModel.fromJson(value.data()!);
  });
}

}


