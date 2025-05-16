import 'package:alquilafacil/auth/presentation/screens/login.dart';
import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:alquilafacil/subscriptions/presentation/provider/plan_provider.dart';
import 'package:alquilafacil/subscriptions/presentation/widgets/plan_type_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTypesAvailable extends StatelessWidget {
  const PlanTypesAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Text(
                    "Mejora tu estadía:",
                  style: TextStyle(
                      color: MainTheme.contrast(context),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: planProvider.currentPlans.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index){
                      return  PlanTypeInformation(
                          planName: planProvider.currentPlans[index].name,
                          planPrice: planProvider.currentPlans[index].price,
                          planService: planProvider.currentPlans[index].service,
                          planId: planProvider.currentPlans[index].id
                      );
                    }
                ),
              )
            ],
          ),
        ),

    );
  }
}
