import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';
import 'package:peliculas/protected/protected.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = ApiKey.apiKey;
  final String _baseUrl = 'api.themoviedb.org';
  final String _lang = 'es-ES';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
      duration: const Duration(milliseconds: 500), onValue: (value) {});

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    // print('Movies Provider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, {int page = 1}) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _lang, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final String jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final String jsonData =
        await _getJsonData('3/movie/popular', page: _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final String jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditResponse.cast;
    return creditResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _lang, 'query': query});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final SearchResponse searchResponse =
        SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar $value');
      final result = await searchMovie(value.toString());
      _suggestionStreamController.add(result);
    };

    final timer = Timer(const Duration(milliseconds: 300), () {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
