// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:watcher/watcher.dart';
//
// class CallRecorderApp extends StatefulWidget {
//   @override
//   _CallRecorderAppState createState() => _CallRecorderAppState();
// }
//
// class _CallRecorderAppState extends State<CallRecorderApp> {
//   List<FileSystemEntity> recordedFiles = [];
//   StreamSubscription<WatchEvent>? _fileWatcherSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _getRecordedFiles();
//     _startFileWatcher();
//   }
//
//   @override
//   void dispose() {
//     _fileWatcherSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _getRecordedFiles() async {
//     try {
//       Directory? appDirectory = await getExternalStorageDirectory();
//       print('appDirectory $appDirectory');
//       String recordingsPath = '/storage/emulated/0/Android/data/com.example.call_recordered/files';
//       Directory recordingsDirectory = Directory(recordingsPath);
//       print('=================+++++++++++==========');
//       print('recordingsDirectory ===== $recordingsDirectory');
//       if (await recordingsDirectory.exists()) {
//         setState(() {
//           recordedFiles = recordingsDirectory.listSync().toList();
//           print('===========================');
//           print('recordedFiles $recordedFiles');
//         });
//       }
//     } catch (e) {
//       print("Error reading recorded files: $e");
//     }
//   }
//
//   Future<void> _startFileWatcher() async {
//     Directory? appDirectory = await getExternalStorageDirectory();
//     String recordingsPath = '${appDirectory?.path}/Recordings';
//     Directory recordingsDirectory = Directory(recordingsPath);
//
//     _fileWatcherSubscription = Watcher(recordingsDirectory.path)
//         .events
//         .listen((WatchEvent event) {
//           print('event $event');
//       if (event.type == ChangeType.ADD || event.type == ChangeType.REMOVE) {
//         _getRecordedFiles();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Call Recorder App',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Call Recorder App'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.phone),
//               onPressed: () {
//                 _launchPhoneDialer();
//               },
//             ),
//           ],
//         ),
//         body: ListView.builder(
//           itemCount: recordedFiles.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(recordedFiles[index].path.split('/').last),
//               onTap: () {
//                 // Implement action to play or view the recorded file
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _launchPhoneDialer() async {
//     const phoneNumber = '9025075398'; // Enter your phone number here
//     final url = 'tel:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
//
// void main() {
//   runApp(CallRecorderApp());
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RecordedFilesPage(),
    );
  }
}

class RecordedFilesPage extends StatefulWidget {
  const RecordedFilesPage({super.key});

  @override
  _RecordedFilesPageState createState() => _RecordedFilesPageState();
}

class _RecordedFilesPageState extends State<RecordedFilesPage> {
  List<FileSystemEntity> _recordedFiles = [];

  @override
  void initState() {
    super.initState();

    _checkPermission();
  }

  Future<void> _checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      _findRecordedFiles();
    }
  }

  Future<void> _findRecordedFiles() async {
    try {
      // Get the external storage directory
      Directory? externalDir = await getExternalStorageDirectory();
      print('++++++++++++++++');
      print(externalDir);
      print('++++++++++++++++');

      if (externalDir != null) {
        // List files in the external storage directory
        Directory? testDir = Directory('/storage/emulated/0');
        List<FileSystemEntity> files = testDir.listSync(recursive: true);
        print('==================');
        print(files);
        print('==================');
        _recordedFiles = files
            .where((file) =>
                file.path.endsWith('.amr') ||
                file.path.endsWith('.wav') ||
                file.path.endsWith('.mp3'))
            .toList();
        print('=========++++++++++==========');
        print(_recordedFiles);
        print('========+++++++++===========');
        setState(() {});
      }
    } catch (e) {
      print('--------------------');
      print('Error finding recorded files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Files'),
      ),
      body: _recordedFiles.isEmpty
          ? const Center(child: Text('No recorded files found'))
          : ListView.builder(
              itemCount: _recordedFiles.length,
              itemBuilder: (context, index) {
                String fileName = _recordedFiles[index].path.split('/').last;
                return ListTile(
                  title: Text(fileName),
                );
              },
            ),
    );
  }
}
