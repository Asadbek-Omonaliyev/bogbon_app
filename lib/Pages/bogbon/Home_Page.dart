import 'dart:io';
import 'dart:ui';

import 'package:bogbon/Pages/bogbon/Plant_Scan_Screen.dart';
import 'package:bogbon/Pages/bogbon/Profil_Page.dart';
import 'package:bogbon/Pages/bogbon/Eslatma_Page.dart';
import 'package:bogbon/Pages/bogbon/Home_Page2.dart';
import 'package:bogbon/Pages/bogbon/Katalog.dart';
import 'package:bogbon/Pages/bogbon/Saqlangan_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/WeatherService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:bogbon/servis/provider/ThemeProvider.dart';
import 'package:bogbon/servis/provider/UserProvider.dart';
import 'package:bogbon/servis/provider/CareProvider.dart';
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bogbon/servis/provider/NavigationProvider.dart';
import 'package:provider/provider.dart';

/// Asosiy sahifa

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _checkData() async {
    // Ilovaga kirganda haroratni tekshirish
    WeatherService.checkTemperatureAndNotify();

    // Sug'orilmagan o'simliklarni tekshirish va ko'rsatish
    _checkOverdueWatering();
  }

  Future<void> _checkOverdueWatering() async {
    final careProvider = Provider.of<CareProvider>(context, listen: false);
    await careProvider.syncOverduePlants();
    
    if (careProvider.postponedPlants.isNotEmpty) {
      if (mounted) {
        _showOverdueDialog(careProvider);
      }
    }
  }

  void _showOverdueDialog(CareProvider careProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Icon(Icons.water_drop, color: Colors.blue, size: 50),
            const SizedBox(height: 10),
            Text(
              "Sug'orish vaqti keldi!",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Quyidagi o'simliklaringizni sug'orishni unutmang:",
                style: GoogleFonts.poppins(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: careProvider.postponedPlants.length,
                  itemBuilder: (context, index) {
                    final data = careProvider.postponedPlants[index];
                    final parts = data.split('|');
                    final name = parts.length > 1 ? parts[1] : "O'simlik";
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: const Icon(Icons.water_drop, color: Colors.blue, size: 20),
                      ),
                      title: Text(name, style: GoogleFonts.poppins(fontSize: 14)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: () async {
                          final plant = DatabaseService.getPlantById(parts[0]);
                          if (plant != null) {
                            final updatedPlant = PlantModel(
                              id: plant.id,
                              name: plant.name,
                              latinName: plant.latinName,
                              family: plant.family,
                              category: plant.category,
                              origin: plant.origin,
                              description: plant.description,
                              thumbnailImage: plant.thumbnailImage,
                              galleryImages: plant.galleryImages,
                              location: plant.location,
                              care: plant.care,
                              difficulty: plant.difficulty,
                              growthRate: plant.growthRate,
                              matureSize: plant.matureSize,
                              lifespan: plant.lifespan,
                              seasonalCare: plant.seasonalCare,
                              benefits: plant.benefits,
                              tips: plant.tips,
                              commonProblems: plant.commonProblems,
                              diseases: plant.diseases,
                              pests: plant.pests,
                              propagationMethods: plant.propagationMethods,
                              companionPlants: plant.companionPlants,
                              isToxicForPets: plant.isToxicForPets,
                              isToxicForChildren: plant.isToxicForChildren,
                              flowering: plant.flowering,
                              smartNotifications: plant.smartNotifications,
                              aiContext: plant.aiContext,
                              isFavorite: plant.isFavorite,
                              lastWateredAt: DateTime.now(),
                              createdAt: plant.createdAt,
                              isUserCreated: plant.isUserCreated,
                            );
                            await context.read<PlantProvider>().addPlant(updatedPlant);
                          }
                          await careProvider.incrementWateringCount();
                          await careProvider.removePostponedPlant(data);
                          if (context.mounted) Navigator.pop(context);
                          if (careProvider.postponedPlants.isNotEmpty) {
                            _showOverdueDialog(careProvider);
                          }
                        },
                        child: const Text("Sug'ordim", style: TextStyle(fontSize: 10)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Yopish", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkData();
  }

  final List<Widget> Pages1 = [
    HomePage2(),
    Katalog(),
    EslatmaPage(),
    SaqlanganPage(),
    ProfilPage(),
  ];

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          key: HomePage.scaffoldKey,
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E4D34) : Colors.green.shade700,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: userProvider.profileImagePath != null
                            ? FileImage(File(userProvider.profileImagePath!))
                            : null,
                        child: userProvider.profileImagePath == null
                            ? Icon(Icons.person, size: 40, color: Colors.green.shade700)
                            : null,
                      ),
                      accountName: Text(
                        userProvider.userName,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      accountEmail: Text(
                        "bogbon@gmail.com",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                      ),
                    );
                  },
                ),
                
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(Icons.auto_awesome, "AI Assistant", () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PlantScanScreen()));
                      }, isDark),
                      _buildDrawerItem(Icons.home_outlined, "Bosh sahifa", () {
                        Navigator.pop(context);
                        navProvider.setIndex(0);
                      }, isDark),
                      _buildDrawerItem(Icons.grid_view_rounded, "Bo'limlar", () {
                        Navigator.pop(context);
                        navProvider.setIndex(1);
                      }, isDark),
                      _buildDrawerItem(Icons.notifications_none, "Eslatmalar", () {
                        Navigator.pop(context);
                        navProvider.setIndex(2);
                      }, isDark),
                      _buildDrawerItem(Icons.local_florist_outlined, "O'simliklarim", () {
                        Navigator.pop(context);
                        navProvider.setIndex(3);
                      }, isDark),
                      // const Divider(indent: 20, endIndent: 20),
                      _buildDrawerItem(Icons.settings_outlined, "Sozlamalar", () {
                        Navigator.pop(context);
                        navProvider.setIndex(4);
                      }, isDark),

                      ListTile(
                        leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, 
                          color: isDark ? Colors.greenAccent : Colors.green.shade700),
                        title: Text(isDark ? "Tungi rejim" : "Kundizgi rejim", 
                          style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87)),
                        trailing: Switch(
                          value: isDark,
                          onChanged: (value) => themeProvider.toggleTheme(),
                          activeThumbColor: Colors.greenAccent,
                          activeTrackColor: Colors.green.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bog'bon ilovasi:",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                      Text(
                        "Versiya 1.0.0",
                        style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: navProvider.currentIndex,
              children: Pages1,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: isDark ? const Color(0xFF1E4D34) : Colors.white,
                  elevation: 0,
                  onTap: (index) {
                    navProvider.setIndex(index);
                  },
                  currentIndex: navProvider.currentIndex,
                  selectedLabelStyle: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  selectedItemColor: isDark ? Colors.greenAccent : Colors.green.shade700,
                  unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
                  iconSize: 24,
                  selectedIconTheme: IconThemeData(
                    size: 28, 
                    color: isDark ? Colors.greenAccent : Colors.green.shade700
                  ),
                  unselectedIconTheme: IconThemeData(
                    size: 24,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: "Bosh sahifa",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view_rounded),
                      label: "Bo'limlar",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: "Eslatmalar",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.local_florist_outlined),
                      label: "O'simliklarim",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "Sozlamalar",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
