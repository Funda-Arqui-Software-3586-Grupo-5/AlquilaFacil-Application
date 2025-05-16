import 'package:alquilafacil/subscriptions/data/remote/helpers/subscription_service_helper.dart';
import 'package:alquilafacil/subscriptions/domain/model/subscription.dart';
import 'package:flutter/cupertino.dart';

class SubscriptionProvider extends ChangeNotifier{
  final SubscriptionServiceHelper subscriptionService;
  SubscriptionProvider(this.subscriptionService);

  Future<void> createSubscription(Subscription subscription) async {
    await subscriptionService.createSubscription(subscription);
    notifyListeners();
  }
}