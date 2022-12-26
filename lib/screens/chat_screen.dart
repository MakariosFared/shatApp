import 'package:chat_app_course/Model/user_model.dart';
import 'package:chat_app_course/auth/auth_provider.dart';
import 'package:chat_app_course/const/const.dart';
import 'package:chat_app_course/widgets/chat_msg_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/Message_Model.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  TextEditingController msgController = TextEditingController();
  static const routeName = "chat_screen";

  @override
  Widget build(BuildContext context) {

    print(FirebaseAuth.instance.currentUser?.photoURL);
    UserModel reciver = ModalRoute.of(context)?.settings.arguments as UserModel;
    String chatID;
    String? userId = usermodel?.id;
    if (userId.hashCode <= reciver.id.hashCode) {
      chatID = '$userId-${reciver.id}';
    } else {
      chatID = '${reciver.id}-$userId';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(reciver.username!),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chat")
                  .doc(chatID)
                  .collection("conv")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                List<MessageModel> data = [];
                snapshot.data?.docs.forEach((element) {
                  data.add(MessageModel.fromFSDB(element.data()));
                });

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatMsgItem(
                      msg: data[index],
                      reciver: reciver,
                    );
                  },
                );
              },
            ),
          ),
          buildChatTextField(msgController, reciver, chatID , context),
        ],
      ),
    );
  }
}

Widget buildChatTextField(
    TextEditingController msgController, UserModel reciver, chatID ,context) {
  String imageurl ;
  return Container(
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {}
      },
      controller: msgController,
      decoration: InputDecoration(
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () async {
             AuthProvider provider = Provider.of<AuthProvider>(context,listen: false);
             provider.choosenFile = null ;
             provider.pickImage();
             imageurl = await provider.uploadProfileImage(chatID);


            }, icon: Icon(Icons.image)),
            IconButton(
                onPressed: () async {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  Dio dio = Dio();
                  String url = "https://fcm.googleapis.com/fcm/send";
                  String key =
                      "key=AAAAIgic2bo:APA91bEDEUsaPptt9Vu_r78PinO5eNfzSXG9RvvpW0oj8EJQEguIKdKEJnyVaFdzbUOnzNQ2LPWzrNFmdSUhOliUyjcs0hYknOUNy4OUqeulTVirybNQBD78OlW5VltfEK2vVdqoypEk";
                  dio.post(url,
                      options: Options(headers: {"Authorization": key}),
                      data: {
                        "message": {"data": {}},
                        "notification": {
                          "title": usermodel?.username,
                          "body": msgController.text,
                        },
                        "to": reciver.fcmtoken
                      });
                  MessageModel message = MessageModel(
                      body: msgController.text,
                      senderId: userId,
                      reciverId: reciver.id,
                      timestamp: Timestamp.now());
                  await FirebaseFirestore.instance
                      .collection("chat")
                      .doc(chatID!)
                      .collection("conv")
                      .add(message.toFSDB())
                      .then((value) {
                    msgController.clear();
                  });
                },
                icon: Icon(Icons.send),
                splashRadius: 20,
                iconSize: 20),
          ],
        ),
        border: OutlineInputBorder(),
      ),
    ),
  );
}
