import '../../../domain/model/reservation.dart';

abstract class ReservationService{
  Future<void> createReservation(int userId, int localId, String startDate, String endDate);
  Future<void> modifyReservation(int reservationId, int userId, int localId, String startDate, String endDate);
  Future<List<Reservation>> getReservationsByUserId(int userId);
  Future<List<Reservation>> getOtherUsersReservationsByUserId(int userId);
}