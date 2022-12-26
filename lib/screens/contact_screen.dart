import 'package:chat_app_course/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);
  static const routeName = "ContactScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("contact screen"),actions: [
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text(
              "LogOut",
              style: TextStyle(color: Colors.white),
            ))
      ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          List<UserModel> users = [];
          snapshot.data?.docs.forEach((user) {
            users.add(UserModel.fromFSDB(user.data()));
          });
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ChatScreen.routeName,
                      arguments: users[index]);
                },
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: users[index].picture == null
                          ? AssetImage("assets/image/11.jpg")
                          : NetworkImage(users[index].picture!)
                              as ImageProvider),
                  title: Text(users[index].username!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
