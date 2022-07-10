import 'package:flutter/material.dart';
import 'package:peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            children: const [
              //Tarjetas Principales
              CardSwipper(),

              //Slider de Peliculas
              MovieSlider(),
              MovieSlider(),
              MovieSlider(),
              MovieSlider()
            ],
          ),
        ));
  }
}
