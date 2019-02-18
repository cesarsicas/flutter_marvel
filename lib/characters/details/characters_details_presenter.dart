import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter_marvel/characters/characters_view.dart';
import 'package:flutter_marvel/characters/details/characters_details_view.dart';
import 'package:flutter_marvel/consts/consts.dart';
import 'package:flutter_marvel/consts/keys.dart';
import 'package:flutter_marvel/models/characters_response.dart';
import 'package:flutter_marvel/models/comics_response.dart';

class CharactersDetailsPresenter {
  final itemsPerPage = 21;
  final url = Const.baseUrl + "/v1/public/comics";
  var page = 0;
  var offset = 0;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  CharactersDetailsView view;
  int characterId;

  CharactersDetailsPresenter(this.view, this.characterId);

  void getComics() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash =
        generateMd5(timestamp + Keys.privateKey + Keys.publicKey).toString();

    try {
      offset = (page * itemsPerPage);
      Map<String, dynamic> queryParameters = {
        "apikey": Keys.publicKey,
        "hash": hash,
        "ts": timestamp,
        "limit": itemsPerPage.toString(),
        "offset": offset.toString(),
        "characters": characterId.toString()
      };

      if (!firstCall) {
        if (this.lastTotalReturnedItems < itemsPerPage) {
          view.addItems(List<Comic>());
        }
      }

      view.showLoading();
      firstCall = false;
      var response = await Dio().get(url, queryParameters: queryParameters);

      final jsonValue = jsonDecode(response.toString());
      final object = ComicsResponse.fromJson(jsonValue);

      print("Resultado " + object.data.comics.length.toString());

      this.lastTotalReturnedItems = object.data.count;
      page++;
      view.addItems(object.data.comics);

      view.hideLoading();
    } catch (e) {
      print("Ocorreu um erro" + e.toString());
    }
  }

  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  void refresh() {
    this.page = 0;
    this.offset = 0;
    this.lastTotalReturnedItems = 0;
    this.firstCall = true;
    view.clearList();
  }
}
