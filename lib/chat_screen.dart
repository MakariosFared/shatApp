import 'package:chat_app_course/widgets/chat_msg_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Model/Message_Model.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  TextEditingController msgController = TextEditingController();
  static const routeName = "chat_screen";


  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.photoURL
    );
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(
              "LogOut",
              style: TextStyle(color: Colors.white),
            ))
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection("chat")
      //         .snapshots()
      //         .listen((event) {
      //       event.docs.forEach((element) {
      //         var data = element.data();
      //         print(data["msgBody"]);
      //       });
      //     });
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chat").orderBy("timestamp").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                List<MessageModel> data = [];
                snapshot.data?.docs.forEach((element) {
                  data.add(MessageModel.fromFSDB(element.data()));
                });

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatMsgItem(msg: data[index]);
                  },
                );
              },
            ),
          ),
          buildChatTextField(msgController),
        ],
      ),
    );
  }
}

Widget buildChatTextField(TextEditingController msgController) {
  return Container(
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {}
      },
      controller: msgController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              MessageModel message = MessageModel(body: msgController.text,
                  senderId: userId,
                  reciverId: "nR8HutzTl4ZwYsjX5aWsx5m7uhl2",
                  timestamp: Timestamp.now());
              await
              FirebaseFirestore.instance
                  .collection("chat")
                  .add(message.toFSDB()).then((value) {
                msgController.clear();
              });
            },
            icon: Icon(Icons.send),
            splashRadius: 20,
            iconSize: 20),
        border: OutlineInputBorder(),
      ),
    ),
  );
}
