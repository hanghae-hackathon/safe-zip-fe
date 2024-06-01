import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FilePickerPage(),
    );
  }
}

class FilePickerPage extends StatefulWidget {
  const FilePickerPage({super.key});

  @override
  _FilePickerPageState createState() => _FilePickerPageState();
}

class _FilePickerPageState extends State<FilePickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.house),
              Padding(padding: EdgeInsets.all(10)),
              Text('Safe.zip - 당신의 안전한 집'),
            ],
          ),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 255, 135, 127), // 배경 색상
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0), // 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17.0, // 글자 크기
                      fontWeight: FontWeight.bold, // 글자 굵기
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(
                          isLandlord: 0,
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text('임차인'),
                  )),
              const Padding(padding: EdgeInsets.all(50)),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color.fromARGB(255, 255, 135, 127), // 배경 색상
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0), // 패딩
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17.0, // 글자 크기
                      fontWeight: FontWeight.bold, // 글자 굵기
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(
                          isLandlord: 1,
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text('임대인'),
                  )),
            ],
          ),
        ));
  }
}
