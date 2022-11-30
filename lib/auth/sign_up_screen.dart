import 'dart:io';

import 'package:chat_app_course/auth/sign_in_screen.dart';
import 'package:chat_app_course/chat_screen.dart';
import 'package:chat_app_course/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "register_screen";

  static const String _title = 'Chat app';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthProvider prov = Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text(_title), backwardsCompatibility: false),
      body:  Padding(
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
                        Provider.of<AuthProvider>(context).pickImage();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.blue, width: 2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),

                            clipBehavior: Clip.antiAlias,

                            child: Consumer<AuthProvider>(
                              builder: (context, provider, child) {
                                return Image(
                                    width: 100,
                                    height: 100,
                                    image: provider.chosenFile != null
                                        ? FileImage(File(provider.chosenFile!.path))
                                    as ImageProvider
                                        : AssetImage(
                                        "assets/images/default-user-image.png")
                                    as ImageProvider,
                                    fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                        // backgroundImage: choosenFile != null
                        //             ? FileImage(File(choosenFile!.path))
                        //                 as ImageProvider
                        //             : AssetImage(
                        //                     "assets/images/default-user-image.png")
                        //                 as ImageProvider,
                        // backgroundImage: choosenFile != null
                        //     ? FileImage(File(choosenFile!.path))
                        // as ImageProvider
                        //     : AssetImage(
                        //     "assets/images/default-user-image.png")
                        // as ImageProvider,
                        // child: ClipRRect(
                        // clipBehavior: Clip.hardEdge,
                        // child: Image(
                        //     fit: BoxFit.contain,
                        //     image: choosenFile != null
                        //         ? FileImage(File(choosenFile!.path))
                        //     as ImageProvider
                        //         : AssetImage(
                        //         "assets/images/default-user-image.png")
                        //     as ImageProvider)),
                      )),
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
                    obscureText: prov.visable,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            prov.changePasswordVisability();
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
                      child:
                      prov.isLoading ? CircularProgressIndicator() : Text('Login'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          prov.signUp(email: emailController.text, password: passwordController.text, context: context,username: nameController.text);
                        }

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
                        Navigator.pop(context);
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          )),
    );
  }
}





