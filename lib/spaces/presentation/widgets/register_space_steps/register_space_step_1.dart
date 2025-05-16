import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:alquilafacil/spaces/presentation/widgets/step_card.dart';
import 'package:flutter/material.dart';

class RegisterSpaceStep1 extends StatelessWidget {
  final PageController pageController;
  const RegisterSpaceStep1({super.key, required this.pageController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Empezar a usar AlquilaFácil es muy sencillo.',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: MainTheme.contrast(context)),
            )),
            const SizedBox(height: 10.0),
            const Text(
              'Completa los siguientes pasos para registrar tu espacio en la aplicación',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 25.0),

            StepCard(
              image: Image.network(
                  "https://i.ibb.co/2hzsgKf/images-removebg-preview.png"),
              stepNumber: '1. Describe tu espacio',
              description: 'Comparte algunos datos básicos',
            ),

            StepCard(
              image: Image.network(
                  "https://i.ibb.co/2dWkZMR/images-removebg-preview-1.png"),
              stepNumber: '2. Haz que destaque',
              description:
              'Agrega algunas fotos y un título a tu espacio, nosotros nos encargamos del resto',
            ),

            // Step 3 - Card
            StepCard(
              image: Image.network(
                  "https://i.ibb.co/xLPKTg9/images-removebg-preview-2.png"),
              stepNumber: '3. Terminar y publicar',
              description:
              'Agrega las últimas configuraciones y publica tu espacio',
            ),

            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainTheme.primary(context),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Comencemos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}