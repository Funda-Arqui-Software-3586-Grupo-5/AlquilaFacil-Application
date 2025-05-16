import 'dart:ui';

import 'package:alquilafacil/auth/presentation/providers/SignInPovider.dart';
import 'package:alquilafacil/profile/presentation/providers/pofile_provider.dart';
import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/reservation/presentation/widgets/space_info_actions.dart';
import 'package:alquilafacil/reservation/presentation/widgets/space_info_details.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../public/presentation/widgets/custom_dialog.dart';
import '../../../public/ui/theme/main_theme.dart';
import 'payment_screen.dart';

class SpaceInfo extends StatefulWidget {
  const SpaceInfo({super.key});
  @override
  State<StatefulWidget> createState() => _SpaceInfoState();
}

class _SpaceInfoState extends State<SpaceInfo> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  Future<void> _showDatePicker(BuildContext context, bool isStart) async {
    DateTime initialDateTime = isStart
        ? (_startDateTime ?? DateTime.now())
        : (_endDateTime ?? DateTime.now());

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    if (isStart) {
                      _startDateTime = dateTime;
                    } else {
                      _endDateTime = dateTime;
                    }
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Confirmar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final spaceProvider = context.watch<SpaceProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: MainTheme.background(context),
      appBar: AppBar(
        backgroundColor: MainTheme.primary(context),
        title: const Text(
          "Información del espacio",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
      body: SingleChildScrollView(
        child: spaceProvider.spaceSelected != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              spaceProvider.spaceSelected!.photoUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpaceInfoDetails(
                    localName: spaceProvider.spaceSelected!.localName,
                    capacity: spaceProvider.spaceSelected!.capacity,
                    username: profileProvider.usernameExpect,
                    description:
                    spaceProvider.spaceSelected!.descriptionMessage,
                    streetAddress:
                    spaceProvider.spaceSelected!.streetAddress,
                    cityPlace: spaceProvider.spaceSelected!.cityPlace,
                    isEditMode: false,
                    features: spaceProvider.spaceSelected!.features,
                  ),
                  const SizedBox(height: 20),
                  const SpaceInfoActions(),
                  const SizedBox(height: 20),
                  Text(
                    "Horario de reserva:",
                    style: TextStyle(
                        color: MainTheme.contrast(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showDatePicker(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              _startDateTime != null
                                  ? DateFormat('dd/MM/yyyy HH:mm')
                                  .format(_startDateTime!)
                                  : 'Fecha y hora de inicio',
                              style: TextStyle(
                                  color: MainTheme.contrast(context),
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '-',
                          style: TextStyle(
                            fontSize: 30,
                            color: MainTheme.contrast(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () => _showDatePicker(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: Text(
                              _endDateTime != null
                                  ? DateFormat('dd/MM/yyyy HH:mm')
                                  .format(_endDateTime!)
                                  : 'Fecha y hora de fin',
                              style: TextStyle(
                                  color: MainTheme.contrast(context),
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_startDateTime == null ||
                            _endDateTime == null) {

                          await showDialog(context: context, builder: (_) => const CustomDialog(title: "Por favor selecciona las fechas y horas de inicio y fin válidas", route:"/space-info"));
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentScreen(
                                  amount: spaceProvider.spaceSelected!
                                      .nightPrice,
                                  startDate:
                                  _startDateTime!.toIso8601String(),
                                  endDate: _endDateTime!.toIso8601String(),
                                  localName:
                                  spaceProvider.spaceSelected!.localName,
                                  userId:
                                  spaceProvider.spaceSelected!.userId!,
                                  localId: spaceProvider.spaceSelected!.id,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size(350, 50),
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reservar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text(
              "No hay espacio seleccionado",
              style: TextStyle(
                  color: MainTheme.contrast(context), fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}