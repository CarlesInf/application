import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfg/elements_ui/categories_drawer.dart';
import '../presenter/popular_presenter.dart';
import './itemDetails.dart';

class PopularPage extends StatefulWidget {
  final String email;
  final dynamic documentID;

  PopularPage({Key key, this.email, this.documentID}) : super(key: key);

  @override
  PopularPageState createState() => PopularPageState();
}

class PopularPageState extends State<PopularPage> {
  PopularPagePresenterState _presenter;

  PopularPageState() {}

  set presenter(PopularPagePresenterState value) {
    this._presenter = value;
  }

  @override
  void initState() {
    super.initState();
    _presenter = new PopularPagePresenterState();
    _presenter.view = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildSideDrawer(),
      appBar: AppBar(
        title: Text('Productos Populares'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _presenter.getCollection(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return _buildListView(snapshot.data.documents);
        },
      ),
    );
  }

  Widget _buildListView(List<DocumentSnapshot> list_snapshot) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    Future<List<List<DocumentSnapshot>>> lista_populares =  _presenter.getPopularList(list_snapshot);
    print(lista_populares);

    // List<DocumentSnapshot> list = _presenter.getPopular(list_snapshot);
    // print(list);
    // print(list[0]['nombre']);
    // print(list[1]['nombre']);
    // print(list[2]['nombre']);
    // if (list[0] == list[1] && list[2] == list[1]) {
    //   list.remove(list[0]);
    //   list.remove(list[1]);
    // } else if (list[0] == list[1]) {
    //   list.remove(list[0]);
    // } else if (list[1] == list[2]) {
    //   list.remove(list[1]);
    // } else if (list[0] == list[2]) {
    //   list.remove(list[0]);
    // }

    

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight) * 1.2,
              controller: new ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(4.0),
            ),
          ),
        ),
      ],
    );
  }
}
