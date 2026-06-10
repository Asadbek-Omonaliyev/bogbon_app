import 'package:bogbon/Components/Home_Component.dart';
import 'package:bogbon/Pages/bogbon/Plant_Details_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaqlanganPage extends StatefulWidget {
  const SaqlanganPage({super.key});

  @override
  State<SaqlanganPage> createState() => _SaqlanganPageState();
}

class _SaqlanganPageState extends State<SaqlanganPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "O'SIMLIKLARIM",
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black87, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Consumer2<FavoritesProvider, PlantProvider>(
          builder: (context, favoritesProvider, plantProvider, child) {
            final myPlants = plantProvider.plants
                .where((plant) => favoritesProvider.isFavorite(plant.id) || plant.isUserCreated)
                .toList();

            if (myPlants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border, size: 80, color: isDark ? Colors.white24 : Colors.black12),
                    const SizedBox(height: 10),
                    Text(
                      "Hali hech narsa saqlanmagan",
                      style: GoogleFonts.poppins(color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: myPlants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final plant = myPlants[index];
                return HomeComponent(
                  plantModel: plant,
                  heroPrefix: "fav",
                  onTap: () async {
                    final result = await Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => PlantDetailsPage(plant: plant, heroTag: 'fav_plant_${plant.id}')
                      )
                    );
                    if (result == true) {
                      favoritesProvider.refresh();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
