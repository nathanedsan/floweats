import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FaceDetectPage extends StatefulWidget {
  @override
  _FaceDetectPageState createState() => _FaceDetectPageState();
}

class _FaceDetectPageState extends State<FaceDetectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detect'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _runPythonScript,
          child: Text('Face Detect'),
        ),
      ),
    );
  }

  Future<void> _runPythonScript() async {
    try {
      final ByteData data = await rootBundle.load('assets/face_detection.py');
      final List<int> bytes = data.buffer.asUint8List();
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/face_detection.py';
      await File(tempPath).writeAsBytes(bytes);

      ProcessResult result = await Process.run('python', [tempPath]);

      print('Exit code: ${result.exitCode}');
      print('Stdout: ${result.stdout}');
      print('Stderr: ${result.stderr}');
    } catch (e) {
      print('Error running Python script: $e');
    }
  }
}
