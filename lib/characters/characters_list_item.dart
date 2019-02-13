import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/details/characters_details_screen.dart';
import 'package:flutter_marvel/models/GetCharactersResponse.dart';
import 'package:flutter_marvel/network/network_image.dart';

class CharactersListItem extends StatelessWidget {
  CharactersListItem({this.result});

  final Results result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CharactersDetailsScreen(result)),
          );
        },
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
                      result.thumbnail.path + "." + result.thumbnail.extension,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      result.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ],
            )));
  }
}
