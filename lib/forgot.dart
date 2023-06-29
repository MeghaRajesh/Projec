import 'package:flutter/material.dart';
import 'package:app_admin/loginpage.dart';

class forgot extends StatelessWidget {
  const forgot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(235, 242, 238, 238),
      appBar: AppBar(
        title: SizedBox(
          child: Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    "Images/phclogo.jpg",
                    scale: 25,
                    fit: BoxFit.fitHeight,
                  ),
                  const Column(
                    children: [
                      Text(
                        " PHC                  ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" Live,Love,Care"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            '\nForgot password ?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 9, 9, 9),
                fontWeight: FontWeight.bold),
          ),
          const Text('\n\n\n'),
          const SizedBox(
            width: 200,
            child: TextField(
              style: TextStyle(
                fontSize: 10.0,
                height: 1.0,
              ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'The email you used while creating account'),
            ),
          ),
          const Text('\n'),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Send OTP',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              // ...
            },
          ),
          const Text('\n'),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Go back',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const login();
                }));
              }),
        ],
      ),
    );
  }
}