import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateDocument(String collectionName, String fieldName, String value, Map<String, dynamic> updatedData) async {
  // Query the collection to find the document
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .where(fieldName, isEqualTo: value)
      .get();

  // Check if the document exists
  if (querySnapshot.docs.isNotEmpty) {
    // Get the document ID
    String docId = querySnapshot.docs.first.id;

    // Update the document
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .update(updatedData);
  }
}
