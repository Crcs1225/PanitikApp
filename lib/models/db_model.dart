import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

class Author {
  final int id;
  final String name;
  final String bio;

  Author({required this.id, required this.name, required this.bio});
}

class Work {
  final int id; // Add id property
  final String title;
  final int authorId;
  final int gradeLevel;
  final String videoUrl;
  final Uint8List coverPhoto;
  final Future<Database> dbFuture;

  Work({
    required this.id,
    required this.title,
    required this.authorId,
    required this.gradeLevel,
    required this.videoUrl,
    required this.coverPhoto,
    required this.dbFuture,
  });
}

class Literature {
  final String id;
  final int workId; // Initialize workId
  final String title;
  final String authorName;
  final int gradeLevel;
  final String video_Url;
  final Uint8List coverPhoto;
  bool isBookmarked;

  Literature({
    required this.id,
    required this.workId, // Make sure workId is initialized
    required this.title,
    required this.authorName,
    required this.gradeLevel,
    required this.video_Url,
    required this.coverPhoto,
    this.isBookmarked = false,
  });
}

class UserData {
  final String fullName;
  final int gradeLevel;
  final int age;

  UserData({
    required this.fullName,
    required this.gradeLevel,
    required this.age,
  });
}

class Chapter {
  final int id;
  final String title;
  final String content;
  final Work work; // Reference to the associated Work object

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.work,
    required workId,
  });
}

class Question {
  final int workId;
  final String question;
  final List<String> choices;
  final int correctAnswerIndex;

  Question({
    required this.workId,
    required this.question,
    required this.choices,
    required this.correctAnswerIndex,
  });
}
