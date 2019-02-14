import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/characters_list_item.dart';
import 'package:flutter_marvel/characters/characters_presenter.dart';
import 'package:flutter_marvel/characters/characters_view.dart';
import 'package:flutter_marvel/models/characters_response.dart';
import 'package:flutter_marvel/network/network_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CharactersDetailsScreen extends StatefulWidget {
  Character result;

  CharactersDetailsScreen(this.result);

  @override
  State<StatefulWidget> createState() => _CharactersDetailsScreenState();
}

class _CharactersDetailsScreenState extends State<CharactersDetailsScreen>
    implements CharactersView {
  CharactersPresenter presenter;
  var characters = new List<Character>();
  var _editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = new ScrollController();
  int currentPageNumber;
  Character character;

  @override
  void initState() {
    super.initState();
    character = widget.result;
    this.presenter = CharactersPresenter(this);
    presenter.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final description = character.description.isEmpty
        ? "This character doesn't have a description"
        : character.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(character.name),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image(
                        image: NetworkImageWithRetry(
                          character.thumbnail.path +
                              "." +
                              character.thumbnail.extension,
                        ),
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 8, 0.0, 0.0),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener(
                    onNotification: onNotification,
                    child: new GridView.builder(
                        padding: EdgeInsets.only(top: 5.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                        ),
                        controller: scrollController,
                        itemCount: characters.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return CharactersListItem(result: characters[index]);
                        })),
              ),
            ],
          ),
        ));
  }

  @override
  addItems(List<Character> characters) {
    setState(() {
      this.characters.addAll(characters);
    });
  }

  @override
  showError() {
    print("Ocorreu um erro ou nenhum personagem encontrado");
  }

  bool onNotification(ScrollNotification notification) {
    print("Notification");

    if (notification is ScrollUpdateNotification) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isLoading) {
          presenter.getCharacters();
        }
      }
    }

    return true;
  }

  @override
  clearList() {
    setState(() {
      this.characters.clear();
      this._editTextController.clear();
    });
  }

  @override
  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

//  @override
//  Widget build(BuildContext context) {
//
//
//    return Scaffold(
//        appBar: AppBar(
//          title: Text(character.name),
//        ),
//        body: Padding(
//            padding: EdgeInsets.all(16),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Center(
//                  child: Image(
//                    image: NetworkImageWithRetry(
//                      character.thumbnail.path +
//                          "." +
//                          character.thumbnail.extension,
//                    ),
//                    width: 250,
//                    height: 250,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//                Container(
//                  margin: EdgeInsets.fromLTRB(0.0, 8, 0.0, 0.0),
//                  child: Text(
//                    description,
//                    style: TextStyle(fontSize: 14),
//                  ),
//                ),
//              ],
//            )));
//  }
}
