import 'package:firebase4/model/user_model.dart';
import 'package:firebase4/utils/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? email;
  String? password;
  int? id;
  int? age;
  String? name;
  String title = "Simple Notofication";
  String description = "Dummy data";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginPage"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () async {
                  Map<String, dynamic> res =
                      await AuthHelper.authHelper.signInAsGeustUser();
                  if (res['user'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Login Sucessfully"),
                      backgroundColor: Colors.green,
                    ));
                    Navigator.of(context)
                        .pushReplacementNamed('/', arguments: res['user']);
                  } else if (res['error'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(" Login failed"),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text("Anonymously login")),
            OutlinedButton(
                onPressed: () {
                  signUpUser();
                },
                child: Text("Sign Up")),
            OutlinedButton(
                onPressed: () {
                  signInUser();
                },
                child: Text("Sign In")),
            OutlinedButton(
                onPressed: () async {
                  Map<String, dynamic> res =
                      await AuthHelper.authHelper.signInWithGoogle();
                  if (res['user'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Google with Login Sscessfully"),
                      backgroundColor: Colors.green,
                    ));
                    User user = res['user'];

                    UserModel userModel = UserModel(
                        id: id!, name: name!, email: email!, age: age!);
                    await FirestoreHelper.firestoreHelper
                        .addAuthenticationUser(userModel: userModel);
                    Navigator.of(context)
                        .pushNamed('/', arguments: res['user']);
                  } else if (res['error'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Google with Login failed"),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text("Login with google"))
          ],
        ),
      ),
    );
  }

  signUpUser() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sign Up"),
          content: Form(
            key: signUpFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Email...";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    email = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Email ",
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Password";
                    } else if (val.length <= 6) {
                      return "Password must Contain 6 Letters";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    password = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Password Here",
                    labelText: "Password",
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: idController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter id";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    id = int.parse(val!);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter id  Here",
                    labelText: "id",
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter name";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter name Here",
                    labelText: "name",
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter age";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    age = int.parse(val!);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter age Here",
                    labelText: "age",
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                emailController.clear();
                passwordController.clear();
                idController.clear();
                nameController.clear();
                ageController.clear();
                name = null;
                id = null;
                age = null;
                email = null;
                password = null;
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (signUpFormKey.currentState!.validate()) {
                  signUpFormKey.currentState!.save();

                  Map<String, dynamic> res = await AuthHelper.authHelper
                      .SignUp(email: email!, password: password!);

                  if (res['user'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Sign Up Sucessfully"),
                      backgroundColor: Colors.green,
                    ));
                    User user = res['user'];

                    UserModel userModel = UserModel(
                        id: id!, name: name!, email: email!, age: age!);
                    await FirestoreHelper.firestoreHelper
                        .addAuthenticationUser(userModel: userModel);
                    Navigator.of(context)
                        .pushReplacementNamed('/', arguments: res['user']);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Sign Up failed",
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                  emailController.clear();
                  passwordController.clear();
                  idController.clear();
                  nameController.clear();
                  ageController.clear();
                  name = null;
                  id = null;
                  age = null;
                  email = null;
                  password = null;
                  Navigator.of(context).pop();
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        );
      },
    );
  }

  signInUser() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Sign In"),
            content: Form(
              key: signInFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Email...";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Email ",
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Password";
                      } else if (val.length <= 6) {
                        return "Password must Contain 6 Letters";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      password = val;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Password Here",
                      labelText: "Password",
                      prefixIcon: Icon(Icons.security),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  emailController.clear();
                  passwordController.clear();
                  email = null;
                  password = null;
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (signInFormKey.currentState!.validate()) {
                    signInFormKey.currentState!.save();
                    Map<String, dynamic> res = await AuthHelper.authHelper
                        .signInWithEmailAndPassword(
                            email: email!, password: password!);

                    if (res['user'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Sign Up Sucessfully"),
                        backgroundColor: Colors.green,
                      ));

                      Navigator.of(context)
                          .pushReplacementNamed('/', arguments: res['user']);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Sign Up failed",
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                    emailController.clear();
                    passwordController.clear();
                    email = null;
                    password = null;
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Sign In"),
              ),
            ],
          ),
        );
      },
    );
  }
}
