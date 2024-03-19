import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_initial_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static DatabaseHelper get instance => _instance;

  static Database? _db;

  DatabaseHelper._internal();
  static bool _isInitialized = false; // Flag to track initialization

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    // Get the device's databases directory
    String databasesPath = await getDatabasesPath();
    // Construct the path for the database file
    String path = join(databasesPath, 'my_database.db');

    // Check if the database file exists
    bool databaseExists = await databaseFactory.databaseExists(path);

    // Open the database
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    if (!databaseExists) {
      // Insert initial data only if the database is newly created
      await _insertInitialData(db);
    }

    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    // Create the tables
    await db.execute('''
        CREATE TABLE IF NOT EXISTS Authors (
          author_id INTEGER PRIMARY KEY,
          author_name TEXT,
          bio TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS Works (
          work_id INTEGER PRIMARY KEY,
          title TEXT,
          author_id INTEGER,
          cover_photo BLOB,
          grade_level INTEGER,
          video_url TEXT,
          FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        )
      ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS Chapters (
          chapter_id INTEGER PRIMARY KEY,
          title TEXT,
          content TEXT,
          work_id INTEGER,
          FOREIGN KEY (work_id) REFERENCES Works(work_id)
        )
      ''');
    await db.execute('''CREATE TABLE IF NOT EXISTS user_bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    work_id TEXT,
    is_bookmarked INTEGER DEFAULT 0,
    bookmarked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (work_id) REFERENCES Works(work_id)
)
''');
    await db.execute('''
      CREATE TABLE users(
        user_id TEXT,
        fullName TEXT,
        email TEXT,
        age INTEGER,
        gradeLevel INTEGER,
        schoolName TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE Literature(
        id TEXT PRIMARY KEY,
        title TEXT,
        authorName TEXT,
        gradeLevel INTEGER,
        video_url TEXT,
        coverPhoto BLOB,
        is_bookmarked INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int?> getCurrentUserId() async {
    try {
      // Get the current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Query the local database to find the user by email (assuming email is unique)
        Database db = await instance.db;
        List<Map<String, dynamic>> result = await db.query(
          'users',
          columns: ['user_id'],
          where: 'email = ?',
          whereArgs: [user.email],
          limit: 1,
        );

        // If the user is found, return the user ID
        if (result.isNotEmpty) {
          return result[0]['user_id'] as int?;
        }
      }
    } catch (error) {
      // Handle errors
      print('Error getting current user ID: $error');
    }

    return null; // Return null if user is not found or if an error occurs
  }

  Future<void> addBookmark(int userId, int workId) async {
    Database db = await instance.db;

    try {
      await db.insert(
        'user_bookmarks',
        {'user_id': userId, 'work_id': workId},
        conflictAlgorithm:
            ConflictAlgorithm.ignore, // Ignore if already bookmarked
      );
    } catch (error) {
      print('Error adding bookmark: $error');
    }
  }

  Future<void> removeBookmark(int userId, int workId) async {
    Database db = await instance.db;

    try {
      await db.delete(
        'user_bookmarks',
        where: 'user_id = ? AND work_id = ?',
        whereArgs: [userId, workId],
      );
    } catch (error) {
      print('Error removing bookmark: $error');
    }
  }

  Future<void> updateBookmarkStatus(
      String userId, String literatureId, bool newBookmarkStatus) async {
    try {
      final db = await instance.db;
      await db.update(
        'Literature',
        {'is_bookmarked': newBookmarkStatus ? 1 : 0},
        where: 'id = ?',
        whereArgs: [literatureId],
      );
      print(
          'Bookmark status updated successfully for literature ID: $literatureId');
    } catch (error) {
      print('Error updating bookmark status: $error');
    }
  }

  Future<bool> isBookmarked(String userId, int workId) async {
    Database db = await instance.db;

    try {
      List<Map<String, dynamic>> result = await db.query(
        'user_bookmarks',
        where: 'user_id = ? AND work_id = ?',
        whereArgs: [userId, workId],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (error) {
      print('Error checking bookmark status: $error');
      return false;
    }
  }

  Future<void> _insertInitialData(Database db) async {
    await DatabaseInitialData.insertAuthors(db);
    await DatabaseInitialData.insertWorks(db);
    await DatabaseInitialData.insertChapters(db);
  }

  Future<void> _saveInitializationFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isInitialized', _isInitialized);
  }

  Future<void> _loadInitializationFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isInitialized = prefs.getBool('isInitialized') ?? false;
  }
}
