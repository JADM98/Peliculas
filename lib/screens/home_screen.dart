import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    // print(moviesProvider.onDisplayMovies);

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Peliculas App')),
          elevation: 0,
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Tarjetas Principales
              CardSwipper(movies: moviesProvider.onDisplayMovies),

              //Slider de Peliculas
              MovieSlider(
                  movies: moviesProvider.popularMovies,
                  title: 'Populares!',
                  onNextPage: () => moviesProvider.getPopularMovies()),
            ],
          ),
        ));
  }
}
