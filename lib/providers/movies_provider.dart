import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'package:peliculas/protected/protected.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = ApiKey.apiKey;
  final String _baseUrl = 'api.themoviedb.org';
  final String _lang = 'es-ES';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    // print('Movies Provider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _lang, 'page': '1'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
    // print(nowPlayingResponse.results[0].title);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/popular',
        {'api_key': _apiKey, 'language': _lang, 'page': '1'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    final popularResponse = PopularResponse.fromJson(response.body);
    popularMovies = [...popularMovies, ...popularResponse.results];
    // print(popularMovies[0]);
    notifyListeners();
  }
}
