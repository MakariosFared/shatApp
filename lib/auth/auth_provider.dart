import 'dart:io';

import 'package:chat_app_course/Model/user_model.dart';
import 'package:chat_app_course/const/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/chat_screen.dart';

class AuthProvider with ChangeNotifier {
  bool visable = false;
  XFile? choosenFile;
  bool isLoading = false;

  void pickImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        choosenFile = value;
        notifyListeners();
      } else {
        return;
      }
    });
  }

  Future<String> uploadProfileImage(path) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('$path/${choosenFile?.name}');
    UploadTask uploadTask = reference.putFile(File(choosenFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  signIn({required email, required password, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      SnackBar snackbar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signup(
      {required email,
      required password,
      required context,
      required name}) async {
    try {
      isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        if (choosenFile != null) {
          await uploadProfileImage("profileImage").then((value) async {
            await FirebaseAuth.instance.currentUser?.updatePhotoURL(value);
            await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
            await creatUserData();
            isLoading = false;
            notifyListeners();
          });
          // Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
        } else {
          await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
          await creatUserData();
          isLoading = false;
          Navigator.pop(context);
          notifyListeners();
          // Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
        }
      });
    } on FirebaseAuthException catch (e) {
      SnackBar snackbar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  changeobscure() {
    visable = !visable;
    notifyListeners();
  }

  Future<void> creatUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    usermodel = UserModel(
        id: user?.uid,
        picture: user?.photoURL,
        username: user?.displayName,
        fcmtoken: fcmToken);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .set(usermodel!.toFSDB());
  }

  Future<void> getData() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      usermodel = UserModel.fromFSDB(value.data());
    });
  }
}
