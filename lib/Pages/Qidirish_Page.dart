import 'package:bogbon/Components/Home_Component.dart';
import 'package:bogbon/Pages/Plant_Details_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final String? filterKey;
  const SearchResultsPage({super.key, required this.query, this.filterKey});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<PlantModel> filteredPlants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  void _performSearch() {
    final allPlants = DatabaseService.getAllPlants();
    setState(() {
      filteredPlants = allPlants.where((plant) {
        final searchLower = widget.query.toLowerCase();
        
        // 1. Toifa bo'yicha filtr (Katalogdan kelganda)
        if (widget.filterKey != null) {
          final key = widget.filterKey!.toLowerCase();
          if (key == "all") return true;
          if (key == "indoor") return plant.location == PlantLocation.indoor || plant.location == PlantLocation.both;
          if (key == "outdoor") return plant.location == PlantLocation.outdoor || plant.location == PlantLocation.both;
          return plant.category.toLowerCase().contains(key);
        }

        // 2. Oddiy matnli qidiruv
        if (searchLower == "barcha o‘simliklar" || searchLower == "all") return true;
        
        bool matchesName = plant.name.toLowerCase().contains(searchLower) ||
                          plant.latinName.toLowerCase().contains(searchLower) || 
                          plant.category.toLowerCase().contains(searchLower);
        
        bool matchesDetails = plant.benefits.any((b) => b.toLowerCase().contains(searchLower)) ||
                             plant.tips.any((t) => t.toLowerCase().contains(searchLower));

        return matchesName || matchesDetails;
      }).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        title: Text("Natijalar: \"${widget.query}\"", style: GoogleFonts.poppins(fontSize: 18)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : filteredPlants.isEmpty
              ? Center(child: Text("Hech narsa topilmadi", style: GoogleFonts.poppins(color: isDark ? Colors.white60 : Colors.black54)))
              : ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemCount: filteredPlants.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
                    return HomeComponent(
                      plantModel: plant,
                      heroPrefix: "search_$index",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlantDetailsPage(plant: plant, heroTag: "search_${index}_plant_${plant.id}"))
                      ),
                    );
                  },
                ),
    );
  }
}
