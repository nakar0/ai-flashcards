import 'dart:convert';
import 'package:ai_flashcards/config/env.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AI Flashcards'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = '';

  void _setText(String text) {
    setState(() {
      _text = text;
    });
  }

  // request gpt-3 to generate a flashcard
  void _requestGPT() async {
    const endpointUrl = 'https://api.openai.com/v1/completions';
    const apiKey = Env.openAiAPIKey;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };

    Map<String, dynamic> data = {
      'prompt': 'Hello, can you help me with my homework?',
      'temperature': 0.7,
      'model': "text-davinci-002",
      'max_tokens': 50,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0
    };
    final response = await http.post(Uri.parse(endpointUrl),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final chatResponse = jsonResponse['choices'][0]['text'].toString();
      _setText(chatResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _requestGPT,
        tooltip: 'Request',
        child: const Icon(Icons.air),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
