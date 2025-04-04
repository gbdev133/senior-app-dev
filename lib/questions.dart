class Question {
  final int correctAnswerIndex;
  final List<String> options;
  final String question, songURL;
  Question({required this.question, required this.options, required this.correctAnswerIndex, required this.songURL});
}