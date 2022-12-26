import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/chat_screen.dart';

class AuthProvider with ChangeNotifier{


  bool isLoading = false;
  bool visable = false;

  void changePasswordVisability(){
    visable = !visable;
    notifyListeners();

  }




  Future<void> signIn({required String email ,required String password,required BuildContext context})async {
   try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
       email:email ,
       password: password,
     ).then((value) {

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

 void signUp({required String email ,required String password,required BuildContext context,required String username})async{
   try {
       isLoading = true;
       notifyListeners();
     await FirebaseAuth.instance
         .createUserWithEmailAndPassword(
       email: email,
       password: password,
     )
         .then((value) async {
      setUserData(context: context, username: username);

     });
   } on FirebaseAuthException catch (e) {
     SnackBar snackbar =
     SnackBar(content: Text(e.message!));
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

  XFile? chosenFile;


  void pickImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
          chosenFile = value;
          notifyListeners();
      } else {
        return;
      }
    });
  }

  void setUserData({required BuildContext context , required String username}) async{
   if (chosenFile != null) {
     await uploadProfileImage(File(chosenFile!.path))
         .then((value) {
       FirebaseAuth.instance.currentUser
           ?.updatePhotoURL(value);
       FirebaseAuth.instance.currentUser
           ?.updateDisplayName(username);

       isLoading = false;
       notifyListeners();
       Navigator.of(context)
           .pushReplacementNamed(ChatScreen.routeName);
     });
   } else {
     FirebaseAuth.instance.currentUser
         ?.updateDisplayName(username);
     isLoading = false;
     notifyListeners();
     Navigator.of(context)
         .pushReplacementNamed(ChatScreen.routeName);
   }
 }

  Future<String> uploadProfileImage(File image) async {
    Reference reference = FirebaseStorage.instance.ref().child('profileImage/${FirebaseAuth.instance.currentUser}-profile');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}