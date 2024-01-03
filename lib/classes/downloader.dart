import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class Downloader {
  static final Downloader _singleton = Downloader._internal();

  factory Downloader() {
    return _singleton;
  }

  Downloader._internal();

  void init({action}) {
    bindBackgroundIsolate(action: action);

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  void bindBackgroundIsolate({action}) {
    final ReceivePort port = ReceivePort();
    final isSuccess = IsolateNameServer.registerPortWithName(
      port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      dispose();
      bindBackgroundIsolate(action: action);
      return;
    }
    port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      if (action != null) {
        action(taskId, status, progress);
      }

      if (status == DownloadTaskStatus.complete) {
        port.close();
      }
    });
  }

  dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
  }

  Future<String> getFilenamePath(Directory directory, String originalFileName) async {
    String fileName = originalFileName;
    var i = 0;
    while (true) {
      String fullPath = directory.path + Platform.pathSeparator + fileName;
      if (await File(fullPath).exists()) {
        i++;
        List splits = originalFileName.split('.');
        fileName = ["${splits[0]} ($i)", splits[1]].join('.');
      } else {
        break;
      }
    }

    return fileName;
  }

  Future download(String url) async {
    final uri = Uri.parse(url);
    Directory directory = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    }
    String filename = uri.pathSegments.last;
    final fileName = await getFilenamePath(directory, filename);

    var task = await FlutterDownloader.enqueue(
      url: url,
      headers: {'auth': 'test_for_sql_encoding'},
      fileName: fileName,
      savedDir: directory.path,
      saveInPublicStorage: true, // Change this based on your needs
    );
    return task;
  }

  Future<bool> openDownloadedFile(taskId) async {
    if (taskId == null) {
      return false;
    }

    return FlutterDownloader.open(taskId: taskId);
  }
}
