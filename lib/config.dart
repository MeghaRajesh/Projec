import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String place;
  final int age;
  final String gender;

  UserData(this.name, this.place, this.age, this.gender);
}

class SendDataScreen extends StatefulWidget {
  @override
  _SendDataScreenState createState() => _SendDataScreenState();
}

class _SendDataScreenState extends State<SendDataScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  Future<void> sendDataToFirestore() async {
    final String name = nameController.text.trim();
    final String place = placeController.text.trim();
    final int age = int.tryParse(ageController.text.trim()) ?? 0;
    final String gender = genderController.text.trim();

    if (name.isEmpty || place.isEmpty || age == 0 || gender.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter all the required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await firestore.collection('users').add({
        'name': name,
        'place': place,
        'age': age,
        'gender': gender,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data has been sent to Firebase Firestore.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      nameController.clear();
      placeController.clear();
      ageController.clear();
      genderController.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while sending data to Firestore. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Data to Firestore'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: placeController,
              decoration: InputDecoration(
                labelText: 'Place',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendDataToFirestore,
              child: Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SendDataApp());
}

class SendDataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Data to Firestore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SendDataScreen(),
    );
  }
}