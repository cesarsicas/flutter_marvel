import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter_marvel/characters/characters_view.dart';
import 'package:flutter_marvel/consts/Consts.dart';
import 'package:flutter_marvel/models/GetCharactersResponse.dart';

class CharactersPresenter {
  final itemsPerPage = 20;
  var page = 0;
  var offset = 0;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  var searchTerm = "";
  CharactersView view;

  CharactersPresenter(this.view);

  void getCharacters() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMd5(timestamp + Const.privateKey + Const.publicKey).toString();

    try {
      offset = (page * itemsPerPage);
      Map<String, dynamic> queryParameters = {
        "apikey": Const.publicKey,
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
          view.addItems(List<Results>());
        }
      }

      view.showLoading();
      firstCall = false;
      var response = await Dio().get(Const.url, queryParameters: queryParameters);

      final jsonValue = jsonDecode(response.toString());
      final object = GetCharactersResponse.fromJson(jsonValue);
      print("Resultado " + object.data.results.length.toString());
      this.lastTotalReturnedItems = object.data.count;
      page++;
      view.addItems(object.data.results);

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
