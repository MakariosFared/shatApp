
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? body ;
  String? senderId;
  String? reciverId;
  Timestamp? timestamp;
  String? imageurl;

  MessageModel({this.body, this.senderId, this.reciverId, this.timestamp , this.imageurl});

  Map<String,dynamic> toFSDB() {
    Map<String,dynamic> data = {};
    data["body"] = body;
    data["senderId"] = senderId;
    data["reciverId"] = reciverId;
    data["timestamp"] = timestamp;
    data["imageurl"] = imageurl;
    return data;
  }

  MessageModel.fromFSDB(Map<String,dynamic> data) {
    body = data["body"];
    senderId = data["senderId"];
    reciverId = data["reciverId"];
    timestamp = data["timestamp"];
    imageurl = data["imageurl"];
  }
}