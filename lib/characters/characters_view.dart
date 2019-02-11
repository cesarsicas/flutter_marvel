import 'package:flutter_marvel/models/GetCharactersResponse.dart';

abstract class CharactersView {
  addItems(List<Results> characters);
  showError();
  clearList();
  showLoading();
  hideLoading();
}