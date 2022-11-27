
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
   String? body ;
   String? senderId;
   String? reciverId;
   Timestamp? timestamp;

  MessageModel({this.body, this.senderId, this.reciverId, this.timestamp});

  Map<String,dynamic> toFSDB() {
    Map<String,dynamic> data = {};
    data["body"] = body;
    data["senderId"] = senderId;
    data["reciverId"] = reciverId;
    data["timestamp"] = timestamp;
    return data;
  }

  MessageModel.fromFSDB(Map<String,dynamic> data) {
    body = data["body"];
    senderId = data["senderId"];
    reciverId = data["reciverId"];
    timestamp = data["timestamp"];
  }

}