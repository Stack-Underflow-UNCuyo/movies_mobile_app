import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mobile_app_flutter/core/utils/app_colors.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/favoritos_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/home_page.dart';
import 'package:mobile_app_flutter/features/peliculas/presentation/pages/perfil_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => InicioPageState();
}

class InicioPageState extends State<InicioPage> {
  int currentIndex = 0;
  final List<Widget> pages = [HomePage(), FavoritosPage(), PerfilPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.surface,           // barra oscura
        buttonBackgroundColor: AppColors.primary, // botón activo 
        index: currentIndex,
        animationDuration: const Duration(milliseconds: 280),
        animationCurve: Curves.easeInOut,
        items: const [
          Icon(Icons.home_rounded,     size: 26, color: AppColors.text),
          Icon(Icons.favorite_rounded, size: 26, color: AppColors.text),
          Icon(Icons.person_rounded,   size: 26, color: AppColors.text),
        ],
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
