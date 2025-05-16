
import 'package:alquilafacil/profile/presentation/providers/pofile_provider.dart';
import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/reservation/presentation/widgets/space_info_actions.dart';
import 'package:alquilafacil/reservation/presentation/widgets/space_info_details.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../public/ui/theme/main_theme.dart';
import '../../domain/model/reservation.dart';
import '../providers/reservation_provider.dart';
import 'payment_screen.dart';

class ModifyReservationScreen extends StatefulWidget {
  const ModifyReservationScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ModifyReservationScreen();
}

class _ModifyReservationScreen extends State<ModifyReservationScreen> {

  late Reservation reservation;
  bool _isInitialized = false;
  int newMinutes = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      reservation = ModalRoute.of(context)!.settings.arguments as Reservation;

      final profileProvider = context.read<ProfileProvider>();
      profileProvider.fetchUsernameExpect(reservation.userId);

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceProvider = context.watch<SpaceProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final reservationProvider = context.watch<ReservationProvider>();
    return Scaffold(
        backgroundColor: MainTheme.background(context),
        appBar: AppBar(
          backgroundColor: MainTheme.primary(context),
          title: Text("Información de la reserva", style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomNavigationBar: const ScreenBottomAppBar(),
        body: SingleChildScrollView(
          child: spaceProvider.spaceSelected != null ?
          Column(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      spaceProvider.spaceSelected!.localName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MainTheme.contrast(context),
                          fontSize: 25.0),
                    ),
                    Text(
                      "${spaceProvider.spaceSelected!.streetAddress},  ${spaceProvider.spaceSelected!.cityPlace}",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: MainTheme.contrast(context), fontSize: 18.0),
                    ),
                    Text(
                      "Aforo: ${spaceProvider.spaceSelected!.capacity} personas",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: MainTheme.helper(context), fontSize: 15.0),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Arrendatario: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MainTheme.contrast(context),
                              fontSize: 18.0,
                            ),
                          ),
                          TextSpan(
                            text: profileProvider.usernameExpect,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: MainTheme.contrast(context),
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Descripción:",
                      style: TextStyle(
                          color: MainTheme.contrast(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                    Text(
                      spaceProvider.spaceSelected!.descriptionMessage,
                      style: TextStyle(color: MainTheme.contrast(context), fontSize: 17.0),
                    ),
                  ],
                ),
                    const SizedBox(height: 20),
                    Text(
                        "Inicia el: ${DateFormat('dd/MM/yyyy').format(reservation.startDate)} a las ${DateFormat('HH:mm').format(reservation.startDate)}",
                        style: TextStyle(
                            color: MainTheme.contrast(context),
                            fontSize: 15
                        )
                    ),
                    const SizedBox(height: 20),
                    Text(
                        "Termina el: ${DateFormat('dd/MM/yyyy').format(reservation.endDate)} a las ${DateFormat('HH:mm').format(reservation.endDate)}",
                        style: TextStyle(
                            color: MainTheme.contrast(context),
                            fontSize: 15
                        )
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: reservation.startDate.isAfter(DateTime.now())
                          ? (reservation.isSubscribed ?? false)
                          ? Center(
                        child: Text(
                          "Debido a que lo reservó un usuario premium, no se puede modificar",
                          style: TextStyle(
                            color: MainTheme.primary(context),
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : TextButton(
                        child: const Text(
                          "Modifica el horario de reserva",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Modificar horario de reserva"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Seleccione cuánto tiempo desea posponer:",
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,2}$')),
                                      ],
                                      controller: TextEditingController(text: newMinutes.toString()),
                                      onChanged: (value) {
                                        int? parsedValue = int.tryParse(value);
                                        if (parsedValue != null && parsedValue >= 10 && parsedValue <= 60) {
                                          setState(() {
                                            newMinutes = parsedValue;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Minutos a posponer",
                                        hintText: "Entre 10 y 60 minutos",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var newStartDate = reservation.startDate.add(Duration(minutes: newMinutes));
                                      var newEndDate = reservation.endDate.add(Duration(minutes: newMinutes));
                                      await reservationProvider.modifyReservation(reservation.id, reservation.userId, reservation.spaceId, newStartDate.toIso8601String(), newEndDate.toIso8601String());
                                      Navigator.pushReplacementNamed(context, '/calendar');
                                    },
                                    child: const Text("Confirmar"),
                                  ),
                                ],
                              );
                            },
                          );

                        },
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ) : Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Text(
                "No hay espacio seleccionado",
                style: TextStyle(
                    color: MainTheme.contrast(context),
                    fontSize: 20.0
                ),
              ),
            ),
          ),
        )
    );
  }
}
