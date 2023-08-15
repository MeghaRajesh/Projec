import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Medicine {
  final String name;
  int quantity;

  Medicine({required this.name, required this.quantity});
}

class Admin_Medicine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicines Available',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MedicineInventoryScreen(),
    );
  }
}

class MedicineInventoryScreen extends StatefulWidget {
  @override
  _MedicineInventoryScreenState createState() =>
      _MedicineInventoryScreenState();
}

class _MedicineInventoryScreenState extends State<MedicineInventoryScreen> {
  final CollectionReference medicinesRef =
      FirebaseFirestore.instance.collection('medicines');
  final TextEditingController medicineNameController =
      TextEditingController();
  final TextEditingController medicineQuantityController =
      TextEditingController();

  List<Medicine> medicines = []; // List of medicines

  @override
  void initState() {
    super.initState();
    // Load medicines data from Firestore when the widget is initialized
    _loadMedicines();
  }

  void _loadMedicines() async {
    final QuerySnapshot snapshot = await medicinesRef.get();
    setState(() {
      medicines = snapshot.docs.map((doc) {
        return Medicine(
          name: doc['name'],
          quantity: doc['quantity'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines Available'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share the medicine details through Gmail app
              _launchGmailApp();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: medicineNameController,
              decoration: InputDecoration(
                labelText: 'Medicine Name',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: medicineQuantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: addMedicine,
              child: Text('Add Medicine'),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(medicines[index].name),
                      subtitle:
                          Text('Quantity: ${medicines[index].quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                updateMedicineQuantity(medicines[index], -1),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                updateMedicineQuantity(medicines[index], 1),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteMedicine(medicines[index]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addMedicine() async {
    String name = medicineNameController.text.trim();
    String quantityString = medicineQuantityController.text.trim();

    if (name.isNotEmpty && quantityString.isNotEmpty) {
      int quantity = int.parse(quantityString);

      await medicinesRef.add({
        'name': name,
        'quantity': quantity,
      });

      medicineNameController.clear();
      medicineQuantityController.clear();
    }
  }

  void deleteMedicine(Medicine medicine) async {
    await medicinesRef
        .where('name', isEqualTo: medicine.name)
        .where('quantity', isEqualTo: medicine.quantity)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  void updateMedicineQuantity(Medicine medicine, int change) async {
    int newQuantity = medicine.quantity + change;
    if (newQuantity >= 0) {
      await medicinesRef
          .where('name', isEqualTo: medicine.name)
          .where('quantity', isEqualTo: medicine.quantity)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.update({'quantity': newQuantity});
        });
      });
    }
  }
void _launchGmailApp() async {
    String subject = 'Medicine Inventory Details';
    String body = _buildEmailBody();

    final smtpServer = gmail('saranya29testing@gmail.com', 'esbhgqbcemhviazk'); // Replace with your Gmail email and application-specific password

    final message = Message()
      ..from = Address('saranya29testing@gmail.com') // Replace with your Gmail email
      ..recipients.add('megharajesh139@gmail.com') // Replace with the recipient's email address
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');

      _showSnackBar('Mail sent successfully!');
    } on MailerException catch (e) {
      print('Error sending email: $e');
      _showSnackBar('Error sending email. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }


  String _buildEmailBody() {
    String emailBody = 'Medicine Inventory Details:\n\n';
    // Loop through the list of medicines and add them to the email body
    for (Medicine medicine in medicines) {
      emailBody += 'Medicine Name: ${medicine.name}\n';
      emailBody += 'Quantity: ${medicine.quantity}\n\n';
    }
    return emailBody;
  }
}


