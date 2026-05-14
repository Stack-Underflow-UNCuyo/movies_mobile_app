import 'package:flutter/material.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/inicio_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/movie_detail_page.dart';
import 'package:mobile_app_flutter/features/peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io'; // Para permitir conexiones HTTP inseguras 

/*
  ChangeNotifierProvider envuelve toda la app, 
    lo que hace que MovieProvider esté disponible en cualquier pantalla.
    '..' es el operador cascada de Dart:
      Crea el MovieProvider y al mismo tiempo llama a getOnDisplayMovies(), 
      entonces las películas empiezan a cargarse apenas abre la app.
  */
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
    create: (_) => MovieProvider()..getOnDisplayMovies(), 
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      //usamos 'initialRoute' cuando trabajamos con rutas nombradas
      initialRoute: '/', 
      routes: {
        '/': (context) => const InicioPage(), 
        '/movie-detail': (context) => const MovieDetailPage(), 
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}