import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin_Doctors extends StatelessWidget {
  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: doctorsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> doctor =
                  document.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(doctor['name']),
                  subtitle: Text(
                      'Qualification: ${doctor['qualification']}\nSpecialization: ${doctor['specialization']}\nWorkingTime: ${doctor['workingTime']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeDoctor(document.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddDoctorDialog(),
          );
        },
      ),
    );
  }

  void removeDoctor(String doctorId) {
    doctorsCollection.doc(doctorId).delete();
  }
}

class AddDoctorDialog extends StatefulWidget {
  @override
  _AddDoctorDialogState createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qualificationController =
      TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController workingTimeController =
      TextEditingController();

  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Doctor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: qualificationController,
            decoration: InputDecoration(labelText: 'Qualification'),
          ),
          TextField(
            controller: specializationController,
            decoration: InputDecoration(labelText: 'Specialization'),
          ),
          TextField(
            controller: workingTimeController,
            decoration: InputDecoration(labelText: 'Duty Time'),
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
            addDoctor();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void addDoctor() {
    String name = nameController.text;
    String qualification = qualificationController.text;
    String specialization = specializationController.text;
    String workingTime = workingTimeController.text;

    doctorsCollection.add({
      'name': name,
      'qualification': qualification,
      'specialization': specialization,
      'workingTime': workingTime,
    });
  }
}
