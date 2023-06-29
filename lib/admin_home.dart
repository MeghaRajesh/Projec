import 'package:app_admin/admin_appointment.dart';
import 'package:app_admin/admin_doctors.dart';
import 'package:app_admin/admin_medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_editaccnt.dart';
import 'admin_help.dart';
import 'admin_inhome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Admin_Home extends StatefulWidget {
  const Admin_Home({super.key});

  @override
  State<Admin_Home> createState() => _Admin_HomeState();
}

class _Admin_HomeState extends State<Admin_Home> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          child: Row(
            children: [
              Row(
                children: [
                   Image.asset(
                     "Images/phclogo2.jpeg",
                     scale: 6,
                     fit: BoxFit.fitHeight,
                   ),
                  Column(
                    children: [
                      Text(
                        "P H C",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20),
                      ),
                      Text("Live,Love,Care",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Admin_Home()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.home),
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin_Notification()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.notifications),
              ),
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin_EditAccount()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person),
              ),
            ),
            label: 'Account',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "Images/homedoc1.png", // Replace with your image path
            fit: BoxFit.cover,
            width: 400,
            height: 400,
          ),
          Text("\n"),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 110,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Admin_Appointment();
                      }
                      )
                      );
                    },
                    child: Column(
                      children: [
                        Text("                   "),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.calendar_month_outlined),
                        ),
                        Text("       Book\n Appointment              ",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Admin_Inhome();
                      }
                      )
                      );
                    },
                    child: Column(
                      children: [
                        Text("              "),
                        CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.house_rounded)),
                        Text(
                          " Inhome\nServices",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.blue,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Admin_Help();
                      }));
                    },
                    child: Column(
                      children: [
                        Text("             "),
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24,
                            child: const Icon(Icons.help_center)),
                        Text("Help",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),


              
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                    width: 110,
                    height: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Admin_Doctors();
                          }));
                        },
                        
                        child: Column(
                          children: [
                            Text("             "),
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: const Icon(Icons.medical_services)),
                            Text("Doctors\nOn Duty",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Admin_Medicine();
                          }));
                        },
                        
                        child: Column(
                          children: [
                            Text("             "),
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: const Icon(Icons.medication_liquid_outlined)),
                            Text("Medicine\nAvailable",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    ));
  }
}

class Admin_Notification extends StatelessWidget {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsCollection.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> notification =
                  document.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(notification['text']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeNotification(document.id);
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddNotificationDialog(),
          );
        },
      ),
    );
  }

  void removeNotification(String notificationId) {
    notificationsCollection.doc(notificationId).delete();
  }
}

class AddNotificationDialog extends StatefulWidget {
  @override
  _AddNotificationDialogState createState() => _AddNotificationDialogState();
}

class _AddNotificationDialogState extends State<AddNotificationDialog> {
  final TextEditingController textController = TextEditingController();

  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Notification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Notification Text'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            addNotification();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void addNotification() {
    String notificationText = textController.text;

    notificationsCollection.add({
      'text': notificationText,
    });
  }
}
