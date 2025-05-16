import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/public/ui/providers/theme_provider.dart';
import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:alquilafacil/spaces/domain/model/space.dart';
import 'package:alquilafacil/spaces/presentation/providers/local_categories_provider.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/search_spaces.dart';
import '../widgets/register_space_steps/register_space_step_1.dart';
import '../widgets/register_space_steps/register_space_step_2.dart';
import '../widgets/register_space_steps/register_space_step_3.dart';
import '../widgets/register_space_steps/register_space_step_4.dart';
import '../widgets/register_space_steps/register_space_step_5.dart';
import '../widgets/register_space_steps/register_space_step_6.dart';
import '../widgets/register_space_steps/register_space_step_7.dart';
import '../widgets/register_space_steps/register_space_step_8.dart';
import '../widgets/register_space_steps/register_space_step_9.dart';

class RegisterSpaceStepsScreen extends StatefulWidget {
  const RegisterSpaceStepsScreen({super.key});

  @override
  _RegisterSpaceStepsState createState() => _RegisterSpaceStepsState();
}

class _RegisterSpaceStepsState extends State<RegisterSpaceStepsScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  int localCategoryId = 0;
  String country = '';
  String city = '';
  String district = '';
  String street = '';
  String photoUrl = '';
  String localName = '';
  String descriptionMessage = '';
  String capacity = '';
  String features = '';
  int price = 0;

  @override
  void initState() {
    super.initState();
    final localCategoriesProvider = context.read<LocalCategoriesProvider>();
    () async {
      await localCategoriesProvider.getAllLocalCategories();
    }();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: MainTheme.background(context),
      appBar: AppBar(
        title: Text('Registrar espacio', style: TextStyle(color: MainTheme.contrast(context)),),
        backgroundColor: themeProvider.isDarkTheme ? MainTheme.primary(context) : MainTheme.background(context),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: MainTheme.contrast(context)),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/search-space');
          },
        ),
      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        children: [
          RegisterSpaceStep1(pageController: _pageController),
          RegisterSpaceStep2(pageController: _pageController),
          RegisterSpaceStep3(
            pageController: _pageController,
            onCategorySelected: (int selectedCategoryId) {
              setState(() {
                localCategoryId = selectedCategoryId;
              });
            },
          ),
          RegisterSpaceStep4(
            pageController: _pageController,
            onAddressChanged: (String country, String city, String district, String street, String number) {
              setState(() {
                this.country = country;
                this.city = city;
                this.district = district;
                this.street = '$street ($number)';
              });
            },
          ),
          RegisterSpaceStep5(pageController: _pageController),
          RegisterSpaceStep6(
            pageController: _pageController,
            photoUrl: photoUrl,
            onPhotoChanged: (String newPhotoUrl) {
              setState(() {
                photoUrl = newPhotoUrl;
              });
            },
          ),
          RegisterSpaceStep7(
            pageController: _pageController,
            localName: localName,
            descriptionMessage: descriptionMessage,
            capacity: capacity,
            features: features,
            onStepDataChanged: (String updatedName, String updatedDescription, String updatedCapacity, String updatedFeatures) {
              setState(() {
                localName = updatedName;
                descriptionMessage = updatedDescription;
                capacity = updatedCapacity;
                features = updatedFeatures;
              });
            },
          ),
          RegisterSpaceStep8(
            pageController: _pageController,
            price: 100,
            onPriceChanged: (newPrice) {
              setState(() {
                price = newPrice;
              });
            },
          ),
          RegisterSpaceStep9(
            pageController: _pageController,
            localCategoryId: localCategoryId,
            country: country,
            city: city,
            district: district,
            street: street,
            photoUrl: photoUrl,
            localName: localName,
            descriptionMessage: descriptionMessage,
            capacity: capacity,
            features: features,
            price: price,
            onFinish: () async  {
              final provider = context.read<SpaceProvider>();
              Space space = Space(
                id: 0,
                userId: 0,
                localCategoryId: localCategoryId,
                country: country,
                cityPlace: city,
                district: district,
                streetAddress: street,
                photoUrl: photoUrl,
                localName: localName,
                descriptionMessage: descriptionMessage,
                capacity: int.parse(capacity),
                features: features,
                nightPrice: price * 1.0,
              );
              try{
                provider.createSpace(space);
              } finally{
                Navigator.pushReplacementNamed(context, '/search-space');
              }
            },
          ),
        ],
      ),
    );
  }
}
