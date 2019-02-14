import 'package:flutter/material.dart';
import 'package:flutter_marvel/models/comics_response.dart';
import 'package:flutter_marvel/network/network_image.dart';

class ComicsListItem extends StatelessWidget {
  ComicsListItem({this.comic});

  final Comic comic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Card(
          color: Colors.white,
          elevation: 5.0,
          child: Image(
            image: NetworkImageWithRetry(
              comic.thumbnail.path + "." + comic.thumbnail.extension,
            ),
            fit: BoxFit.cover,
          ),
        ));
  }
}
