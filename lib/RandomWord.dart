import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWordsState extends State<RandomWords> {
  final suggestions = <WordPair>[WordPair.random()];
  final biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildSuggestions(),
    );
  }

  Widget buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10));
          }
          return buildRow(suggestions[index]);
        });
  }

  Widget buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: biggerFont,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
