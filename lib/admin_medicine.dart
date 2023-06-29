import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines Available'),
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
            StreamBuilder<QuerySnapshot>(
              stream: medicinesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<Medicine> medicines = [];
                snapshot.data!.docs.forEach((doc) {
                  medicines.add(Medicine(
                    name: doc['name'],
                    quantity: doc['quantity'],
                  ));
                });
                return Expanded(
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
                                onPressed: () =>
                                    deleteMedicine(medicines[index]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
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
}
