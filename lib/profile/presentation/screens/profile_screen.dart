import 'package:alquilafacil/auth/presentation/providers/SignInPovider.dart';
import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:alquilafacil/subscriptions/presentation/provider/plan_provider.dart';
import 'package:alquilafacil/subscriptions/presentation/screens/payment_finish_screen.dart';
import 'package:alquilafacil/subscriptions/presentation/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:alquilafacil/spaces/presentation/widgets/card.dart';

import '../../../public/ui/providers/theme_provider.dart';
import '../../../public/ui/theme/main_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceProvider = Provider.of<SpaceProvider>(context);
    final signInProvider = context.watch<SignInProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final planProvider = context.watch<PlanProvider>();
    return Scaffold(
      backgroundColor: MainTheme.background(context),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? MainTheme.primary(context) : MainTheme.background(context),
        title: Text(
          'Panel de control',
          style: TextStyle(color: MainTheme.contrast(context)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/search-space');
          },
        ),
      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 10.0,
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Color del tema:",
                    style: TextStyle(
                      color: MainTheme.contrast(context),
                      fontSize: 14.0,
                    ),
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      value: themeProvider.isDarkTheme,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: MainTheme.background(context),
                      activeTrackColor: const Color(0xFFD13333),
                      inactiveThumbColor: Colors.amber,
                      inactiveTrackColor: Colors.amberAccent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.nightlight_round, color: Colors.indigo, size: 24),
                  ],
                ),
               ]
              ),
            ),
            ),
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const NavigationRow(
                      title: 'Modificar perfil',
                      routeName: '/profile-details',
                    ),
                    const Divider(),
                    NavigationRow(
                      title: 'Ver mi suscripción',
                      routeName: '/subscription',
                      onTap: () async{
                        try{
                          await planProvider.fetchPlansAvailable();
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                        } catch (e){
                          Logger().e("Error while trying to fecth plans available: $e");
                        }
                      },
                    ),
                    const Divider(),
                    const NavigationRow(
                      title: 'Mis espacios publicados',
                      routeName: '/my-spaces',
                    ),
                    const Divider(),
                    NavigationRow(
                      title: 'Mis espacios favoritos',
                      routeName: '/favorites',
                      onTap: () async {
                        await spaceProvider.loadFavorites();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const NavigationRow(
                      title: 'Soporte',
                      routeName: '/support',
                    ),
                    const Divider(),
                    const NavigationRow(
                      title: 'Reportes realizados',
                      routeName: '/show-reports',
                    ),
                    const Divider(),
                    NavigationRow(
                      title: 'Cerrar sesión',
                      routeName: '/login',
                      onTap: () async {
                        try {
                          await signInProvider.onLogOutRequest();
                        } finally {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/login",
                                (Route<dynamic> route) => false,
                          );
                        }
                      },
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceProvider = Provider.of<SpaceProvider>(context);
    final favoriteSpaces = spaceProvider.favoriteSpaces;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? MainTheme.primary(context) : MainTheme.background(context),
        title: Text(
          'Mis espacios favoritos',
          style: TextStyle(color: MainTheme.contrast(context)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/search-space');
          },
        ),
      ),
      body: favoriteSpaces.isEmpty
          ? const Center(child: Text('No tienes espacios favoritos'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: favoriteSpaces.length,
              itemBuilder: (context, index) {
                final space = favoriteSpaces[index];
                return SpaceCard(
                  location: space.cityPlace,
                  price: space.nightPrice.toString(),
                  imageUrl: space.photoUrl,
                  id: space.id,
                  userId: space.userId!,
                );
              },
            ),
    );
  }
}

class NavigationRow extends StatelessWidget {
  final String title;
  final String routeName;
  final VoidCallback? onTap;

  const NavigationRow({
    super.key,
    required this.title,
    required this.routeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pushNamed(context, routeName),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: MainTheme.contrast(context),
              ),
            ),
             Icon(
              Icons.arrow_forward_ios,
              color: MainTheme.contrast(context),
            ),
          ],
        ),
      ),
    );
  }
}
