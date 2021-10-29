import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future imageDownloader(String urlPath, String fileName,
    Function(int received, int total) onReceiveProgress) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
      urlPath,
      onReceiveProgress: onReceiveProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return true;
          }),
    );
    // print(response.headers);
    File file = File(fileName);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    const AlertDialog(
      title: Text('Alert'),
      content: Text('Something went wrong ! '),
    );
  }
}
