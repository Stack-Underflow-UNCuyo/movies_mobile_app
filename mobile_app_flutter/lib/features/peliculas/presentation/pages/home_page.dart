import 'package:flutter/material.dart';
import 'package:mobile_app_flutter/core/utils/app_colors.dart';
import 'package:mobile_app_flutter/features/peliculas/data/models/movie_models.dart';
import 'package:mobile_app_flutter/features/peliculas/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: movieProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            )
          : movieProvider.onDisplayMovies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.movie_outlined,
                          color: AppColors.textMuted, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'No hay películas disponibles',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 15),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.background,
                      floating: true,
                      elevation: 0,
                      titleSpacing: 20,
                      title: Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'CINE',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                  ),
                                ),
                                TextSpan(
                                  text: 'APP',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(1),
                        child: Container(
                          height: 1,
                          color: AppColors.border,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: _SectionLabel(title: 'EN CARTELERA'),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: _MovieCarousel(
                          movies: movieProvider.onDisplayMovies),
                    ),

                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
                        child: _SectionLabel(title: 'TODAS LAS PELÍCULAS'),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final movie =
                              movieProvider.onDisplayMovies[index];
                          return _MovieListTile(movie: movie);
                        },
                        childCount: movieProvider.onDisplayMovies.length,
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _MovieCarousel extends StatelessWidget {
  final List<MovieModels> movies;
  const _MovieCarousel({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
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

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/movie-detail', arguments: movie),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 185,
                          width: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _PosterPlaceholder(),
                        )
                      : const _PosterPlaceholder(),
                  // Gradiente inferior para legibilidad
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.accent, size: 12),
                const SizedBox(width: 3),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
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
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      width: 130,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.movie_outlined,
          color: AppColors.textMuted, size: 32),
    );
  }
}


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
      onTap: () =>
          Navigator.pushNamed(context, '/movie-detail', arguments: movie),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: thumbUrl != null
                  ? Image.network(
                      thumbUrl,
                      width: 110,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const _ThumbPlaceholder(),
                    )
                  : const _ThumbPlaceholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Rating badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.accent, size: 16),
                  const SizedBox(height: 2),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
  const _ThumbPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 68,
      color: AppColors.surfaceElevated,
      child: const Icon(Icons.movie_outlined,
          color: AppColors.textMuted, size: 22),
    );
  }
}
