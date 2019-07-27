import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';

final router = Router();

class Beer {
  final int id;
  final String name;
  final String tagline;
  final String firstBrewed;
  final String description;
  final String imageUrl;
  final String contributedBy;

  Beer(
      {this.id,
      this.name,
      this.tagline,
      this.firstBrewed,
      this.description,
      this.imageUrl,
      this.contributedBy});

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      firstBrewed: json['first_brewed'],
      description: json['description'],
      imageUrl: json['image_url'],
      contributedBy: json['contributed_by'],
    );
  }
}

Future<List<Beer>> fetchBeers() async {
  try {
    Response response =
        await Dio().get("https://api.punkapi.com/v2/beers?per_page=80");
    final beers = (response.data as List).map((b) => Beer.fromJson(b)).toList();
    return beers;
  } catch (e) {
    print(e);
    throw Exception('Failed to load beers');
  }
}

class Routes {
  static String root = "/";
  static String beer = "/beer/:id";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print("ROUTE WAS NOT FOUND !!!");
      },
    );
    router.define(root, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return MyHome();
      },
    ));
    router.define(beer, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return BeerScreen(beerId: params["id"][0], beerName: params["name"][0]);
      },
    ));
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MyAppState() {
    Routes.configureRoutes(router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generator,
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
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
                              router.navigateTo(
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

class BeerScreen extends StatelessWidget {
  const BeerScreen({
    Key key,
    this.beerId,
    this.beerName,
  }) : super(key: key);

  final String beerId;
  final String beerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beerName),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go back!'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
