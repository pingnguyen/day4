import 'dart:io';

import 'package:df04/modules/downloads/blocs/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:path_provider/path_provider.dart';

class ImageShow extends StatefulWidget {
  const ImageShow({Key? key}) : super(key: key);

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  bool isDownloading = false;
  bool isFinished = false;
  int currentValue = 0;
  String imageToDownloadPath =
      'https://cdn.stocksnap.io/img-thumbs/960w/leaves-fall_53P5OD6DH1.jpg';
  String imageDownloadedPath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image download with progress'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: isDownloading
                        ? FAProgressBar(
                            currentValue: currentValue,
                            displayText: '%',
                          )
                        : const Text(
                            'Autumn leaves fall',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: const Text('Download'),
                      onPressed: showDownloadProgress,
                    ),
                  )
                ],
              ),
              isFinished
                  ? Image.file(
                      File(imageDownloadedPath),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void showDownloadProgress() async {
    final directory = await getApplicationDocumentsDirectory();
    imageDownloadedPath = directory.path + '/leavesFall.jpg';
    setState(() {
      isDownloading = !isDownloading;
    });
    await imageDownloader(
      imageToDownloadPath,
      imageDownloadedPath,
      (int received, int total) {
        if (total != -1) {
          setState(() {
            currentValue = (received / total * 100).round();
          });
        }
      },
    );
    setState(() {
      isFinished = true;
    });
  }
}
