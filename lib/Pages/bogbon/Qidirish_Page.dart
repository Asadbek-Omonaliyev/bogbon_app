import 'package:bogbon/Components/Home_Component.dart';
import 'package:bogbon/Pages/bogbon/Plant_Details_Page.dart';
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
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _performSearch(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final allPlants = DatabaseService.getAllPlants();
    setState(() {
      filteredPlants = allPlants.where((plant) {
        final searchLower = query.toLowerCase();
        
        // 1. Toifa bo'yicha filtr (Katalogdan kelganda)
        if (widget.filterKey != null && query == widget.query) {
          final key = widget.filterKey!.toLowerCase();
          if (key == "all") return true;
          if (key == "indoor") return plant.location == PlantLocation.indoor || plant.location == PlantLocation.both;
          if (key == "outdoor") return plant.location == PlantLocation.outdoor || plant.location == PlantLocation.both;
          return plant.category.toLowerCase().contains(key);
        }

        // 2. Oddiy matnli qidiruv
        if (searchLower.isEmpty) return true;
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
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: false,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: "O'simlikni qidirish...",
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              _performSearch(value);
            },
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  _searchController.clear();
                  _performSearch("");
                },
              ),
            ),
        ],
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
