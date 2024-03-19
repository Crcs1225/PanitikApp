import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../helpers/fetchdata.dart';
import '../models/db_model.dart';

import '../utils/picturegetter.dart';
import 'read.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  List<Literature> literatureList = [];
  late DatabaseHelper _databaseHelper;
  bool _isDataFetched = false;
  String? _profileImageUrl;
  late Future<Database> _dbFuture;
  List<Literature> filteredLiteratureList = [];
  late FocusNode _searchFocusNode;
  late DataFetcher _dataFetcher; // Add DataFetcher instance

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _databaseHelper = DatabaseHelper(); // Instantiate DatabaseHelper

    loadProfilePicture();
    _dbFuture = _initializeDatabase();
    _searchFocusNode = FocusNode();
    _dataFetcher = DataFetcher(_dbFuture); // Instantiate DataFetcher
    _loadData();
    _fetchBookmarkStatus(); // Call fetchBookmarkStatus here
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await fetchAndSetLiteratureData();
  }

  Future<void> _fetchBookmarkStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      for (final literature in literatureList) {
        final isBookmarked = await DatabaseHelper.instance
            .isBookmarked(userId, literature.id as int);
        setState(() {
          literature.isBookmarked = isBookmarked;
        });
      }
    }
  }

  Future<Database> _initializeDatabase() async {
    return await DatabaseHelper.instance.db;
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

  Future<void> fetchAndSetLiteratureData() async {
    final user = FirebaseAuth.instance.currentUser;
    String userId = ''; // Default value

    if (user != null) {
      userId = user.uid;
    }

    try {
      // Fetch literature data using DataFetcher
      final fetchedList = await _dataFetcher.fetchLiteratureData(userId);

      setState(() {
        literatureList = fetchedList;
        _isDataFetched = true;
      });
    } catch (error) {
      // Handle errors
      print('Error fetching literature data: $error');
    }
  }

  void searchLiterature(String searchText) {
    setState(() {
      filteredLiteratureList = literatureList
          .where((literature) =>
              literature.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImageUrl = _profileImageUrl;

    // Choose the list based on whether there is a search query or not
    List<Literature> displayedList = _searchController.text.isEmpty
        ? literatureList
        : filteredLiteratureList;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 8),
        child: Container(
          color: Colors.white,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: kToolbarHeight + 8,
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
                                  searchLiterature(value);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Visibility(
                                visible: _searchController.text.isNotEmpty,
                                child: GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  child: Visibility(
                                    visible: _searchController.text.isNotEmpty,
                                    child:
                                        Icon(Icons.clear, color: Colors.grey),
                                  ),
                                ),
                              ),
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
                    backgroundImage: NetworkImage(_profileImageUrl!),
                  ),
                )
              else
                Icon(Icons.account_circle, size: 40),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _isDataFetched
            ? GestureDetector(
                onTap: () {
                  // When the user taps outside the text field, unfocus it
                  _searchFocusNode.unfocus();
                },
                child: ListView.builder(
                  itemCount: displayedList.length,
                  itemBuilder: (context, index) {
                    return LiteratureCard(
                      literature: displayedList[index],
                      updateBookmarkStatus: updateBookmarkStatus,
                      dbFuture: _dbFuture,
                    );
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<bool> isLiteratureBookmarked(
      String userId, String literatureId) async {
    try {
      final db = await _databaseHelper.db;
      final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM user_bookmarks
      WHERE user_id = ? AND work_id = ?
    ''', [userId, literatureId]);
      final isBookmarked = result.isNotEmpty && (result[0]['count'] as int) > 0;
      print('Bookmark status for literature ID $literatureId: $isBookmarked');
      return isBookmarked;
    } catch (error) {
      print('Error checking bookmark status: $error');
      return false;
    }
  }

  Future<void> updateBookmarkStatus(
      String literatureId, bool newBookmarkStatus) async {
    print('Updating bookmark status for literature ID: $literatureId');

    final userId = await getCurrentUserIdFromDB();
    if (userId != null) {
      final updatedLiterature = literatureList
          .firstWhere((literature) => literature.id == literatureId);
      setState(() {
        updatedLiterature.isBookmarked = newBookmarkStatus;
      });

      print('Bookmark status updated successfully.');
      print(
          'New bookmark status for literature ID $literatureId: $newBookmarkStatus');

      // Update the bookmark status in the database
      await DatabaseHelper.instance.updateBookmarkStatus(
        userId,
        literatureId,
        newBookmarkStatus,
      );
    } else {
      print('Failed to get current user ID.');
    }
  }

  Future<String?> getCurrentUserIdFromDB() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userData.exists) {
          return userData.id;
        } else {
          print('User data document does not exist.');
          return null;
        }
      } catch (error) {
        print('Error getting current user ID from Firestore: $error');
        return null;
      }
    } else {
      print('Failed to get current user ID.');
      return null;
    }
  }
}

class LiteratureCard extends StatelessWidget {
  final Literature literature;
  final Function(String, bool) updateBookmarkStatus;
  final Future<Database> dbFuture;

  const LiteratureCard({
    Key? key,
    required this.literature,
    required this.updateBookmarkStatus,
    required this.dbFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiteratureDetailScreen(
              literature: literature,
              dbFuture: dbFuture,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.memory(
                literature.coverPhoto,
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    literature.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'by ${literature.authorName}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      SizedBox(width: 4),
                      Text(
                        'Grade  ${literature.gradeLevel}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        icon: Icon(
                          literature.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: literature.isBookmarked
                              ? Color.fromRGBO(139, 69, 19, 1.0) // Brown color
                              : Colors.black, // Default color
                        ),
                        onPressed: () async {
                          final newBookmarkStatus = !literature.isBookmarked;
                          print(
                              'Bookmark icon pressed for literature ID: ${literature.id}');
                          print(
                              'New bookmark status for literature ID ${literature.id}: $newBookmarkStatus');
                          updateBookmarkStatus(
                            literature.id,
                            newBookmarkStatus,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
