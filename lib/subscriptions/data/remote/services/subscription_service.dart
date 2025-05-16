import '../../../domain/model/subscription.dart';

abstract class SubscriptionService{
  Future<void> createSubscription(Subscription subscription);
}