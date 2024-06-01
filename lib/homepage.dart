import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.isLandlord});
  final int isLandlord;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _fileName;
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  bool _userAborted = false;
  String _uploadStatus = '';
  String finalResult = '';

  void _pickFiles() async {
    setState(() => _isLoading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        _selectedFile = result.files.single;
        _fileName = _selectedFile?.name;
      } else {
        _userAborted = true;
      }
    } on Exception catch (e) {
      print('File picking error: $e');
      setState(() => _userAborted = true);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'post',
        Uri.parse('http://192.168.0.49:8000/ocr'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'image_file',
          _selectedFile!.bytes!,
          filename: _selectedFile!.name,
        ),
      );
      request.fields['is_landlord'] = widget.isLandlord.toString();
      var response = await request.send();

      if (response.statusCode == 200) {
        var stream = response.stream;

        // 바이트를 저장할 List<int>를 생성합니다.
        List<int> bytes = <int>[];

        // 스트림에서 바이트를 읽어와 리스트에 추가합니다.
        await for (var chunk in stream) {
          bytes.addAll(chunk);
        }
        setState(() {
          _uploadStatus = 'File uploaded successfully';
          //finalResult = response.toString();

          // 바이트 리스트를 문자열로 변환합니다.
          finalResult = utf8.decode(bytes);
        });
      } else {
        setState(() {
          _uploadStatus = 'File upload failed: ${response.statusCode}';
          finalResult = "오류";
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'File upload failed: $e';
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Selected file: $_fileName'),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _pickFiles(),
                        child: const Text('Pick File'),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectedFile == null ? null : () => _uploadFile(),
                  child: const Text('AI 안심거래 확인'),
                ),
                const SizedBox(height: 20),
                Text(_uploadStatus),
                Text(finalResult),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
