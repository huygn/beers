import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../model/beer.dart';
import '../api/beer.dart';
import '../config/app.dart';

class BeersScreen extends StatefulWidget {
  @override
  _BeersScreenState createState() => _BeersScreenState();
}

class _BeersScreenState extends State<BeersScreen> {
  Future<List<Beer>> beers;

  @override
  void initState() {
    super.initState();
    beers = fetchBeers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Beers',
      home: Scaffold(
        appBar: AppBar(title: Text('Beers')),
        body: Container(
          child: FutureBuilder<List<Beer>>(
            future: beers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: EdgeInsets.all(8.0),
                  children: snapshot.data
                      .map(
                        (beer) => Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: Image.network(
                              beer.imageUrl,
                              width: 56,
                              height: 56,
                            ),
                            title: Text(beer.name),
                            subtitle: Text(beer.tagline),
                            onTap: () {
                              print("tapped ${beer.name}");
                              Application.router.navigateTo(
                                  context, "/beer/${beer.id}?name=${beer.name}",
                                  transition: TransitionType.native);
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
