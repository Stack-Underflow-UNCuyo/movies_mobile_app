import 'package:flutter/material.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/inicio_page.dart';
import 'package:mobile_app_flutter/features/peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';

/*
  ChangeNotifierProvider envuelve toda la app, 
    lo que hace que MovieProvider esté disponible en cualquier pantalla.
    '..' es el operador cascada de Dart:
      Crea el MovieProvider y al mismo tiempo llama a getOnDisplayMovies(), 
      entonces las películas empiezan a cargarse apenas abre la app.
  */
void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => MovieProvider()..getOnDisplayMovies(), 
    child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: InicioPage()
    );
  }
}