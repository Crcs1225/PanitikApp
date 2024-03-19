import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOrCreateUserData(
      String userId, Map<String, dynamic> userData) async {
    try {
      // Reference to the user's document in the users collection
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Update the user's data or create a new document if it doesn't exist
      await userRef.set(userData, SetOptions(merge: true));

      print('User data updated successfully');
    } catch (error) {
      print('Error updating user data: $error');
      throw error; // You can handle errors as needed
    }
  }

  // Add more functions for interacting with Firestore as needed
}
