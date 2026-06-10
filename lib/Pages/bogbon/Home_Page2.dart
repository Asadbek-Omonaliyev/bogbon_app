import 'package:bogbon/Pages/bogbon/Home_Page.dart';
import 'package:bogbon/Pages/bogbon/Plant_Details_Page.dart';
import 'package:bogbon/Components/Home_Component.dart';
import 'package:bogbon/Components/Weather_Component.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<PlantProvider>(
      builder: (context, plantProvider, child) {
        final allPlants = plantProvider.plants;
        
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              floating: true,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HomePage.scaffoldKey.currentState?.openDrawer();
                    },
                    child: Image.asset(
                      "assets/icons/more.png",
                      width: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "BOG'BON",
                    style: GoogleFonts.audiowide(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WeatherComponent(),
                      const SizedBox(height: 25),
                      Text(
                        "Siz uchun tavsiyalar",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = allPlants[index];
                      return HomeComponent(
                        plantModel: plant,
                        heroPrefix: "home_$index",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailsPage(
                              plant: plant,
                              heroTag: "home_${index}_plant_${plant.id}",
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: allPlants.length,
                  ),
                ),
              ),
            ],
          );
        },
    );
  }
}
