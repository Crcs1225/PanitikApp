import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserProfileImageUrl(String userId) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (snapshot.exists) {
    final userData = snapshot.data() as Map<String, dynamic>;
    return userData['profile_picture'] as String?;
  } else {
    return null;
  }
}
