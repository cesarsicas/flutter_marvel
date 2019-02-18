import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/details/image/comics_image_screen.dart';
import 'package:flutter_marvel/models/comics_response.dart';
import 'package:flutter_marvel/network/network_image.dart';

class ComicsListItem extends StatelessWidget {
  final Comic comic;

  ComicsListItem({this.comic});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => ComicsImageScreen(comic))
          );
        },
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
