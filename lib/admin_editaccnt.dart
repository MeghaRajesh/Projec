import 'package:flutter/material.dart';
import 'signIn.dart';
import 'loginpage.dart';

import 'nextScreen.dart';
import 'package:provider/provider.dart';

class Admin_EditAccount extends StatefulWidget {
  const Admin_EditAccount({super.key});

  @override
  State<Admin_EditAccount> createState() => _Admin_EditAccountState();
}

class _Admin_EditAccountState extends State<Admin_EditAccount> {
  Future getData() async {
    final sp = context.read<signIn>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<signIn>();
    return Scaffold(
      backgroundColor: Color.fromARGB(235, 242, 238, 238),
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${sp.name}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${sp.email}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  sp.userSignOut();
                  nextScreenReplace(context, const login());
                },
                child: Text("Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                    )))
          ],
        ),
      ),
    );
  }
}