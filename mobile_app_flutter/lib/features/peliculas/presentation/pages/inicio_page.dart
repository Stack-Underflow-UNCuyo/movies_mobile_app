import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mobile_app_flutter/core/utils/app_colors.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/favoritos_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/home_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/movie_detail_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/perfil_page.dart';

/*
Es StatefulWidget porque necesita recordar en qué pestaña está.
*/
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => InicioPageState();
}

class InicioPageState extends State<InicioPage> {
  int currentIndex = 0;
  List<Widget> pages = [HomePage(), FavoritosPage(), PerfilPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.primary,
        color: AppColors.primary,
        index: currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 30, color: AppColors.text),
          Icon(Icons.favorite, size: 30, color: AppColors.text),
          Icon(Icons.person, size: 30, color: AppColors.text),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}