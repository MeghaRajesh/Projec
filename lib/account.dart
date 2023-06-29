import 'package:flutter/material.dart';
import 'package:app_admin/loginpage.dart';

class account extends StatelessWidget {
  const account({super.key});

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
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Text(
          '\nCreate your account',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 9, 9, 9),
              fontWeight: FontWeight.bold),
        ),
        const Text('\n'),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Firstname',
                hintText: 'Enter your first name'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Secondname',
                hintText: 'Enter your second name'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Age',
                hintText: 'Enter your age'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
                hintText: 'Enter your gender'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
                hintText: 'This will be used as your username'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Create password',
                hintText: 'Min 6 characters'),
          ),
        ),
        const SizedBox(
          width: 200,
          child: TextField(
            style: TextStyle(
              fontSize: 10.0,
              height: 1.0,
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your phone number',
                hintText: '+91xxxxxxxxxx'),
          ),
        ),
        const Text('\n\n'),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text('SUBMIT',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            // ...
          },
        ),
        const Text('\n\n'),
        TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Go back',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return  const login();
              }));
            }),
      ]),
    );
  }
}