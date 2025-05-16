import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../public/presentation/widgets/screen_bottom_app_bar.dart';
import '../../../public/ui/providers/theme_provider.dart';
import '../../../public/ui/theme/main_theme.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: MainTheme.background(context),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? MainTheme.primary(context) : MainTheme.background(context),
        title: Text(
          'Preguntas frecuentes',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            FAQTile(
              question: "¿Qué es AlquilaFácil?",
              answer:
              "AlquilaFácil es una plataforma que conecta a propietarios e inquilinos de manera rápida y segura.",
            ),
             FAQTile(
              question: "¿Qué hago si no encuentro propiedades disponibles en mi zona?",
              answer:
              "Recomendamos ajustar los filtros de búsqueda para encontrar más opciones.",
            ),
            FAQTile(
              question: "¿Cómo puedo registrar mi propiedad?",
              answer:
              "Puedes registrar tu propiedad completando los detalles de tu propiedad en la sección 'Registrar espacio'.",
            ),
             FAQTile(
              question: "¿Qué tipos de locales puedo publicar?",
              answer:
              "Puedes publicar cualquier tipo de local, desde apartamentos y casas hasta oficinas o locales comerciales.",
            ),
            FAQTile(
              question: "¿Es necesario pagar para usar AlquilaFácil?",
              answer:
              "Crear una cuenta es gratuito. Sin embargo, ofrecemos planes premium con beneficios adicionales.",
            ),
            FAQTile(
              question: "¿Cómo gestiono las reservas que han hecho en mi propiedad?",
              answer:
              "Dentro de la sección 'Calendario', podrás ver todas las reservas que han hecho en tus propiedades, las que se encuentran resaltadas de color azul, se pueden modificar y/o cancelar, sin embargo, las reservas resaltadas de amarillo, que son hechas por usuarios premium, no se pueden modificar.",
            ),

          ],
        ),
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(color: MainTheme.contrast(context)),
            ),
          ),
        ],
      ),
    );
  }
}
