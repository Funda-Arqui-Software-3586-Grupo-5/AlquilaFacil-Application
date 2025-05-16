import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/subscriptions/presentation/screens/subscription_payment_screen.dart';
import 'package:alquilafacil/subscriptions/presentation/widgets/plan_selected_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../public/ui/theme/main_theme.dart';

class PlanSelectedDetailsScreen extends StatelessWidget {
  final String planName;
  final String planService;
  final int planId;
  final int planPrice;
  const PlanSelectedDetailsScreen({super.key, required this.planName, required this.planService, required this.planId, required this.planPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: MainTheme.primary(context),
        foregroundColor:  Colors.white,
        title: const Text(
          "Información del plan",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
        children: [
        PlanSelectedDetails(
        planName: planName,
            planService: planService,
            id: planId,
            planPrice: planPrice
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MainTheme.secondary(context),
                foregroundColor: MainTheme.background(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionPaymentScreen(planPrice: planPrice)));
              },
              child: const Text("Suscribirse")
          ),
        ),

        ],
      ),
        ),


      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
    );
  }
}
