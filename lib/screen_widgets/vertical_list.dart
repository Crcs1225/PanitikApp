import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  List<Literature> literatureList = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchLiteratureData(); // Call the method to fetch literature data
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method to fetch literature data from your database
  void fetchLiteratureData() async {
    List<Literature> fetchedList = [];

    // Fetch data from different tables
    List<Author> authors = await fetchAuthors();
    List<Work> works = await fetchWorks();

    // Combine data from different tables into a unified structure
    for (Work work in works) {
      Author author =
          authors.firstWhere((author) => author.id == work.authorId);
      fetchedList.add(Literature(
        title: work.title,
        authorName: author.name,
        gradeLevel: work.gradeLevel,
        isBookmarked: false, // Set bookmark status as needed
      ));
    }

    setState(() {
      literatureList = fetchedList;
    });
  }

  // Method to fetch authors data from the database
  Future<List<Author>> fetchAuthors() async {
    // Your implementation to fetch authors data
    // For demonstration, return dummy data
    return [
      Author(id: 1, name: 'Author 1'),
      Author(id: 2, name: 'Author 2'),
      // Add more authors as needed
    ];
  }

  // Method to fetch works data from the database
  Future<List<Work>> fetchWorks() async {
    // Your implementation to fetch works data
    // For demonstration, return dummy data
    return [
      Work(title: 'Work 1', authorId: 1, gradeLevel: 'Grade 1'),
      Work(title: 'Work 2', authorId: 2, gradeLevel: 'Grade 2'),
      // Add more works as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? profileImageUrl = user?.photoURL;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 8),
        // Increased height by 8 pixels
        child: AppBar(
          toolbarHeight: kToolbarHeight + 8, // Adjust the toolbarHeight
          actions: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: TextStyle(color: Colors.black),
                              onChanged: (value) {
                                // Handle search functionality here
                                setState(
                                    () {}); // Trigger rebuild to update visibility
                              },
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.all(8), // Padding around the icon
                            child: Visibility(
                                visible: _searchController.text.isNotEmpty,
                                child: GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(
                                        () {}); // Trigger rebuild to update the visibility
                                  },
                                  child: Visibility(
                                    visible: _searchController.text
                                        .isNotEmpty, // Only show the icon if text is not empty
                                    child:
                                        Icon(Icons.clear, color: Colors.grey),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (profileImageUrl != null)
              SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
              )
            else
              IconButton(
                onPressed: () {
                  // Handle tapping on the profile icon when no image is available
                },
                icon: const Icon(Icons.account_circle),
                iconSize: 40,
              ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: literatureList.length,
          itemBuilder: (context, index) {
            return LiteratureCard(literature: literatureList[index]);
          },
        ),
      ),
    );
  }
}

class Literature {
  final String title;
  final String authorName;
  final String gradeLevel;
  final bool isBookmarked;

  Literature({
    required this.title,
    required this.authorName,
    required this.gradeLevel,
    required this.isBookmarked,
  });
}

class Author {
  final int id;
  final String name;

  Author({required this.id, required this.name});
}

class Work {
  final String title;
  final int authorId;
  final String gradeLevel;

  Work({required this.title, required this.authorId, required this.gradeLevel});
}

class LiteratureCard extends StatelessWidget {
  final Literature literature;

  const LiteratureCard({
    Key? key,
    required this.literature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Your card layout goes here
          Text(literature.title),
          Text(literature.authorName),
          Text(literature.gradeLevel),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
