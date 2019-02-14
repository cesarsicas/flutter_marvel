import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter_marvel/characters/characters_view.dart';
import 'package:flutter_marvel/consts/consts.dart';
import 'package:flutter_marvel/consts/keys.dart';
import 'package:flutter_marvel/models/characters_response.dart';

class CharactersPresenter {
  final itemsPerPage = 20;
  final url = Const.baseUrl + "/v1/public/characters";
  var page = 0;
  var offset = 0;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  var searchTerm = "";
  CharactersView view;

  CharactersPresenter(this.view);

  void getCharacters() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMd5(timestamp + Keys.privateKey + Keys.publicKey).toString();

    try {
      offset = (page * itemsPerPage);
      Map<String, dynamic> queryParameters = {
        "apikey": Keys.publicKey,
        "hash": hash,
        "ts": timestamp,
        "limit": itemsPerPage.toString(),
        "offset": offset.toString()
      };

      if (this.searchTerm.isNotEmpty && searchTerm != null) {
        queryParameters['nameStartsWith'] = searchTerm;
      }

      if (!firstCall) {
        if (this.lastTotalReturnedItems < itemsPerPage) {
          view.addItems(List<Character>());
        }
      }

      view.showLoading();
      firstCall = false;
      var response = await Dio().get(url, queryParameters: queryParameters);

      final jsonValue = jsonDecode(response.toString());
      final object = CharactersResponse.fromJson(jsonValue);
      print("Resultado " + object.data.characters.length.toString());
      this.lastTotalReturnedItems = object.data.count;
      page++;
      view.addItems(object.data.characters);

      view.hideLoading();
    } catch (e) {
      print("Ocorreu um erro" + e.toString());
    }
  }

  void searchCharacters([String searchTerm = ""]) async {
    refresh();
    this.searchTerm = searchTerm;
    getCharacters();
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
    this.searchTerm = "";
    view.clearList();
  }
}
