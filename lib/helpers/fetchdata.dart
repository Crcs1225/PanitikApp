import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/db_model.dart';

import 'package:collection/collection.dart'; // Import the collection package for firstWhereOrNull

class DataFetcher {
  final Future<Database> _dbFuture;

  DataFetcher(
      this._dbFuture); // Modify the constructor to accept a Future<Database>

  Future<List<Author>> fetchAuthors() async {
    final Database db = await _dbFuture; // Wait for the future to complete
    final List<Map<String, dynamic>> authorMaps = await db.query('Authors');
    return List.generate(authorMaps.length, (i) {
      return Author(
        id: authorMaps[i]['author_id'],
        name: authorMaps[i]['author_name'],
        bio: authorMaps[i]['bio'],
      );
    });
  }

  Future<List<Work>> fetchWorks() async {
    final Database db = await _dbFuture;
    final List<Map<String, dynamic>> workMaps = await db.query('Works');
    return List.generate(workMaps.length, (i) {
      Uint8List coverPhoto = workMaps[i]['cover_photo'];
      return Work(
        title: workMaps[i]['title'],
        authorId: workMaps[i]['author_id'],
        gradeLevel: workMaps[i]['grade_level'],
        videoUrl: workMaps[i]['video_url'],
        coverPhoto: coverPhoto,
        id: workMaps[i]['work_id'], // Use the actual work ID from the database
        dbFuture: _dbFuture, // Pass the _dbFuture when creating Work object
      );
    });
  }

  Future<List<Literature>> fetchLiteratureData(String userId) async {
    final List<Author> authors = await fetchAuthors();
    final List<Work> works = await fetchWorks();

    List<Literature> literatureList = [];
    for (final work in works) {
      Author? author =
          authors.firstWhereOrNull((author) => author.id == work.authorId);
      if (author != null) {
        // Generate a unique id for each literature
        String id = generateUniqueId(); // You need to implement this function

        // Fetch bookmark status for the current user
        bool isBookmarked = await isLiteratureBookmarked(userId, id);

        literatureList.add(
          Literature(
            id: id,
            title: work.title,
            authorName: author.name,
            gradeLevel: work.gradeLevel,
            coverPhoto: work.coverPhoto,
            isBookmarked: isBookmarked,
            workId: work.id,
            video_Url: work.videoUrl,
          ),
        );
      }
    }

    return literatureList;
  }

  Future<bool> isLiteratureBookmarked(
      String userId, String literatureId) async {
    final Database db = await _dbFuture;
    List<Map<String, dynamic>> result = await db.query(
      'user_bookmarks',
      columns: ['user_id'],
      where: 'user_id = ? AND work_id = ?',
      whereArgs: [userId, literatureId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  static String generateUniqueId() {
    // Use the v4 method of the Uuid class to generate a random UUID
    return Uuid().v4();
  }

  Future<Literature?> fetchDataFromDatabase(String id) async {
    final Database db = await _dbFuture;
    // Perform query to fetch updated literature data
    List<Map<String, dynamic>> literatureMaps =
        await db.query('Literature', where: 'id = ?', whereArgs: [id]);

    // Check if any data is retrieved
    if (literatureMaps.isEmpty) {
      return null; // Return null if no data is found
    }

    // Map the retrieved data to a Literature object
    return Literature(
      id: literatureMaps[0]['id'],
      workId: literatureMaps[0]
          ['work_id'], // Assign the work ID from the database
      title: literatureMaps[0]['title'],
      authorName: literatureMaps[0]['author_name'],
      gradeLevel: literatureMaps[0]['grade_level'],
      coverPhoto: literatureMaps[0]['cover_photo'],
      isBookmarked: literatureMaps[0]['is_bookmarked'] == 1,
      video_Url: literatureMaps[0]['video_url'],
    );
  }

  Future<List<Chapter>> fetchChaptersByWorkId(
      int workId, Future<Database> dbFuture) async {
    final Database db = await dbFuture;

    // Fetch the list of works
    List<Work> works = await fetchWorks();
    if (works.isEmpty) {
      print('No works found.'); // Print message when no works are found
      return []; // Return an empty list since there are no works
    }

    // Find the corresponding Work object for the given workId
    Work? work = works.firstWhereOrNull((work) => work.id == workId);
    if (work == null) {
      print('No work found with ID $workId.');
      return []; // Return an empty list since no work with the given ID was found
    }

    // Query chapters for the given workId
    List<Map<String, dynamic>> chapterMaps = await db.query(
      'Chapters',
      where: 'work_id = ?',
      whereArgs: [workId],
    );

    // Print the fetched chapters
    print('Chapters fetched:');
    for (var chapterMap in chapterMaps) {
      print(
          'Chapter ID: ${chapterMap['chapter_id']}, Title: ${chapterMap['title']}');
    }

    return List.generate(chapterMaps.length, (i) {
      return Chapter(
        id: chapterMaps[i]['chapter_id'],
        title: chapterMaps[i]['title'],
        content: chapterMaps[i]['content'],
        work: work, // Assign the corresponding Work object
        workId: workId, // Assign the workId directly as well
      );
    });
  }
}
