import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panitik/screens/login.dart'; // Import the LoginScreen widget
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import FirebaseFirestore

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  File? _image;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _gradeLevelController = TextEditingController();

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null || _image == null) {
        // Provide some feedback to the user if necessary
        return;
      }

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      // Upload the image to Firebase Storage
      final uploadTask = storageRef.putFile(_image!);

      // Await until the upload is complete
      await uploadTask;

      // Get the download URL
      final String downloadURL = await storageRef.getDownloadURL();

      // Save the download URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'profile_picture': downloadURL}, SetOptions(merge: true));

      // Provide some feedback to the user if necessary
    } catch (e) {
      // Handle any errors that occur during the upload process
      print('Error uploading image: $e');
      // Provide some feedback to the user if necessary
    }
  }

  bool _allConditionsMet() {
    // Check if the image is selected
    if (_image == null) {
      _showSnackBar('Please select a profile picture.');
      return false;
    }

    // Check if any text field is empty
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _schoolNameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _gradeLevelController.text.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return false;
    }

    // Check if the checkbox is checked
    if (!_isChecked) {
      _showSnackBar('Please agree to the terms and conditions.');
      return false;
    }

    // All conditions are met
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // Function to load the terms and conditions text from a file

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
                Text(
                  termsAndConditionsText,
                )
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

  Future<void> _createAccount(BuildContext context) async {
    try {
      // Store the context before the async operation
      BuildContext storedContext = context;

      // Create the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'schoolName': _schoolNameController.text,
        'age': _ageController.text,
        'gradeLevel': _gradeLevelController.text,
      });
      _uploadImage();

      _showSnackBar('You successfully created an account');

      // Navigate to the login screen with success message
      Navigator.pushReplacement(
          storedContext, // Use the stored context here
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    } catch (error) {
      print('Failed to create user: $error');
      // Show error message if user creation fails
      _showSnackBar('Failed to create account. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.add_a_photo,
                          size: 40, color: Color.fromRGBO(139, 69, 19, 1.0)),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  'Full Name', 'Enter your full name', _fullNameController),
              _buildTextField('Email Address', 'Enter your email address',
                  _emailController),
              _buildTextField(
                  'Create Password', 'Create a password', _passwordController),
              _buildTextField('School Name', 'Enter your school name',
                  _schoolNameController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: _buildNumericTextField(
                          'Age', 'e.g. 12', _ageController)),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _buildNumericTextField(
                          'Grade Level', 'e.g. 6', _gradeLevelController)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: Color.fromRGBO(
                        139, 69, 19, 1.0), // Set background color to brown
                    checkColor: Colors.white, // Set checkmark color to white
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap event
                    },
                    child: const Text(
                      'I agree to the ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle onTap event here
                      _showTermsAndConditionsDialog(context);
                    },
                    child: const Text(
                      'terms and conditions.',
                      style: TextStyle(
                        color: Color.fromRGBO(139, 69, 19, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (_allConditionsMet()) {
                      _createAccount(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(
                          139, 69, 19, 1.0), // Set background color to brown
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Set text color to white
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericTextField(
      String labelText, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
