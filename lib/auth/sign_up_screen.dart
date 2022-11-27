import 'dart:io';

import 'package:chat_app_course/auth/sign_in_screen.dart';
import 'package:chat_app_course/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "register_screen";

  static const String _title = 'Chat app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool visable = false;
  XFile? choosenFile;
  bool isLoading = false;

  void pickImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          choosenFile = value;
        });
      } else {
        return;
      }
    });
  }


  Future<String> uploadProfileImage(File image) async {
    Reference reference = FirebaseStorage.instance.ref().child('profileImage/');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'ShOP APP',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Center(
                child: GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey),
                        height: 45,
                        width:  45,

                        child: ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: Image(
                            fit: BoxFit.cover,
                            image: choosenFile != null
                                ? FileImage(File(choosenFile!.path))
                            as ImageProvider
                                : AssetImage(
                                "assets/images/default-user-image.png")
                            as ImageProvider)),)),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter user name";
                    }
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter user name";
                    }
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {}
                  },
                  obscureText: visable,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          visable = !visable;
                        },
                        icon: Icon(Icons.remove_red_eye),
                        splashRadius: 20,
                        iconSize: 20),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: isLoading ? CircularProgressIndicator() : Text('Login'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                           await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          )
                              .then((value)async {

                                // await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                                if(choosenFile != null) {
                                 await uploadProfileImage(File(choosenFile!.path)).then((value) {
                                   FirebaseAuth.instance.currentUser
                                       ?.updatePhotoURL(value);
                                   FirebaseAuth.instance.currentUser
                                       ?.updateDisplayName(nameController.text);
                                   setState(() {
                                     isLoading = false;

                                   });
                                   Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);

                                 });

                                }else{
                                  FirebaseAuth.instance.currentUser
                                      ?.updateDisplayName(nameController.text);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
                                }

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

                      print(nameController.text);
                      print(passwordController.text);
                    },
                  )),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //signup screen
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ));
  }
}
