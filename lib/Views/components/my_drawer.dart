import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_helper.dart';

class MyDrawer extends StatefulWidget {
  final User user;
  MyDrawer({required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String? name;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 200),
                      child: IconButton(
                          onPressed: () async {
                            await AuthHelper.authHelper.signOutUser();
                            Navigator.of(context).pop('LoginPage');
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          )),
                    ),
                    DrawerHeader(
                        child: CircleAvatar(
                      radius: 40,
                      backgroundImage: (widget.user.isAnonymous)
                          ? null
                          : (widget.user.photoURL == null)
                              ? null
                              : NetworkImage(widget.user.photoURL!),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    (widget.user.isAnonymous)
                        ? Container()
                        : Text(
                            "Email : ${widget.user.email}",
                            style: TextStyle(color: Colors.white),
                          ),
                  ],
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        children: [
                          Text("UserName : "),
                          (widget.user.isAnonymous)
                              ? Text("Anonymas User")
                              : (widget.user.displayName == null)
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Text("UserName: "),
                                          Text((widget.user.isAnonymous)
                                              ? "No User"
                                              : "Unknown"),
                                        ],
                                      ),
                                    )
                                  : Text(widget.user.displayName!),
                          IconButton(
                              onPressed: () {
                                editUserName();
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void editUserName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change UserName"),
          content: Form(
            key: userFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter a UserName";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter UserName Here",
                    labelText: "UserName",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (userFormKey.currentState!.validate()) {
                  userFormKey.currentState!.save();

                  User? user = await AuthHelper.authHelper.editusername(name!);

                  if (user != null) {
                    setState(() {
                      name = user.displayName;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Edit Sucessfully"),
                        backgroundColor: Colors.green,
                      ));
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Edit Failed"),
                      backgroundColor: Colors.red,
                    ));
                  }
                  nameController.clear();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
