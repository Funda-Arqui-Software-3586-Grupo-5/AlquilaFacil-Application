import 'package:alquilafacil/auth/presentation/providers/SignInPovider.dart';
import 'package:alquilafacil/auth/presentation/screens/login.dart';
import 'package:alquilafacil/profile/presentation/providers/pofile_provider.dart';
import 'package:alquilafacil/profile/presentation/widgets/profile_details_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../public/ui/theme/main_theme.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState(){
    super.initState();
    () async {
        final signInProvider = context.read<SignInProvider>();
        final profileProvider = context.read<ProfileProvider>();
        await profileProvider.fetchProfileByUserId(signInProvider.userId);
        Logger().i(profileProvider.currentProfile!.name);
    }();
  }
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: MainTheme.primary(context),
      appBar: AppBar(
        backgroundColor: MainTheme.background(context),
        title:  Text("Mi perfil", style: TextStyle(color: MainTheme.contrast(context)),),
      ),
      body: profileProvider.currentProfile != null ?  SingleChildScrollView(
          child:  ProfileDetailsInfo(
            fullName: "${profileProvider.currentProfile!.name}  ${profileProvider.currentProfile!.fatherName} ${profileProvider.currentProfile!.motherName}",
            phoneNumber: profileProvider.currentProfile!.phoneNumber,
            documentNumber: profileProvider.currentProfile!.documentNumber,
            dateOfBirth: profileProvider.currentProfile!.dateOfBirth,
            photoUrl: profileProvider.currentProfile!.photoUrl,
          )
      ) :  Center(
        child: CircularProgressIndicator(
          color: MainTheme.secondary(context),
        ),
      ),
    );
  }
}
