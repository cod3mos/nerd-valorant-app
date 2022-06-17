import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nerdvalorant/mobile/screen_size.dart';
import 'package:nerdvalorant/pages/pixels/pixels.dart';
import 'package:nerdvalorant/themes/global_styles.dart';
import 'package:nerdvalorant/pages/profile/profile.dart';
import 'package:nerdvalorant/assets/media_source_tree.dart';
import 'package:nerdvalorant/pages/favorites/favorites.dart';
import 'package:nerdvalorant/pages/halftones/halftones.dart';
import 'package:nerdvalorant/pages/home/widgets/navigation_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) => setState(() => currentPage = page);

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return WillPopScope(
      onWillPop: () => turnBack(),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: setCurrentPage,
          children: const [
            PixelsPage(),
            FavoritesPage(),
            HalftonesPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPage,
          backgroundColor: blackColor,
          selectedItemColor: greenColor,
          unselectedItemColor: whiteColor,
          onTap: (page) => goToPage(page),
          items: [
            BottomNavigationBarItem(
              activeIcon: NavigationItem(icon: iconAlbums, color: greenColor),
              icon: NavigationItem(icon: iconAlbums, color: whiteColor),
              label: 'Pixels',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Ionicons.heart_outline),
              label: 'Favoritos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Ionicons.add_circle_outline),
              label: 'Retículas',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Ionicons.person_outline),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  void goToPage(page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  Future<bool> turnBack() async {
    if (currentPage != 0) {
      goToPage(0);
      return false;
    }

    return true;
  }
}
