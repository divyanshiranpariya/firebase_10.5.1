import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/auth_helper.dart';
import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await AuthHelper.authHelper.signOutUser();
                Provider.of(context).pop();
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
      ),
      drawer: MyDrawer(
        user: user,
      ),
    );
  }
}
