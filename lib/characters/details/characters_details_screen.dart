import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_marvel/characters/details/characters_details_presenter.dart';
import 'package:flutter_marvel/characters/details/characters_details_view.dart';
import 'package:flutter_marvel/characters/details/comics_list_item.dart';
import 'package:flutter_marvel/models/characters_response.dart';
import 'package:flutter_marvel/models/comics_response.dart';
import 'package:flutter_marvel/network/network_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CharactersDetailsScreen extends StatefulWidget {
  Character character;

  CharactersDetailsScreen(this.character);

  @override
  State<StatefulWidget> createState() => _CharactersDetailsScreenState();
}

class _CharactersDetailsScreenState extends State<CharactersDetailsScreen>
    implements CharactersDetailsView {
  CharactersDetailsPresenter presenter;

  var comics = new List<Comic>();
  var _editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = new ScrollController();
  int currentPageNumber;
  Character character;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    this.presenter = CharactersDetailsPresenter(this, character.id);
    presenter.getComics();
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
                        itemCount: comics.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return ComicsListItem(comic: comics[index]);
                        })),
              ),
            ],
          ),
        ));
  }

  @override
  addItems(List<Comic> comics) {
    setState(() {
      this.comics.addAll(comics);
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
          presenter.getComics();
        }
      }
    }

    return true;
  }

  @override
  clearList() {
    setState(() {
      this.comics.clear();
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
