import 'package:chat_app_course/Model/Message_Model.dart';
import 'package:chat_app_course/Model/user_model.dart';
import 'package:chat_app_course/const/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMsgItem extends StatelessWidget {
  ChatMsgItem({Key? key, required this.msg ,required this.reciver}) : super(key: key);

  MessageModel msg;
  UserModel reciver;

  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;
    var userId = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 8,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: userId != msg.senderId
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (userId != msg.senderId)
                const CircleAvatar(
                    child: Text(
                  "N",
                )),
              if (userId != msg.senderId)
                const SizedBox(
                  width: 10,
                ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(userId != msg.senderId ? usermodel!.username! : reciver.username!,
                          style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.visible,
                              height: 1.5)),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(mainAxisSize: MainAxisSize.min,
                        children: [
                          if(msg.imageurl != null)
                            Container(

                            ),
                          Text(
                            msg.body!,
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.visible,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: userId != msg.senderId
                        ? Colors.blue
                        : Colors.deepPurpleAccent),
              ),
              if (userId == msg.senderId)
                SizedBox(
                  width: 10,
                ),
              if (userId == msg.senderId)
                CircleAvatar(
                    child: Text(
                  "N",
                )),
            ]),
      ),
    );
  }
}
