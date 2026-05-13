import 'package:flutter/material.dart';
import 'package:mobile_app_flutter/core/utils/app_colors.dart';
import 'package:mobile_app_flutter/features/peliculas/data/models/movie_models.dart';
import 'package:mobile_app_flutter/features/peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

  //watch se "suscribe" al provider. Cada vez que el provider llama a notifyListeners(), este widget se redibuja.
  final movieProvider = context.watch<MovieProvider>(); 

  return Scaffold(
    backgroundColor: AppColors.background,
    body: movieProvider.isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : movieProvider.onDisplayMovies.isEmpty
            ? const Center(
                child: Text('No hay películas disponibles', 
                  style: TextStyle(color: AppColors.textPrimary)))

            : CustomScrollView( //scroll q permite mezclar cosas
                slivers: [
                  const SliverAppBar( //header
                    backgroundColor: AppColors.primary,
                    floating: true,
                    title: Text(
                      "Peliculas en cartelera",
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                
                //Carrusel
                SliverToBoxAdapter( //convierte un widget en un sliver
                  child: _MovieCarousel(
                    movies: movieProvider.onDisplayMovies
                  ),
                ),

                //Separaddor con titulo
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16,24,16,12), //espaciado (padding o margin)
                    child: Text(
                      'Todas las películas',
                      style: TextStyle( 
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                //Lista de pelis
                SliverList( //lista vertical
                  delegate: SliverChildBuilderDelegate( //esto hace q se creen items dinamicamente
                  (context, index) {
                    final movie = movieProvider.onDisplayMovies[index];
                    return _MovieListTile(movie: movie);
                  },
                  childCount: movieProvider.onDisplayMovies.length,
                  ),
                ),
                const SliverToBoxAdapter( //espacio al final
                  child: SizedBox(height: 32),
                ),
              ]
            ),
    );
  }
}

//carrusel
class _MovieCarousel extends StatelessWidget {
  final List<MovieModels> movies;
  const _MovieCarousel({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, //cambia la direccion
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: movies.length,
        itemBuilder: (context, index) { //va creando los items a medida que se necesitan
          final movie = movies[index];
          return _MoviePosterCard(movie: movie);
        },
      ),
    );
  }
}

class _MoviePosterCard extends StatelessWidget {
  final MovieModels movie;
  const _MoviePosterCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.posterPath != null && movie.posterPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w342${movie.posterPath}'
        : null;

    return GestureDetector( //widget clickeable
      onTap: () => Navigator.pushNamed(context, '/movie-detail',
          arguments: movie),
      child: Container( //card
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //ordena en vertical
          children: [
            // Póster
            ClipRRect( //recortar un widget con bordes redondeados
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 180,
                      width: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PosterPlaceholder(),
                    )
                  : _PosterPlaceholder(),
            ),
            const SizedBox(height: 8),
            // Título
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Rating
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFC107), size: 14),
                const SizedBox(width: 2),
                Text(
                  movie.voteAverage.toStringAsFixed(1), //redondea a 1 decimal
                  style: const TextStyle(
                      color: Color(0xFFAAAAAA), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.movie_outlined,
          color: Color(0xFF444444), size: 40),
    );
  }
}

// Lista vertical 

class _MovieListTile extends StatelessWidget {
  final MovieModels movie;
  const _MovieListTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    final thumbUrl = movie.backdropPath != null &&
            movie.backdropPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w300${movie.backdropPath}'
        : null;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/movie-detail',
          arguments: movie),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.8),                                  ///
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Thumbnail backdrop
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: thumbUrl != null
                  ? Image.network(
                      thumbUrl,
                      width: 100,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _ThumbPlaceholder(),
                    )
                  : _ThumbPlaceholder(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded( //usa todo el espacio disponible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.text, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Rating badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.8),                              //
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFC107), size: 14),
                  const SizedBox(width: 2),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.movie_outlined,
          color: Color(0xFF444444), size: 24),
    );
  }
}