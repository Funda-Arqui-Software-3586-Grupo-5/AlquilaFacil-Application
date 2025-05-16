import 'package:alquilafacil/public/presentation/widgets/screen_bottom_app_bar.dart';
import 'package:alquilafacil/public/ui/theme/main_theme.dart';
import 'package:alquilafacil/spaces/presentation/providers/local_categories_provider.dart';
import 'package:alquilafacil/spaces/presentation/providers/space_provider.dart';
import 'package:alquilafacil/spaces/presentation/widgets/capacity_filters.dart';
import 'package:alquilafacil/spaces/presentation/widgets/local_category_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../public/ui/providers/theme_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});


  @override
  State<StatefulWidget> createState()  => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>{
  int? selectedIndex;

  Future<void> _showDialog(String dialogTitle, String route) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            dialogTitle,
            style: TextStyle(
                color: MainTheme.contrast(context),
                fontSize: 15.0
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      Navigator.pushNamed(context, route);
                    },
                  ),
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },

    );
  }
  @override
  void initState(){
    super.initState();
    final localCategoriesProvider = context.read<LocalCategoriesProvider>();
    () async {
      await localCategoriesProvider.getAllLocalCategories();
    }();
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localCategoriesProvider = context.watch<LocalCategoriesProvider>();
    final spaceProvider = context.watch<SpaceProvider>();
    final ranges = ["5-10","11-25","26-50","51-150", "151-300"];
    return Scaffold(
      backgroundColor: MainTheme.background(context),
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme ? MainTheme.primary(context) : MainTheme.background(context),
        title: Text(
          "Filtros",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: MainTheme.contrast(context),
          ),
        ),
      ),
      bottomNavigationBar: const ScreenBottomAppBar(),
      body:
          SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                     "Tipos de espacio:",
                     style: TextStyle(
                       color: MainTheme.contrast(context),
                       fontSize: 20.0,
                       fontWeight: FontWeight.bold
                     ),
                     textAlign: TextAlign.start,
                    ),
                  ),
                 GridView.builder(
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                     childAspectRatio: 1.0,
                   ),
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: localCategoriesProvider.localCategories.length,
                   itemBuilder: (context, index) {
                     final category = localCategoriesProvider.localCategories[index];
                     return LocalCategoryCard(
                         id: category.id,
                         name: category.name,
                         photoUrl: category.photoUrl,
                         isSelected: selectedIndex == category.id,
                         onSelect: () => {setState(() {
                           selectedIndex = category.id;
                           spaceProvider.categorySelected = localCategoriesProvider.localCategories[index].id;
                         })},
                     );
                   },
                 ),
                 const SizedBox(height: 20),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: Text(
                     "Capacidad de personas:",
                     style: TextStyle(
                         color: MainTheme.contrast(context),
                         fontSize: 20.0,
                         fontWeight: FontWeight.bold
                     ),
                     textAlign: TextAlign.start,
                   ),
                 ),
                 ListView.builder(
                   itemBuilder: (BuildContext context, int index){
                         return CapacityFilters(
                             range: ranges[index]
                         );
                   },
                   itemCount: 4,
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                 ),
                 Center(
                   child: Container(
                     width: 200,
                     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                     child:
                     TextButton(onPressed: () async {
                         if(spaceProvider.maxRange != 0 || spaceProvider.minRange != 0 || spaceProvider.categorySelected != 0){
                            spaceProvider.getFilterRanges();
                            spaceProvider.searchDistrictsByCategoryIdAndRange();
                            Navigator.pushNamed(
                            context, "/spaces-details"
                           );
                         }
                         else{
                              await _showDialog("Por favor, seleccione los parámetros de búsqueda", "/filter-screen");
                           }
                         },
                           child: const Text("Buscar espacio ", textAlign: TextAlign.center,)
                       ),
                     ),
                 ),
              ],
             ),
           )
    );
  }

}
