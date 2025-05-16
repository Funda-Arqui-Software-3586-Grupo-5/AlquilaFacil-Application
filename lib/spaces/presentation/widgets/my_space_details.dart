import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../profile/presentation/providers/pofile_provider.dart';
import '../../../public/ui/theme/main_theme.dart';
import '../../../reservation/presentation/widgets/edit_space_info.dart';
import '../../../reservation/presentation/widgets/space_info_details.dart';
import '../providers/space_provider.dart';
import 'edit_space_field.dart';
import 'my_space_details_actions.dart';

class MySpaceDetails extends StatefulWidget {
  const MySpaceDetails({super.key});

  @override
  State<MySpaceDetails> createState() => _MySpaceDetailsState();
}

class _MySpaceDetailsState extends State<MySpaceDetails> {
  late TextEditingController _nightPriceController;
  late TextEditingController _featuresController;
  File? _imageFile;
  bool isImageToUpdate = false;

  @override
  void initState() {
    super.initState();
    final spaceProvider = context.read<SpaceProvider>();

    _nightPriceController = TextEditingController(
        text: spaceProvider.spaceSelected!.nightPrice.toString());
    _featuresController =
        TextEditingController(text: spaceProvider.spaceSelected!.features);

    () async {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider
          .fetchUsernameExpect(spaceProvider.spaceSelected!.userId!);
    }();
  }

  @override
  void dispose() {
    _nightPriceController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        isImageToUpdate = true;
      });
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_imageFile != null) {
      final spaceProvider = context.read<SpaceProvider>();
      try {
        await spaceProvider.uploadImage(_imageFile!);
      } finally {
        setState(() {
          isImageToUpdate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceProvider = context.watch<SpaceProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainTheme.primary(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MainTheme.background(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            Text("Mis espacios", style: TextStyle(color: MainTheme.background(context))),
      ),
      body: spaceProvider.spaceSelected != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceProvider.isEditMode
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        spaceProvider.spaceSelected!.photoUrl,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                top: 175,
                                right: 1,
                                child: SizedBox(
                                  width: 55,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      iconSize: 20,
                                      backgroundColor: MainTheme.background(context),
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    onPressed: _pickImage,
                                    icon: Icon(
                                      Icons.edit,
                                      color: MainTheme.secondary(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.network(
                          spaceProvider.spaceSelected!.photoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !spaceProvider.isEditMode
                            ? SpaceInfoDetails(
                                localName:
                                    spaceProvider.spaceSelected!.localName,
                                capacity: spaceProvider.spaceSelected!.capacity,
                                username: profileProvider.usernameExpect,
                                description: spaceProvider
                                    .spaceSelected!.descriptionMessage,
                                streetAddress:
                                    spaceProvider.spaceSelected!.streetAddress,
                                cityPlace:
                                    spaceProvider.spaceSelected!.cityPlace,
                                isEditMode: spaceProvider.isEditMode,
                                features: spaceProvider.spaceSelected!.features,
                              )
                            : const EditSpaceInfo(),
                        const SizedBox(height: 15),
                        spaceProvider.isEditMode
                            ? EditSpaceField(
                                controller: _nightPriceController,
                                onValueChanged: (newPriceNight) {
                                  int? currentPriceNight =
                                      int.tryParse(newPriceNight);
                                  spaceProvider
                                      .setCurrentPrice(currentPriceNight!);
                                },
                                hintText: 'Precio',
                              )
                            : Text(
                                "Precio por noche: S/.${spaceProvider.spaceSelected!.nightPrice}",
                                style: TextStyle(color: MainTheme.contrast(context)),
                              ),
                        const SizedBox(height: 15),
                        spaceProvider.isEditMode
                            ? EditSpaceField(
                                controller: _featuresController,
                                onValueChanged: (newFeatures) {
                                  spaceProvider
                                      .setFeatures(newFeatures.toString());
                                },
                                hintText: 'Servicios adicionales',
                              )
                            : Text(
                                "Servicios adicionales: ${spaceProvider.spaceSelected!.features}",
                                style: TextStyle(color: MainTheme.contrast(context)),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const MySpaceDetailsActions(),
                  if (isImageToUpdate)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MainTheme.secondary(context),
                              foregroundColor: MainTheme.background(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: _uploadImageToCloudinary,
                          child: const Text("Actualizar Imagen"),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: MainTheme.secondary(context),
              ),
            ),
    );
  }
}
