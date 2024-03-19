import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panitik/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;

  Future<void> _showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dismiss dialog when tapped outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromRGBO(139, 69, 19, 1.0), // Brown color
                ),
              ),
              const SizedBox(height: 16),
              const Text('Please wait...'), // Optional message
            ],
          ),
        );
      },
    );
  }

  // Authentication function using Firebase
  Future<void> _login(
    BuildContext? context,
    String email,
    String password,
  ) async {
    try {
      _showLoadingDialog(context!);
      // Check if context, email, and password are not null
      if (context != null && email.isNotEmpty && password.isNotEmpty) {
        // Sign in with email and password using Firebase Authentication

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pop(context);
        // If authentication is successful, navigate to the home screen or do whatever is needed
        Navigator.pushNamed(context, '/nav');
      } else {
        print('Error: context, email, or password is null or empty');
      }
    } catch (e) {
      // Handle authentication errors
      print('Authentication failed: $e');

      if (context != null) {
        Navigator.pop(context);
        // Show a snackbar or dialog to inform the user about the authentication failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed. Wrong email or password.'),
          ),
        );
      }
    }
  }

  //login screen construct intefaces
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40), // Add margin top here
                child: Image.asset(
                  'assets/app_name.png',
                  width: 150,
                  height: 70,
                ),
              ),
              const Text(
                'Engage with Philippine Literature',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Row(
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              TextFieldWithIcon(
                hintText: 'Email',
                icon: Icons.person,
                height: 45,
                onChanged: (value) {
                  // Store the entered email
                  email = value;
                },
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Row(
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              TextFieldWithIcon(
                hintText: 'Password',
                icon: Icons.lock,
                height: 45,
                obscureText: true, // To hide the entered password
                onChanged: (value) {
                  // Store the entered password
                  password = value;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color.fromRGBO(139, 69, 19, 1.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45, // Make the button full width
                child: ElevatedButton(
                  onPressed: () {
                    // Implement login functionality
                    if (email != null && password != null) {
                      _login(context, email!,
                          password!); // Add ! to assert non-null
                    } else {
                      if (kDebugMode) {
                        print("Error: email or password is null");
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(
                          139, 69, 19, 1.0), // Set button color here
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Set text color here
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Added "or log in with" text centered below the login button

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to sign up screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color.fromRGBO(139, 69, 19, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final double height;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const TextFieldWithIcon({
    Key? key,
    this.hintText,
    this.icon,
    this.height = 50,
    this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(icon, color: const Color.fromRGBO(139, 69, 19, 1.0)),
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const IconContainer({
    required this.icon,
    required this.iconSize,
    this.iconColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Show the back button
        title: const SizedBox.shrink(), // Hide the title
      ),
      body: ForgotPasswordForm(),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter your email address to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45, // Make the button full width
            child: ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  _resetPassword(context, email); // Pass context here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your email.'),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(139, 69, 19, 1.0),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Password reset email sent successfully. Check your email.'),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send password reset email.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
