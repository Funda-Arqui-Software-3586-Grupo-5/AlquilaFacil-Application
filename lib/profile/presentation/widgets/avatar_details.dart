import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../public/ui/theme/main_theme.dart';

class AvatarDetails extends StatelessWidget {
  final String fullName;
  final String photoUrl;
  const AvatarDetails({super.key, required this.fullName, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
               CircleAvatar(
                  backgroundColor: MainTheme.contrast(context),
                  child: Image.network(photoUrl)
                ),
                Positioned(
                  left: 50,
                  top: 65,
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: IconButton(
                      iconSize: 10,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: MainTheme.secondary(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            fullName,
            style:  TextStyle(
                color: MainTheme.contrast(context)
            ),
          ),
        ],
      ),
    );
  }
}
