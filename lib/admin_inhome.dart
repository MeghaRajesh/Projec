import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin_Inhome extends StatefulWidget {
  @override
  _Admin_InhomeState createState() => _Admin_InhomeState();
}

class _Admin_InhomeState extends State<Admin_Inhome> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference detailsCollection =
      FirebaseFirestore.instance.collection('inhome');
  CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('Appointments'); // New collection

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  bool isSaving = false; // Added variable to track saving state
  bool isSaved = false; // Added variable to track saved state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InHome Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: detailsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No appointment details found.');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];

              String Address = doc['Address'] ?? '';
              String Age = doc['Age'] ?? '';
              int parsedAge = int.tryParse(Age) ?? 0;
              String Gender = doc['Gender'] ?? '';
              String patientName = doc['Name'] ?? '';
              String Email = doc ['Email'] ?? '';
              String SelectedService = doc ['Selected Service'] ?? '';
              

              return ListTile(
                title: Text(patientName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: $Gender'),
                    Text('Address: $Address'),
                    Text('Age: $Age'),
                    Text('Selected Service:$SelectedService'),
                    SizedBox(height: 10),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: 'Enter date',
                      ),
                    ),
                    TextField(
                      controller: timeController,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: 'Enter time',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isSaving || isSaved
                          ? null // Disable the button while saving or saved
                          : () {
                              // Save date and time to Firebase
                              String appointmentDate = dateController.text;
                              String appointmentTime = timeController.text;
                              saveAppointmentDateTime(
                                  doc.id,
                                  patientName,
                                  appointmentDate,
                                  appointmentTime,
                                  Email,
                                  SelectedService,
                                  );
                            },
                      child: Text(
                        isSaving ? 'Saving...' : (isSaved ? 'Saved' : 'Save'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void saveAppointmentDateTime(String documentId, String patientName,String appointmentDate,
      String appointmentTime,String Email,String SelectedService ) {
    setState(() {
      isSaving = true; // Set saving state to true
    });

    detailsCollection.doc(documentId).update({
      'AppointmentDate': appointmentDate,
      'AppointmentTime': appointmentTime,
    }).then((value) {
      // Date and time saved successfully
      print('Date and time saved successfully!');

      // Create a new document in the appointments collection
      appointmentsCollection.add({
        
        'AppointmentDate': appointmentDate,
        'AppointmentTime': appointmentTime,
        'Email':Email,
        'Selected Service':SelectedService,
      }).then((_) {
        setState(() {
          isSaving = false; // Set saving state back to false
          isSaved = true; // Set saved state to true
        });
        // Reset the saved state after a delay (e.g., 2 seconds)
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isSaved = false; // Set saved state back to false
          });
        });
      }).catchError((error) {
        // Error occurred while creating the new document
        print('Error creating appointment: $error');
        setState(() {
          isSaving = false; // Set saving state back to false
        });
      });
    }).catchError((error) {
      // Error occurred while saving
      print('Error saving date and time: $error');
      setState(() {
        isSaving = false; // Set saving state back to false
      });
    });
  }
}  