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
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            ),
            color: Colors.white,
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: NetworkImageWithRetry(
                      comic.thumbnail.path + "." + comic.thumbnail.extension,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      comic.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ],
            )));
  }
}
