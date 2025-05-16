import 'dart:io';
import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:alquilafacil/spaces/presentation/widgets/navigation_buttons.dart';

class RegisterSpaceStep6 extends StatefulWidget {
  final PageController pageController;
  final String photoUrl;
  final Function(String) onPhotoChanged;

  const RegisterSpaceStep6({
    super.key,
    required this.pageController,
    required this.photoUrl,
    required this.onPhotoChanged,
  });

  @override
  _RegisterSpaceStep6State createState() => _RegisterSpaceStep6State();
}

class _RegisterSpaceStep6State extends State<RegisterSpaceStep6> {
  File? _imageFile; // Almacena la imagen seleccionada
  bool _canProceed = false; // Controla si se puede avanzar a la siguiente página

  // Método para seleccionar imagen desde la galería
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _canProceed = true; // Habilitar el botón para avanzar
      });
    }
  }

  // Método para subir la imagen a Cloudinary
  Future<void> _uploadImageToCloudinary() async {
    if (_imageFile != null) {
      final spaceProvider = context.read<SpaceProvider>();
      await spaceProvider.uploadImage(_imageFile!);

      widget.onPhotoChanged(spaceProvider.spacePhotoUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Agrega una foto de tu espacio',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: MainTheme.contrast(context)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selecciona una imagen de la galería para que represente tu espacio.',
              style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Botón para añadir imagen
            Center(
              child: GestureDetector(
                onTap: _pickImage, // Seleccionar imagen
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _imageFile == null && widget.photoUrl.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          color: MainTheme.primary(context), size: 40),
                      const SizedBox(height: 8),
                      const Text(
                        'Añadir una imagen',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  )
                      : _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.photoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            NavigationButtons(
              pageController: widget.pageController,
              canProceed: _canProceed,
              onNext: _uploadImageToCloudinary, // Subir imagen al proceder
            ),
          ],
        ),
      ),
    );
  }
}
