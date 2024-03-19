import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  final double mrgn = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(mrgn),
                padding: EdgeInsets.all(mrgn),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(139, 69, 19, 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/app_icon.png',
                        width: 90,
                        height: 90,
                      ),
                      Image.asset(
                        'assets/white_name.png',
                        width: 90,
                        height: 40,
                      ),
                    ]),
              ),
              Text(
                'Version: 1.0.0',
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: 500,
                width: 380,
                child: PageView(
                  children: [
                    CustomContainer(
                      title: 'The App',
                      description:
                          'Introducing our conversational AI application, designed to immerse children in the rich world of Philippine Literature. Our app fosters engagement and learning by providing an interactive platform where children can explore and interact with various aspects of Philippine literature in a fun and educational way. With a focus on conversation, our app brings stories to life, encourages curiosity, and ignites a love for literature among young learners.',
                    ),
                    CustomContainer(
                      title: 'Third Party Softwares',
                      description:
                          'Panitik for android is build using open source software: \n     1. Flutter Framework\n     2. Sqlite\n    3. Firebase\n     4. Gemini Api\n    5. Dart Programming Language\n     6. Figma',
                    ),
                    CustomContainer(
                      title: 'About Us',
                      description:
                          "We are a group of third-year Computer Science students enrolled at Pangasinan State University for the school year 2023-2024. This application is a culmination of our efforts as part of our project requirements for the Software Engineering 2 subject. Our team is passionate about leveraging technology to create engaging solutions, and we're excited to present this conversational AI application aimed at fostering an appreciation for Philippine literature among children.",
                    ),
                    // Add more CustomContainers as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String title;
  final String description;

  const CustomContainer({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromRGBO(139, 69, 19, 1.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
