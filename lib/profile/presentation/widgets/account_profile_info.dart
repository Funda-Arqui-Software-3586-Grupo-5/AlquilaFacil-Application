import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../public/ui/theme/main_theme.dart';

class AccountProfileInfo extends StatelessWidget {
  final String phoneNumber;
  final String documentNumber;
  final String dateOfBirth;
  const AccountProfileInfo({super.key, required this.phoneNumber, required this.documentNumber, required this.dateOfBirth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 20),
                    Text(
                      "Teléfono: ",
                      style: TextStyle(
                          color: MainTheme.contrast(context)
                      ),
                    )
                  ],
                ),
                Text(
                  phoneNumber,
                  style:  TextStyle(
                      color: MainTheme.contrast(context)
                  ),
                )
              ],
            ),
          const SizedBox(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                  children: [
                    Icon(Icons.account_balance_rounded),
                    SizedBox(width: 20),
                    Text(
                      "Documento: ",
                      style: TextStyle(
                          color: MainTheme.contrast(context)
                      ),
                    )
                  ],
                ),
                Text(
                  documentNumber,
                  style: TextStyle(
                      color: MainTheme.contrast(context)
                  ),
                )
              ],
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(width: 20),
                  Text(
                    "Cumpleaños: ",
                    style: TextStyle(
                        color: MainTheme.contrast(context)
                    ),
                  )
                ],
              ),
              Text(
                dateOfBirth,
                style: TextStyle(
                    color: MainTheme.contrast(context)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
