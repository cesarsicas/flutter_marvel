import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marvel/models/comics_response.dart';
import 'package:flutter_marvel/network/network_image.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ComicsImageScreen extends StatefulWidget {
  Comic comic;

  ComicsImageScreen(this.comic);

  @override
  State<StatefulWidget> createState() => ComicsImageScreenState();
}

class ComicsImageScreenState extends State<ComicsImageScreen> {
  Comic comic;

  @override
  void initState() {
    this.comic = widget.comic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(comic.title),
        ),
        body: ZoomableImage(NetworkImageWithRetry(
          comic.thumbnail.path + "." + comic.thumbnail.extension,
        )));
  }
}
