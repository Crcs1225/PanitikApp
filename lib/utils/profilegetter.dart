import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String fullName;
  final String gradeLevel;
  final String age;
  final String schoolName;

  UserData({
    required this.fullName,
    required this.gradeLevel,
    required this.age,
    required this.schoolName,
  });
}

Future<UserData> getUserData(String userId) async {
  if (userId.isEmpty) {
    throw ArgumentError('userId must not be empty');
  }

  try {
    DocumentSnapshot userDataSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDataSnapshot.exists) {
      // Construct a UserData object using data from Firestore
      UserData userData = UserData(
        fullName: userDataSnapshot['fullName'],
        gradeLevel: userDataSnapshot['gradeLevel'],
        age: userDataSnapshot['age'],
        schoolName: userDataSnapshot['schoolName'],
      );
      return userData; // Return the fetched user data
    } else {
      print('User data does not exist');
      throw Exception('User data not found');
    }
  } catch (e) {
    print('Error getting user data: $e');
    throw e; // Rethrow the error so it can be caught by the caller
  }
}
