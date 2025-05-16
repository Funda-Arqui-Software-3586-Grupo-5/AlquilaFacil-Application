class Subscription {
  final int planId;
  final int userId;

  Subscription({
     required this.planId,
    required this.userId
  });

  Map<String, dynamic> toJson(){
    return {
      "planId": planId,
      "userId": userId
    };
  }
}
