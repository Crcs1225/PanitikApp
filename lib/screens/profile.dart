import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panitik/screens/login.dart';
import '../utils/picturegetter.dart';

import '../utils/profilegetter.dart';
import 'about.dart';
import 'reviewer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData? userData;
  String? _profileImageUrl; // Initialize userData as nullable

  @override
  void initState() {
    super.initState();
    getUserID();
    loadProfilePicture(); // Initialize userId and fetch user data
  }

  @override
  void dispose() {
    // Cancel timers and animations here
    super.dispose();
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  Future<void> loadProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profileImageUrl = await getUserProfileImageUrl(user.uid);
      setState(() {
        _profileImageUrl = profileImageUrl;
      });
    }
  }

  Future<void> getUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid; // Initialize userId if the user is logged in
      try {
        UserData fetchedUserData =
            await getUserData(userId); // Fetch user data using userId
        if (mounted) {
          setState(() {
            userData = fetchedUserData; // Update the userData
          });
        }
      } catch (e) {
        // Handle error fetching user data
        print('Error fetching user data: $e');
        print('profile screen');
      }
    } else {
      // Handle the case when no user is logged in
      print('User is not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            // Show the confirmation dialog
            bool confirmLogout = await _showConfirmationDialog(context);
            if (confirmLogout) {
              // If confirmed, sign out the user
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: userData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData!.fullName,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                _buildInfoRow('Grade', userData!.gradeLevel),
                                SizedBox(
                                    width:
                                        16), // Add some space between Grade and Age
                                _buildInfoRow('Age', userData!.age),
                              ],
                            ),

                            // Add more fields as needed
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            _profileImageUrl!), // Placeholder image
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for editing profile
                      _showEditProfileDialog(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 24),
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color.fromRGBO(139, 69, 19, 1.0),
                        ), // Border color
                      ),
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          textAlign:
                              TextAlign.center, // Align text in the center
                          style: TextStyle(
                            color:
                                Color.fromRGBO(139, 69, 19, 1.0), // Text color
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Other settings or actions can be added here

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200], // Set background color to grey
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8), // Spacer
                        _buildSettingsItem(Icons.book, 'Reviewer', () {
                          // Add functionality for the Reviewer setting
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReviewerScreen(),
                            ),
                          );
                        }),
                        _buildSettingsItem(Icons.lock, 'Change Password', () {
                          // Add functionality for the Change Password setting
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        }),
                        _buildSettingsItem(
                            Icons.description, 'Terms and Policies', () {
                          // Add functionality for the Terms and Policies setting
                          _showTermsAndConditionsDialog(context);
                        }),
                        _buildSettingsItem(Icons.info, 'About', () {
                          // Add functionality for the About setting
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          );
                        }),

                        // Add more settings as needed
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child:
                    CircularProgressIndicator(), // Show loading indicator if userData is null
              ),
      ),
    );
  }

  Future<String> _loadTermsAndConditionsText() async {
    return await rootBundle.loadString('assets/terms_and_conditions.txt');
  }

  Future<void> _showTermsAndConditionsDialog(BuildContext context) async {
    final String termsAndConditionsText = await _loadTermsAndConditionsText();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Add your terms and conditions text here
                // Example:
                Text(termsAndConditionsText)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Assign the onTap handler
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color.fromRGBO(139, 69, 19, 1.0),
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    // Show the confirmation dialog
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Logout'),
              content: Text('Are you sure you want to log out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel logout
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirm logout
                  },
                  child: Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();

    TextEditingController schoolNameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController gradeLevelController = TextEditingController();

    File? _imageFile; // Variable to hold the selected image file

    Future<void> _uploadImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path); // Get the selected image file
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ), // Add padding to the content
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize
                  .min, // Ensure the dialog takes the minimum space needed
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: _uploadImage,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _imageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _imageFile!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          ),
                  ),
                ),
                SizedBox(height: 16), // Spacer
                // Full Name
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ), // Adjust content padding for smaller height
                  ),
                ),
                SizedBox(height: 8), // Spacer

                // School Name
                TextFormField(
                  controller: schoolNameController,
                  decoration: InputDecoration(
                    labelText: 'School Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ), // Adjust content padding for smaller height
                  ),
                ),
                SizedBox(height: 8), // Spacer
                // Age and Grade Level
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ), // Adjust content padding for smaller height
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 8), // Spacer
                    Expanded(
                      child: TextFormField(
                        controller: gradeLevelController,
                        decoration: InputDecoration(
                          labelText: 'Grade Level',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ), // Adjust content padding for smaller height
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add functionality to cancel
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromRGBO(139, 69, 19, 1.0),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (fullNameController.text.isEmpty ||
                    schoolNameController.text.isEmpty ||
                    ageController.text.isEmpty ||
                    gradeLevelController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                  return;
                }

                // Add functionality to save changes
                String fullName = fullNameController.text;

                String schoolName = schoolNameController.text;
                String age = ageController.text;
                String gradeLevel = gradeLevelController.text;

                // Update user data in Firebase
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String userId = user.uid;
                  try {
                    if (_imageFile != null) {
                      // Upload image to Firebase Storage
                      String imageUrl =
                          await uploadImageToFirebaseStorage(_imageFile!);

                      // Update user profile picture URL in Firestore
                      await updateUserProfileImageUrl(userId, imageUrl);
                    }

                    // Update user data in Firestore
                    await updateUserData(userId, {
                      'fullName': fullName,
                      'schoolName': schoolName,
                      'age': age,
                      'gradeLevel': gradeLevel,
                    });

                    // Update the UI with the new user data
                    setState(() {
                      userData = UserData(
                        fullName: fullName,
                        schoolName: schoolName,
                        age: age,
                        gradeLevel: gradeLevel,
                      );
                    });
                    _showProfileEditedSnackBar(context);
                    // Close the dialog
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Handle error updating user data
                    print('Error updating user data: $e');
                  }
                }
              },
              child: Text('Save',
                  style: TextStyle(
                    color: Color.fromRGBO(139, 69, 19, 1.0),
                  )),
            ),
          ],
        );
      },
    );
  }

  void _showProfileEditedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your profile has been successfully edited.'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  Future<void> updateUserProfileImageUrl(String userId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profile_picture': imageUrl});
    } catch (e) {
      print('Error updating user profile image URL: $e');
      throw e;
    }
  }

  Future<String> uploadImageToFirebaseStorage(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask;
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      throw error;
    }
  }
}
