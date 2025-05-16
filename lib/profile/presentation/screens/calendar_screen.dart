import 'package:alquilafacil/public/presentation/widgets/default_calendar_day.dart';
import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:alquilafacil/reservation/presentation/providers/reservation_provider.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../auth/presentation/providers/SignInPovider.dart';
import '../../../reservation/domain/model/reservation.dart';
import '../widgets/event_type_indicator.dart';
import '../widgets/highlighted_calendar_day.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _focusedDay = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final signInProvider = context.read<SignInProvider>();
    final reservationProvider = context.read<ReservationProvider>();
    _loadReservations(signInProvider.userId, reservationProvider);
  }

  Future<void> _loadReservations(int userId, ReservationProvider reservationProvider) async {
    await reservationProvider.getReservationsByUserId(userId);
    await reservationProvider.getOtherUsersReservationsByUserId(userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.watch<ReservationProvider>();
    final spaceProvider = context.watch<SpaceProvider>();

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Calendario')),
        body: Center(child: CircularProgressIndicator(color: MainTheme.secondary(context))),
        bottomNavigationBar: const ScreenBottomAppBar(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/search-space');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "Toca en una fecha para ver más detalles sobre la programación",
            style: TextStyle(color: MainTheme.contrast(context), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          TableCalendar(
            locale: "es_ES",
            rowHeight: 40.0,
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: false,
              defaultTextStyle: TextStyle(color: Colors.grey),
              tableBorder: TableBorder(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            headerStyle: HeaderStyle(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                  left: BorderSide(color: Colors.grey),
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              titleTextStyle: TextStyle(color: MainTheme.contrast(context)),
              formatButtonVisible: false,
              titleCentered: true,
            ),
            daysOfWeekHeight: 40.0,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 09, 01),
            lastDay: DateTime.utc(2025, 09, 30),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return DefaultCalendarDay(day: day);
              },
              outsideBuilder: (context, day, focusedDay) {
                return DefaultCalendarDay(day: day, isOutside: true);
              },
              dowBuilder: (context, day) {
                final text = DateFormat.E("es_ES").format(day);
                final capitalizedText = text.replaceFirst(text[0], text[0].toUpperCase());
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child:  Text(
                      capitalizedText,
                      style: TextStyle(
                          color: MainTheme.contrast(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) {
                final List<Reservation> matchingReservations = reservationProvider.reservations.where(
                      (reservation) => reservation.startDate.year == day.year &&
                      reservation.startDate.month == day.month &&
                      reservation.startDate.day == day.day,
                ).toList();
                final List<Reservation> matchingOtherUsersReservations = reservationProvider.reservationsFromOtherUsers.where(
                      (reservation) => reservation.startDate.year == day.year &&
                      reservation.startDate.month == day.month &&
                      reservation.startDate.day == day.day,
                ).toList();
                if (matchingReservations.isNotEmpty) {
                  final reservation = matchingReservations.first;
                  return HighlightedCalendarDay(
                    day: day,
                    color: Colors.red,
                    onTap: () async {
                      await spaceProvider.fetchSpaceById(reservation.spaceId);
                      Navigator.pushNamed(
                        context,
                        '/reservation-details',
                        arguments: reservation,
                      );
                    },
                  );
                }
                if (matchingOtherUsersReservations.isNotEmpty) {
                  final reservation = matchingOtherUsersReservations.first;
                  return HighlightedCalendarDay(
                    day: day,
                    color: reservation.isSubscribed ?? false ? Colors.amberAccent : Colors.blue,
                    onTap: () async {
                      await spaceProvider.fetchSpaceById(reservation.spaceId);
                      Navigator.pushNamed(
                        context,
                        '/modify-reservation',
                        arguments: reservation,
                      );
                    },
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EventTypeIndicator(color: Colors.red, text: "Reserva"),
                SizedBox(height: 16.0),
                EventTypeIndicator(color: Colors.blue, text: "Reserva de tu espacio"),
                SizedBox(height: 16.0),
                EventTypeIndicator(color: Colors.amberAccent, text: "Reserva de tu espacio por usuario premium"),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
    );
  }
}
