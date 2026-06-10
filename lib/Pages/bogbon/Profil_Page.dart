import 'dart:io';
import 'dart:ui';
import 'package:bogbon/Pages/bogbon/Add_Plant_Page.dart';
import 'package:bogbon/Pages/bogbon/Plant_Details_Page.dart';
import 'package:bogbon/Pages/bogbon/Saqlangan_Page.dart';
import 'package:bogbon/Pages/shop/Shop_Page.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/Pages/bogbon/Plant_Scan_Screen.dart';
import 'package:bogbon/Pages/bogbon/Watering_Stats_Page.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:bogbon/servis/provider/UserProvider.dart';
import 'package:bogbon/servis/provider/CareProvider.dart';
import 'package:bogbon/servis/FileService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bogbon/servis/provider/ThemeProvider.dart';

import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserData();
    if (mounted) {
      await Provider.of<CareProvider>(context, listen: false).syncOverduePlants();
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final permanentPath = await FileService.saveImagePermanently(image.path);
      if (mounted) {
        await context.read<UserProvider>().updateProfileImage(permanentPath);
      }
    }
  }

  void _editName(String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ismni tahrirlash"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Ismingizni kiriting"),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await context.read<UserProvider>().updateName(controller.text.trim());
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Saqlash"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = Colors.greenAccent;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [

                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [const Color(0xFF1B5E20), const Color(0xFF121212)]
                                : [Colors.green.shade100, Colors.white],
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: accentColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.green,
                                      backgroundImage: userProvider.profileImagePath != null
                                          ? FileImage(File(userProvider.profileImagePath!))
                                          : null,
                                      child: userProvider.profileImagePath == null
                                          ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _editName(userProvider.userName),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: accentColor,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              userProvider.userName,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              "@${userProvider.userName.toLowerCase().replaceAll(' ', '_')}_gardener",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Consumer3<FavoritesProvider, CareProvider, PlantProvider>(
                          builder: (context, favs, careProvider, plantProvider, child) {
                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1.6,
                              children: [
                                _buildStatCard(
                                  plantProvider.plants.length.toString(),
                                  "Jami",
                                  Icons.eco_outlined,
                                  isDark,
                                  null,
                                ),
                                _buildStatCard(
                                  favs.favorites.length.toString(),
                                  "Sevimlilar",
                                  Icons.bookmark_border,
                                  isDark,
                                  null,
                                ),
                                _buildStatCard(
                                  careProvider.totalWaterings.toString(),
                                  "Sug'orishlar",
                                  Icons.water_drop_outlined,
                                  isDark,
                                  null,
                                ),
                                _buildStatCard(
                                  careProvider.postponedPlants.length.toString(),
                                  "Keyinroq",
                                  Icons.history_outlined,
                                  isDark,
                                  null,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),


                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mening o'simliklarim",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddPlantPage(),
                                          ),
                                        );
                                        if (result == true) {
                                          if (mounted) {
                                            context.read<PlantProvider>().loadPlants();
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.green,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SaqlanganPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Hammasi",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: Consumer2<FavoritesProvider, PlantProvider>(
                              builder: (context, favoritesProvider, plantProvider, child) {
                                final myPlants = plantProvider.plants
                                    .where(
                                      (plant) =>
                                          favoritesProvider.isFavorite(plant.id) ||
                                          plant.isUserCreated,
                                    )
                                    .toList();

                                if (myPlants.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "O'simliklar hali yo'q",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 20),
                                  itemCount: myPlants.length,
                                  itemBuilder: (context, index) {
                                    final plant = myPlants[index];
                                    return _buildPlantCard(
                                      plant.name,
                                      plant.difficulty.name == 'easy'
                                          ? "Oson"
                                          : "O'rtacha",
                                      plant.thumbnailImage,
                                      Colors.green,
                                      isDark,
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlantDetailsPage(
                                            plant: plant,
                                            heroTag:
                                                'profile_plant_${plant.name}_${plant.thumbnailImage}',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),


                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                "AI Assistant",
                                "Yordam",
                                Icons.auto_awesome,
                                Colors.green,
                                isDark,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PlantScanScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 5. Settings Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Sozlamalar",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildSettingsTile(
                              Icons.dark_mode_outlined,
                              "Tungi rejim",
                              true,
                              isDark,
                              context,
                            ),
                            // _buildSettingsTile(
                            //   Icons.shopping_bag_outlined,
                            //   "Do'kon",
                            //   null,
                            //   isDark,
                            //   context,
                            // ),
                            _buildSettingsTile(
                              Icons.notifications_outlined,
                              "Bildirishnomalar",
                              false,
                              isDark,
                              context,
                            ),
                            _buildSettingsTile(
                              Icons.history_outlined,
                              "Keyinroq",
                              null,
                              isDark,
                              context,
                            ),
                            _buildSettingsTile(
                              Icons.water_drop_outlined,
                              "Sug'orish jadvali",
                              null,
                              isDark,
                              context,
                            ),
                            _buildSettingsTile(
                              Icons.language_outlined,
                              "Til sozlamalari",
                              null,
                              isDark,
                              context,
                            ),
                            _buildSettingsTile(
                              Icons.privacy_tip_outlined,
                              "Maxfiylik",
                              null,
                              isDark,
                              context,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  void _showPostponedDialog(BuildContext context, CareProvider careProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Kutilayotgan sug'orishlar",
          textAlign: TextAlign.center,
        ),
        content: careProvider.postponedPlants.isEmpty
            ? const Text(
                "Hozircha kutilayotgan o'simliklar yo'q.",
                textAlign: TextAlign.center,
              )
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: careProvider.postponedPlants.length,
                  itemBuilder: (context, index) {
                    final data = careProvider.postponedPlants[index];
                    final parts = data.split('|');
                    final String name = parts.length > 1
                        ? parts[1]
                        : "Noma'lum";
                    final int id = int.tryParse(parts[0]) ?? 0;

                    return ListTile(
                      leading: const Icon(Icons.water_drop, color: Colors.blue),
                      title: Text(name),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: () async {
                          // O'simlikni sug'orilgan deb belgilash
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
                              lastWateredAt: DateTime.now(), // Yangilash
                              createdAt: plant.createdAt,
                              isUserCreated: plant.isUserCreated,
                            );
                            await context.read<PlantProvider>().addPlant(updatedPlant);
                          }
                          
                          await careProvider.incrementWateringCount();
                          await careProvider.removePostponedPlant(data);
                          if (context.mounted) Navigator.pop(context);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("$name sug'orildi!")),
                            );
                          }
                        },
                        child: const Text("Sug'ordim"),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    bool isDark,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: onTap != null
              ? Border.all(color: Colors.green.withOpacity(0.3))
              : null,
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(
    String name,
    String status,
    String img,
    Color statusColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              child: Hero(
                tag: 'profile_plant_${name}_$img',
                child: img.isEmpty
                    ? _buildPlantImagePlaceholder()
                    : img.startsWith('assets/')
                        ? Image.asset(
                            img,
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildPlantImagePlaceholder(),
                          )
                        : Image.file(
                            File(img),
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildPlantImagePlaceholder(),
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImagePlaceholder() {
    return Container(
      color: Colors.green.withOpacity(0.1),
      height: 100,
      width: 140,
      child: const Center(
        child: Icon(Icons.eco_outlined, color: Colors.green, size: 30),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark, [
    VoidCallback? onTap,
  ]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 10, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Maxfiylik siyosati"),
        content: const SingleChildScrollView(
          child: Text(
            "Bog'bon ilovasi sizning maxfiyligingizni qadrlaydi. \n\n"
            "1. Ma'lumotlar to'planishi: Ilova sizning ismingiz va o'simliklaringiz haqidagi ma'lumotlarni faqat qurilmangizning o'zida saqlaydi.\n\n"
            "2. Kamera va Galereya: O'simliklarni aniqlash uchun ruxsat so'raladi. Rasmlar serverga faqat tahlil uchun yuboriladi va saqlanib qolmaydi.\n\n"
            "3. Joylashuv: Ob-havo ma'lumotlarini olish uchun joylashuvingizdan foydalaniladi.\n\n"
            "4. Xavfsizlik: Barcha ma'lumotlar qurilmangizda xavfsiz saqlanadi.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tushunarli"),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tilni tanlang"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("O'zbek tili"),
              leading: const Icon(Icons.check, color: Colors.green),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("English (Tez kunda)"),
              enabled: false,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    bool? value,
    bool isDark,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.03)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () {
          if (title == "Til sozlamalari") {
            _showLanguageDialog();
          } else if (title == "Maxfiylik") {
            _showPrivacyPolicy();
          } else if (title == "Keyinroq") {
            final careProvider = Provider.of<CareProvider>(context, listen: false);
            _showPostponedDialog(context, careProvider);
          } else if (title == "Sug'orish jadvali") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WateringStatsPage(),
              ),
            );
          } else if (title == "Do'kon") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShopPage(),
              ),
            );
          }
        },
        leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 15)),
        trailing: value == null
            ? const Icon(Icons.arrow_forward_ios, size: 14)
            : title == "Tungi rejim"
                ? Consumer<ThemeProvider>(
                    builder: (context, theme, child) => Switch(
                      value: theme.isDark,
                      onChanged: (val) => theme.toggleTheme(),
                      activeColor: Colors.green,
                    ),
                  )
                : Consumer<NotificationProvider>(
                    builder: (context, notif, child) => Switch(
                      value: notif.isGlobalOn,
                      onChanged: (val) => notif.setGlobalNotification(val),
                      activeColor: Colors.green,
                    ),
                  ),
      ),
    );
  }

}
