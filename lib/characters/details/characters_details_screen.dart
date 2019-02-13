import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marvel/models/GetCharactersResponse.dart';
import 'package:flutter_marvel/network/network_image.dart';

class CharactersDetailsScreen extends StatefulWidget {
  Results result;

  CharactersDetailsScreen(this.result);

  @override
  State<StatefulWidget> createState() => _CharactersDetailsScreenState();
}

class _CharactersDetailsScreenState extends State<CharactersDetailsScreen> {
  Results result;

  @override
  void initState() {
    result = widget.result;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(result.name),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image(
                    image: NetworkImageWithRetry(
                      result.thumbnail.path + "." + result.thumbnail.extension,
                    ),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  result.description, style: TextStyle(fontSize: 14),),
              ],
            )));
  }
}
