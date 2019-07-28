import 'package:flutter/material.dart';
import '../model/beer.dart';
import '../api/beer.dart';

class BeerScreen extends StatefulWidget {
  const BeerScreen({
    Key key,
    this.beerId,
    this.beerName,
  }) : super(key: key);

  final String beerId;
  final String beerName;

  @override
  State createState() => BeerScreenState();
}

class BeerScreenState extends State<BeerScreen> {
  Future<Beer> beer;

  @override
  void initState() {
    super.initState();
    beer = fetchBeer(widget.beerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beerName),
      ),
      body: Container(
        child: FutureBuilder<Beer>(
          future: beer,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.name);
            }
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
