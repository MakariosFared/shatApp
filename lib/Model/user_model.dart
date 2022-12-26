class UserModel{
  String? id;
  String? picture;
  String? username;
  String? fcmtoken;

  UserModel({this.id ,this.picture,this.username,this.fcmtoken});


  Map<String,dynamic> toFSDB() {
    Map<String,dynamic> data = {};
    data["id"] = id;
    data["picture"] = picture;
    data["username"] = username;
    data["fcmtoken"] = fcmtoken;
    return data;
  }

  UserModel.fromFSDB(Map<String,dynamic>? data) {
    if(data != null){
      id = data["id"];
      picture = data["picture"];
      username = data["username"];
      fcmtoken = data["fcmtoken"];
    }

  }
}