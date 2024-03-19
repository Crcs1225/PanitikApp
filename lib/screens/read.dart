import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panitik/screens/chat.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/fetchdata.dart';
import '../models/db_model.dart';
import 'quiz.dart';
import 'dart:async';

import 'trailer.dart';

class LiteratureDetailScreen extends StatefulWidget {
  final Literature literature;
  final Future<Database> dbFuture;

  const LiteratureDetailScreen({
    Key? key,
    required this.literature,
    required this.dbFuture,
  }) : super(key: key);

  @override
  State<LiteratureDetailScreen> createState() => _LiteratureDetailScreenState();
}

class _LiteratureDetailScreenState extends State<LiteratureDetailScreen> {
  late int workId = workId; // Define workId property
  late Future<Database> dbFuture;
  bool _isDataFetched = false;
  bool _isPlaying = false;
  FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;
  late List<Chapter> _chapters = [];
  late Completer<void> _textToSpeechCompleter;

  @override
  void initState() {
    super.initState();
    // Assign the dbFuture from the widget to the state's dbFuture property
    dbFuture = widget.dbFuture;
    _textToSpeechCompleter = Completer<void>();

    fetchData(); // Fetch work ID when the screen initializes
    // Fetch work ID when the screen initializes
    initTTS();
  }

  @override
  void dispose() {
    super.dispose();
    // If you have any resources to clean up, such as closing streams or cancelling futures,
    // you can do it here.
    _flutterTts.stop();
    if (!_textToSpeechCompleter.isCompleted) {
      _textToSpeechCompleter
          .complete(); // Complete the future if it's not completed yet
    }
  }

  void initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> _voices = List<Map>.from(data);
        _voices =
            _voices.where((_voice) => _voice["name"].contains("fil")).toList();
        setState(() {
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  Future<void> startTextToSpeech() async {
    if (_isDataFetched) {
      for (var chapter in _chapters) {
        // Speak the content and wait for completion
        await _flutterTts.speak(chapter.content);
        print("content: ${chapter.content}");

        // Wait for the speech to complete
        await _flutterTts.awaitSpeakCompletion(true);

        // Check if the text-to-speech operation should be canceled
        if (_textToSpeechCompleter.isCompleted) {
          break;
        }

        // Add a delay before speaking the next content
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  void stopTextToSpeech() {
    _flutterTts.pause();
    if (!_textToSpeechCompleter.isCompleted) {
      _textToSpeechCompleter
          .complete(); // Complete the future if it's not completed yet
    }
  }

  Future<void> fetchData() async {
    if (_isDataFetched) return;
    // Initialize DataFetcher with the dbFuture
    DataFetcher dataFetcher = DataFetcher(widget.dbFuture);

    // Fetch the list of works from the database
    List<Work> works = await dataFetcher.fetchWorks();

    // Find the work that matches the literature's ID
    Work? matchingWork =
        works.firstWhereOrNull((work) => work.id == widget.literature.workId);

    _chapters = await dataFetcher.fetchChaptersByWorkId(
        widget.literature.workId, widget.dbFuture);

    if (matchingWork != null) {
      setState(() {
        workId = matchingWork.id;
        _isDataFetched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back action here
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              // Add your quiz action here
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizScreen(
                          workId: workId,
                        )),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              // Add your chatbot action here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookInfo(
              literature: widget.literature,
            ),
            SizedBox(
                height: 20), // Add some spacing between BookInfo and BookPage
            _isDataFetched
                ? BookPage(
                    workId: workId,
                    dbFuture: dbFuture,
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isPlaying = !_isPlaying; // Toggle play/pause
            if (_isPlaying) {
              // If playing, start text-to-speech
              startTextToSpeech();
            } else {
              // If paused, stop text-to-speech
              stopTextToSpeech();
            }
          });
        },
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BookInfo extends StatelessWidget {
  final Literature literature;

  const BookInfo({Key? key, required this.literature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 125,
            height: 175,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Image.memory(
              literature.coverPhoto,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  literature.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Author: ${literature.authorName}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    // Background color container
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white, // Set background color to white
                      ),
                      child: Text(
                        'Grade: ' + literature.gradeLevel.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(139, 69, 19, 1.0), // Text color
                        ),
                      ),
                    ),
                    // Border container
                    Positioned.fill(
                      child: Container(
                        padding: EdgeInsets.all(2), // Adjust border width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromRGBO(
                                139, 69, 19, 1.0), // Border color
                            width: 2, // Border width
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Your onPressed function here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayTrailerScreen(
                                    videoUrl: literature.video_Url,
                                  )),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(139, 69, 19, 1.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.play,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Watch Trailer',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookPage extends StatefulWidget {
  final int workId;
  final Future<Database> dbFuture;

  const BookPage({
    Key? key,
    required this.workId,
    required this.dbFuture,
  }) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final ScrollController _controller = ScrollController();
  List<Chapter> _chapters = [];
  bool _isDataFetched = false;
  double _fontSize = 16; // Initial font size

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (_isDataFetched) return;
    DataFetcher dataFetcher = DataFetcher(widget.dbFuture);
    List<Chapter> chapters =
        await dataFetcher.fetchChaptersByWorkId(widget.workId, widget.dbFuture);

    setState(() {
      _chapters = chapters;
      _isDataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        // ScaleFactor represents the zoom level, you can adjust the sensitivity
        setState(() {
          _fontSize *= details.scale;
          if (_fontSize < 12) {
            _fontSize = 12; // Minimum font size
          }
          if (_fontSize > 24) {
            _fontSize = 24; // Maximum font size
          }
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(139, 69, 19, 1.0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                items: _chapters
                    .map((chapter) => DropdownMenuItem(
                          value: chapter.id.toString(),
                          child: Text(chapter.title),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    int chapterIndex = _chapters.indexWhere(
                        (chapter) => chapter.id.toString() == value);
                    if (chapterIndex != -1) {
                      scrollToChapter(chapterIndex);
                    }
                  }
                },
                hint: Text(
                  'Select Chapter',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                underline: SizedBox(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _chapters[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _chapters[index].content,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: _fontSize,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToChapter(int chapterIndex) {
    if (chapterIndex >= 0 && chapterIndex < _chapters.length) {
      double scrollToPosition =
          chapterIndex * 500; // Adjust the scroll position as needed
      _controller.animateTo(
        scrollToPosition,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
