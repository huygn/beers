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
        padding: EdgeInsets.all(24.0),
        child: FutureBuilder<Beer>(
          future: beer,
          builder: (context, snapshot) {
            final beer = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  beer.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(beer.tagline),
                            ],
                          ),
                        ),
                        Container(
                          child: Image.network(
                            beer.imageUrl,
                            width: 80,
                            height: 80,
                          ),
                          margin: EdgeInsets.only(left: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child:
                        Text(beer.description, style: TextStyle(height: 1.25)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(beer.brewersTips, style: TextStyle(height: 1.25)),
                ],
              );
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
