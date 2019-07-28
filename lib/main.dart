import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'config/app.dart';
import 'components/beer.dart';
import 'components/beers.dart';

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
        return BeersScreen();
      },
    ));
    router.define(beer, handler: Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return BeerScreen(beerId: params["id"][0], beerName: params["name"][0]);
      },
    ));
  }
}

class MyApp extends StatefulWidget {
  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MyAppState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
    );
  }
}

void main() => runApp(MyApp());
