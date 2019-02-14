import 'package:flutter_marvel/models/characters_response.dart';

abstract class CharactersDetailsView {
  addItems(List<Character> characters);
  showError();
  clearList();
  showLoading();
  hideLoading();
}