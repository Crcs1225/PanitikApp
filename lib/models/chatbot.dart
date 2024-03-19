class Message {
  final String text;
  final bool isUserMessage; // Indicates if the message is sent by the user
  final bool isLoading;
  Message({
    required this.text,
    required this.isUserMessage,
    this.isLoading = false,
  });
}
