import 'package:flutter_marvel/models/comics_response.dart';

abstract class CharactersDetailsView {
  addItems(List<Comic> comics);
  showError();
  clearList();
  showLoading();
  hideLoading();
}