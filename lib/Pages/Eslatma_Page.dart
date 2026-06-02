import 'package:bogbon/Components/Home_Component.dart';
import 'package:bogbon/Pages/Plant_Details_Page.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EslatmaPage extends StatelessWidget {
  const EslatmaPage({super.key});

  void onTap(BuildContext context, PlantModel plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailsPage(plant: plant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "ESLATMALAR",
          style: GoogleFonts.poppins(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : Colors.black87
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notifProvider, child) {
          if (notifProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          final notificationPlants = notifProvider.notificationPlants;

          if (notificationPlants.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => notifProvider.loadNotificationPlants(),
              child: ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 80, color: isDark ? Colors.white24 : Colors.black12),
                        const SizedBox(height: 20),
                        Text(
                          "Hali eslatmalar yoqilmagan!!",
                          style: TextStyle(fontSize: 18, color: isDark ? Colors.white60 : Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notifProvider.loadNotificationPlants(),
            child: ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: notificationPlants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return HomeComponent(
                  plantModel: notificationPlants[index],
                  heroPrefix: "notif", // Eslatmalar uchun maxsus prefix
                  onTap: () => onTap(context, notificationPlants[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
