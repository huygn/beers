import 'package:dio/dio.dart';
import '../model/beer.dart';

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

Future<Beer> fetchBeer(String beerId) async {
  try {
    Response response =
        await Dio().get("https://api.punkapi.com/v2/beers/" + beerId);
    final beer = Beer.fromJson((response.data as List)[0]);
    return beer;
  } catch (e) {
    print(e);
    throw Exception('Failed to load beer');
  }
}
