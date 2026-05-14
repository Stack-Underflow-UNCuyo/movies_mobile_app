import 'package:flutter/material.dart';
import 'package:mobile_app_flutter/core/utils/app_colors.dart';
import 'package:mobile_app_flutter/features/peliculas/data/models/movie_models.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    //recibimos la pelicula a traves de los args de la ruta
    final MovieModels movie = ModalRoute.of(context)!.settings.arguments as MovieModels; // ! operador null-check

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          SliverList(delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: movie),
            _Overview(movie: movie),
            _OtherDetails(movie: movie),
          ]),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final MovieModels movie;
  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 200,
      pinned: true,
      // ESTA LÍNEA pone la flecha (y cualquier otro icono del AppBar) en blanco
      iconTheme: const IconThemeData(color: Colors.white), 
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          // Usamos un gradiente para que el texto resalte pero no tape la imagen
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
          ),
          child: Text(
            movie.title,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ),
        background: Image.network(
          'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final MovieModels movie;
  const _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://image.tmdb.org/t/p/w300${movie.posterPath}',
              height: 150,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, 
                    style: const TextStyle(color: AppColors.textPrimary, 
                    fontSize: 20, fontWeight: FontWeight.bold), 
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 2
                ),
                Text(movie.originalTitle, 
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14), 
                overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                Text('Lanzamiento: ${movie.releaseDate}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final MovieModels movie;
  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sinopsis', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            movie.overview,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _OtherDetails extends StatelessWidget {
  final MovieModels movie;
  const _OtherDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap( // Wrap ayuda a que si no caben, se pasen a la siguiente línea
        spacing: 10,
        children: [
          Chip(
            // ignore: deprecated_member_use
            backgroundColor: AppColors.primary.withValues(alpha: 0.7),
            label: Text('Popularidad: ${movie.popularity.toInt()}', style: const TextStyle(color: AppColors.text)),
          ),
          Chip(
            // ignore: deprecated_member_use
            backgroundColor: AppColors.primary.withValues(alpha: 0.7),
            label: Text('Votos: ${movie.voteCount}', style: const TextStyle(color: AppColors.text)),
          ),
          Chip(
            backgroundColor: AppColors.primary.withValues(alpha: 0.7),
            label: Text('Idioma: ${movie.originalLanguage.toUpperCase()}', style: const TextStyle(color: AppColors.text)),
          ),
        ],
      ),
    );
  }
}