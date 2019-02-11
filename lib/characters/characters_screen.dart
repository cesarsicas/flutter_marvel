import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/characters_list_item.dart';
import 'package:flutter_marvel/characters/characters_presenter.dart';
import 'package:flutter_marvel/characters/characters_view.dart';
import 'package:flutter_marvel/models/GetCharactersResponse.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CharactersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CharacterScreenState();
  }
}

class _CharacterScreenState extends State<CharactersScreen>
    implements CharactersView {
  CharactersPresenter presenter;
  var characters = new List<Results>();
  var _editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = new ScrollController();
  int currentPageNumber;

  @override
  void initState() {
    super.initState();
    this.presenter = CharactersPresenter(this);
    presenter.getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Marvel characters"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            presenter.refresh();
            presenter.getCharacters();
          },
          tooltip: 'Refresh',
          child: Icon(Icons.refresh),
          elevation: 2.0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: "Search Marvel Character"),
                          onSubmitted: (text) {
                            _prepareSearch();
                          },
                          controller: _editTextController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _prepareSearch();
                        },
                      ),
                    ],
                  )),
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
  addItems(List<Results> characters) {
    setState(() {
      this.characters.addAll(characters);
    });
  }

  @override
  showError() {
    print("Ocorreu um erro ou nenhum personagem encontrado");
  }

  _prepareSearch() {
    presenter.searchCharacters(_editTextController.text);
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
}
