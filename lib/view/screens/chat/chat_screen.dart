import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/models/chat_model.dart';
import 'package:firebaseapp/provider/auth/auth_provider.dart';
import 'package:firebaseapp/provider/chat/chat_provider.dart';
import 'package:firebaseapp/view/screens/chat/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  var message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context,listen: false).getuser();
    var userprovider = Provider.of<ChatProvider>(context);
    var userfirebase = FirebaseAuth.instance.currentUser;
    return Scaffold(
        // color whats app
        backgroundColor:HexColor('#ECE5DD') ,
        appBar: AppBar(
          backgroundColor: Color(0xff075E54),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userprovider.userModel.image),
          ),
          title: Text(userprovider.userModel.name),
          actions: [
            PopupMenuButton(
              onSelected: (x){
                if(x==1){
                  Get.to(PhotoScreen());
                }
                else
                {
                 Provider.of<AuthProvider>(context,listen: false).signout();
                }
              },
                itemBuilder: (context) {

              return [
                PopupMenuItem(
              value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Provider.of<ChatProvider>(context).getmessage(),
                builder: (context, snapshot) {
                  List<ChatModel> chatlist = snapshot.data ?? [];

                  return ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isme = chatlist[index].userId==userfirebase!.uid;
                      return isme ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                      topLeft: Radius.circular(25)),

                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      chatlist[index].name,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      chatlist[index].message,
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    chatlist[index].avatarUrl),
                              ),
                            ),
                          ],
                        ),
                      ): Container(
                        child: Row(

                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    chatlist[index].avatarUrl),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        topRight: Radius.circular(25)),

                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatlist[index].name,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      chatlist[index].message,
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    },
                    itemCount: chatlist.length,
                  );
                }
              ),
            ),
            Padding(
              padding:  EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Type message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context,listen: false).sendmessage(ChatModel(
                            userId: userprovider.userModel.userId,
                            name: userprovider.userModel.name,
                            message: message.text,
                            time: DateTime.now().toString(),
                            avatarUrl: userprovider.userModel.image,
                        ));
                        message.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(Icons.send,),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
