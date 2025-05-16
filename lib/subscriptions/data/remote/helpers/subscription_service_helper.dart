import 'dart:io';

import 'package:alquilafacil/subscriptions/data/remote/services/subscription_service.dart';
import 'package:alquilafacil/subscriptions/domain/model/subscription.dart';
import 'package:dio/dio.dart';

import '../../../../auth/presentation/providers/SignInPovider.dart';
import '../../../../shared/constants/constant.dart';
import '../../../../shared/handlers/concrete_response_message_handler.dart';

class SubscriptionServiceHelper extends SubscriptionService{
  final errorMessageHandler = ConcreteResponseMessageHandler();
  final SignInProvider signInProvider;
  SubscriptionServiceHelper(this.signInProvider);
  @override
  Future<void> createSubscription(Subscription subscription) async {
    final request = Dio();
    final token = signInProvider.token;
    final options = Options(headers: {'Authorization': 'Bearer $token'});
    final response = await request.post("${Constant.BASE_URL}${Constant.SUBSCRIPTION_PATH}subscriptions", options: options, data: subscription.toJson());
    if (response.statusCode == HttpStatus.ok) {
      return;
    } else {
      throw Exception(errorMessageHandler.reject(response.statusCode!));
    }
  }
  
}