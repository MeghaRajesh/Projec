import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin_Appointment extends StatefulWidget {
  @override
  _Admin_AppointmentState createState() => _Admin_AppointmentState();
}

class _Admin_AppointmentState extends State<Admin_Appointment> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference detailsCollection =
      FirebaseFirestore.instance.collection('combinedDetails');
  CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('BookedAppointments'); // New collection

  List<TextEditingController> timeControllers = []; // List of controllers for each detail item
  bool isSaving = false; // Added variable to track saving state
  bool isSaved = false; // Added variable to track saved state

  @override
  void dispose() {
    // Dispose all the controllers to avoid memory leaks
    for (var controller in timeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
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
              String age = doc['Age'] ?? '';
              int parsedAge = int.tryParse(age) ?? 0;
              String Gender = doc['Gender'] ?? '';
              String patientName = doc['Name'] ?? '';
              String Email = doc['Email'] ?? '';
              String Doctorname =doc['Doctor name'];

              // Create a separate TextEditingController for each detail item
              TextEditingController timeController = TextEditingController();
              timeControllers.add(timeController);

              return ListTile(
                title: Text(patientName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: $Gender'),
                    Text('Address: $Address'),
                    Text('Age: $age'),
                    Text('Doctor Name:$Doctorname'),
                    SizedBox(height: 10),

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
                              // Save time to Firebase
                              String appointmentTime = timeController.text;
                              saveAppointmentDateTime(
                                doc.id,
                                appointmentTime,
                                patientName,
                                Email,
                                Doctorname,
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

  void saveAppointmentDateTime(String documentId, String appointmentTime, String patientName, String Email,String Doctorname) {
    setState(() {
      isSaving = true; // Set saving state to true
    });

    // Find the corresponding TextEditingController for the detail item
    int index = timeControllers.indexWhere((controller) => controller.text == appointmentTime);

    if (index >= 0) {
      TextEditingController timeController = timeControllers[index];

      // Get the GPay link based on your implementation
      String gpayLink = '8281221409';

      detailsCollection.doc(documentId).update({
        'AppointmentTime': appointmentTime,
       
        'GPayLink': gpayLink,
        'Email': Email,
         'Doctor Name':Doctorname,
      }).then((value) {
        // Time and GPay link saved successfully
        print('Time and GPay link saved successfully!');

        // Create a new document in the appointments collection
        appointmentsCollection.add({
          'PatientName': patientName,
          'AppointmentTime': appointmentTime,
          'GPayLink': gpayLink,
          'Email': Email, 
          'Doctor Name':Doctorname,
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
        print('Error saving time and GPay link: $error');
        setState(() {
          isSaving = false; // Set saving state back to false
        });
      });
    }
  }
}