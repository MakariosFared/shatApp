import 'package:chat_app_course/auth/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../shared/shared_component.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static const routeName = "login_screen";

  static const String _title = 'Chat app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: Padding(
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
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                customTextFormField(
                  controller: nameController,
                  label: 'Email',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter user name";
                    }
                  },
                ),
                customTextFormField(
                  label: "Password",
                  controller: passwordController,
                  suffixIcon: IconButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .changePasswordVisability();
                      },
                      icon: Icon(Icons.remove_red_eye),
                      splashRadius: 20,
                      iconSize: 20),
                  obscure:
                      Provider.of<AuthProvider>(context, listen: false).visable,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter password";
                    }
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                  ),
                ),
                customElevatedButton(
                    child: Text("Login"),
                    onPress: () async {
                      if (formKey.currentState!.validate()) {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signIn(
                                email: nameController.text,
                                password: passwordController.text,
                                context: context)
                            .then((value) {});
                      }
                    }),
                Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        //navigate to signup screen

                        await Navigator.pushNamed(
                            context, SignUpScreen.routeName);
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
