import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/chatbot.dart';
import '../screen_widgets/loding_message.dart';
import '../utils/picturegetter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController promptController;
  String responseText = '';
  late SpeechToText _speechToText;
  bool _speechEnabled = false;
  bool isListening = false;
  bool _isSpeechInitialized = false;
  String _lastWords = '';
  bool _speechUsed = false;
  Map? _currentVoice;
  double _confidence = 0;
  List<Message> messages = [];
  bool isLoading = false;
  String? _profileImageUrl;
  double _fontSize = 16.0;

  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController();
    _speechToText = SpeechToText();
    _initSpeech();
    _initTTS();
    loadProfilePicture();
  }

  void _initTTS() {
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> _voices = List<Map>.from(data);
        _voices =
            _voices.where((_voice) => _voice["name"].contains("en")).toList();
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

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      setState(() {
        _isSpeechInitialized = true; // Update the initialization status
      });
    } catch (e) {
      // Handle initialization error
      print('Speech recognition initialization failed: $e');
    }
  }

  Future<void> startListening() async {
    if (!_isSpeechInitialized) {
      print('Speech recognition not initialized');
      return;
    }
    await _speechToText.listen(onResult: _onSpeechResult);
    _flutterTts.stop();
    setState(() {
      isListening = true;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "${result.recognizedWords}";
      _confidence = result.confidence;
    });
  }

  Future<void> _stopListening() async {
    if (!_isSpeechInitialized) {
      print('Speech recognition not initialized');
      return;
    }
    await _speechToText.stop();
    if (_speechToText.isNotListening && _confidence > 0) {
      print("confidence :  ${(_confidence * 100).toStringAsFixed(1)}%");
    }
    setState(() {
      isListening = false;
      promptController.text = _lastWords;
      _speechUsed = true;
      _confidence = 0;
    });
    print(_lastWords);
    completionFun();
    // Process the recognized words
    promptController.clear(); // Clear the prompt controller
  }

  @override
  void dispose() {
    promptController.dispose();
    _flutterTts.stop();
    super.dispose();
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

  Future<void> completionFun() async {
    // Print the text from the promptController for debugging
    print('Sending message: ${promptController.text}');
    String inputText = promptController.text;
    if (inputText.isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: inputText,
          isUserMessage: true,
        ));
        // Set the loading flag
        messages.add(Message(
          text:
              '', // You can leave this empty as it will represent the loading animation
          isUserMessage: false,
          isLoading: true,
        ));
      });
    }
    try {
      final geminiResponse = await Gemini.instance.text(inputText);
      String responseText = geminiResponse?.output ?? 'No response';
      setState(() {
        // Remove the loading message and add the response message
        messages.removeWhere((message) => message.isLoading);
        messages.add(Message(
          text: responseText,
          isUserMessage: false,
        ));
      });
      // Speak the response text if stt is used
      if (_speechUsed == true) {
        _flutterTts.speak(responseText);
        _speechUsed = false;
      }
    } catch (e) {
      setState(() => messages.add(Message(
            text: 'Error occurred',
            isUserMessage: false,
          )));
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(
            'assets/app_name.png', // Replace 'your_image.png' with the path to your image asset
            fit: BoxFit.contain, // Adjust the fit as needed
            width: 120, // Adjust the width as needed
            height: AppBar()
                .preferredSize
                .height, // Match the height of the app bar
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  text: messages[index].text,
                  isUserMessage: messages[index].isUserMessage,
                  isLoading: messages[index].isLoading,
                  profileImageUrl: _profileImageUrl,
                  fontSize: _fontSize,
                );
              },
            ),
          ),
          TextFormFieldBldr(
            promptController: promptController,
            startListening: startListening,
            completionFun: completionFun,
            speechEnabled: _speechEnabled,
            isListening: isListening,
            stopListening: _stopListening,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatefulWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isUserMessage,
    required this.isLoading,
    required this.profileImageUrl,
    required this.fontSize,
  }) : super(key: key);

  final String text;
  final bool isUserMessage;
  final bool isLoading;
  final String? profileImageUrl;
  final double fontSize;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: widget.isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUserMessage)
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 24,
              child: Icon(Icons.computer_rounded,
                  color: Color.fromRGBO(139, 69, 19, 1.0)),
            ),
          if (!widget.isUserMessage) SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isUserMessage
                    ? Color.fromRGBO(139, 69, 19, 1.0)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft:
                      widget.isUserMessage ? Radius.circular(16) : Radius.zero,
                  bottomRight:
                      widget.isUserMessage ? Radius.zero : Radius.circular(16),
                ),
              ),
              child: widget.isLoading
                  ? LoadingDots()
                  : Text(
                      widget.text,
                      style: TextStyle(
                        color:
                            widget.isUserMessage ? Colors.white : Colors.black,
                        fontSize: widget.fontSize,
                      ),
                    ),
            ),
          ),
          if (widget.isUserMessage) SizedBox(width: 8),
          if (widget.isUserMessage && widget.profileImageUrl != null)
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(widget.profileImageUrl!),
            ),
        ],
      ),
    );
  }
}

class PromptBldr extends StatelessWidget {
  const PromptBldr({Key? key, required this.responseText}) : super(key: key);

  final String responseText;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.35,
        color: Colors.white,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Text(
                responseText,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormFieldBldr extends StatefulWidget {
  const TextFormFieldBldr({
    Key? key,
    required this.promptController,
    required this.startListening,
    required this.completionFun,
    required this.speechEnabled,
    required this.isListening,
    required this.stopListening,
  }) : super(key: key);

  final TextEditingController promptController;
  final VoidCallback startListening;
  final VoidCallback completionFun;
  final bool speechEnabled;
  final bool isListening;
  final VoidCallback stopListening;

  @override
  _TextFormFieldBldrState createState() => _TextFormFieldBldrState();
}

class _TextFormFieldBldrState extends State<TextFormFieldBldr> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    // Update the isTyping state based on whether text is entered
                    isTyping = value.isNotEmpty;
                  });
                },
                cursorColor: Colors.black,
                controller: widget.promptController,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(139, 69, 19, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(139, 69, 19, 1.0),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Ask Me Anything',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(
                    top: 20.0,
                    bottom: 20,
                    left: 30.0,
                  ),
                  suffixIcon: Visibility(
                    visible: !isTyping && widget.promptController.text.isEmpty,
                    child: IconButton(
                      onPressed: widget.isListening
                          ? widget.stopListening
                          : widget.startListening,
                      icon: Icon(
                        widget.isListening ? Icons.stop : Icons.mic,
                        color: Color.fromRGBO(139, 69, 19, 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            ClipOval(
              child: Container(
                width:
                    70.0, // Adjust the width and height as needed to make it circular
                height: 70.0,
                color: Color.fromRGBO(139, 69, 19, 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    onPressed: () {
                      if (isTyping && widget.promptController.text.isNotEmpty) {
                        // If the user is typing and there's text in the controller, send the message
                        print('Sending message...');
                        widget.completionFun();
                        widget.promptController.clear();
                        setState(() {
                          isTyping = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
