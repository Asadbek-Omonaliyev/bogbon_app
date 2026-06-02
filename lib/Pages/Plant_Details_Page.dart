import 'dart:io';
import 'package:bogbon/Pages/Add_Plant_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlantDetailsPage extends StatefulWidget {
  final PlantModel plant;
  final String heroTag;

  const PlantDetailsPage({super.key, required this.plant, this.heroTag = ""});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  late PlantModel _currentPlant;

  @override
  void initState() {
    super.initState();
    _currentPlant = widget.plant;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 10),
            const Text("O'chirish"),
          ],
        ),
        content: Text(
          "${_currentPlant.name}ni kolleksiyadan o'chirib tashlamoqchimisiz?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Bekor qilish",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final plantName = _currentPlant.name;
              // Dialog va Details sahifasini yopish
              Navigator.pop(context); // Dialog

              await context.read<PlantProvider>().deletePlant(_currentPlant.id);

              if (mounted) {
                Provider.of<FavoritesProvider>(
                  context,
                  listen: false,
                ).refresh();
                Navigator.pop(context, true); // Details page

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$plantName o'chirib tashlandi"),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: const Text("O'chirish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.green;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            actions: _currentPlant.isUserCreated
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddPlantPage(editPlant: _currentPlant),
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            _currentPlant = DatabaseService.getPlantById(
                              _currentPlant.id,
                            )!;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      onPressed: _confirmDelete,
                    ),
                    const SizedBox(width: 10),
                  ]
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.heroTag.isEmpty
                    ? 'plant_${_currentPlant.id}'
                    : widget.heroTag,
                child: _currentPlant.thumbnailImage.isEmpty
                    ? _buildImagePlaceholder()
                    : _currentPlant.thumbnailImage.startsWith('assets/')
                        ? Image.asset(
                            _currentPlant.thumbnailImage,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildImagePlaceholder(),
                          )
                        : Image.file(
                            File(_currentPlant.thumbnailImage),
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _buildImagePlaceholder(),
                          ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentPlant.name,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (_currentPlant.latinName.isNotEmpty)
                              Text(
                                _currentPlant.latinName,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: primaryColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _buildTag(
                        _currentPlant.difficulty.name == "easy"
                            ? "Oson"
                            : _currentPlant.difficulty.name == "medium"
                            ? "O'rtacha"
                            : "Qiyin",
                        _currentPlant.difficulty.name == "easy"
                            ? Colors.blue
                            : _currentPlant.difficulty.name == "medium"
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _buildStatCard(
                        Icons.wb_sunny_outlined,
                        "Quyosh",
                        "${_getSunlightText(_currentPlant.care.sunlight.type)}\n(${_currentPlant.care.sunlight.hours} soat)",
                        isDark,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        Icons.water_drop_outlined,
                        "Suv",
                        "${_currentPlant.care.watering.days} kunda\n(${_currentPlant.care.watering.amount})",
                        isDark,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        Icons.thermostat_outlined,
                        "Harorat",
                        "${_currentPlant.care.temperature.min}-${_currentPlant.care.temperature.max}°C\n(Ideal: ${_currentPlant.care.temperature.ideal}°)",
                        isDark,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        Icons.speed,
                        "O'sish",
                        _getGrowthRateText(_currentPlant.growthRate),
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Tavsif", isDark),
                  Text(
                    _currentPlant.description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Parvarish qilish", isDark),
                  _buildCareDetail(
                    "Tuproq",
                    _currentPlant.care.soilType,
                    Icons.landscape,
                    isDark,
                  ),
                  _buildCareDetail(
                    "O'g'it",
                    "${_currentPlant.care.fertilizer.type} (${_currentPlant.care.fertilizer.frequency})${_currentPlant.care.fertilizer.usage.isNotEmpty ? '\nQo\'llash: ${_currentPlant.care.fertilizer.usage}' : ''}",
                    Icons.auto_awesome,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Namlik",
                    "${_currentPlant.care.humidity.percent}%",
                    Icons.cloud_queue,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Qayta ekish",
                    "Har ${_currentPlant.care.repotting.everyMonths} oyda (${_currentPlant.care.repotting.season})",
                    Icons.refresh,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Joylashuv",
                    _getLocationText(_currentPlant.location),
                    Icons.location_on_outlined,
                    isDark,
                  ),
                  if (_currentPlant.bloomingSeason.isNotEmpty)
                    _buildCareDetail(
                      "Gullash mavsumi",
                      _currentPlant.bloomingSeason,
                      Icons.wb_twilight,
                      isDark,
                    ),
                  if (_currentPlant.flowerColor.isNotEmpty)
                    _buildCareDetail(
                      "Gul rangi",
                      _currentPlant.flowerColor,
                      Icons.palette_outlined,
                      isDark,
                    ),
                  const SizedBox(height: 30),

                  if (_currentPlant.isToxicForPets ||
                      _currentPlant.isToxicForChildren) ...[
                    _buildSectionTitle("Xavfsizlik ⚠️", isDark),
                    if (_currentPlant.isToxicForPets)
                      _buildWarningChip("Uy hayvonlari uchun zararli", isDark),
                    if (_currentPlant.isToxicForChildren)
                      _buildWarningChip("Bolalar uchun zararli", isDark),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.benefits.isNotEmpty) ...[
                    _buildSectionTitle("Foydalari", isDark),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentPlant.benefits
                          .map(
                            (b) => _buildFeatureChip(
                              b,
                              Icons.check_circle_outline,
                              isDark,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.tips.isNotEmpty) ...[
                    _buildSectionTitle("Maslahatlar", isDark),
                    ..._currentPlant.tips.map(
                      (tip) => _buildInfoRow(
                        Icons.lightbulb_outline,
                        tip,
                        Colors.amber,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.galleryImages.length > 1) ...[
                    _buildSectionTitle("Galereya", isDark),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _currentPlant.galleryImages.length,
                        itemBuilder: (context, index) {
                          final img = _currentPlant.galleryImages[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: img.startsWith('assets/')
                                    ? AssetImage(img) as ImageProvider
                                    : FileImage(File(img)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.propagationMethods.isNotEmpty) ...[
                    _buildSectionTitle("Ko'paytirish usullari", isDark),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentPlant.propagationMethods
                          .map(
                            (m) => _buildFeatureChip(
                              m,
                              Icons.control_point_duplicate_outlined,
                              isDark,
                              color: Colors.blue,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.pests.isNotEmpty) ...[
                    _buildSectionTitle("Zararkunandalar", isDark),
                    ..._currentPlant.pests.map(
                      (p) => _buildCareDetail(
                        p.name,
                        "Kimyoviy: ${p.treatment.chemical}\nOrganik: ${p.treatment.organic}",
                        Icons.bug_report_outlined,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.diseases.isNotEmpty) ...[
                    _buildSectionTitle("Mumkin bo'lgan kasalliklar", isDark),
                    ..._currentPlant.diseases.map(
                      (d) => _buildCareDetail(
                        d.name,
                        "Sababi: ${d.cause}\nAlomatlar: ${d.symptoms.join(', ')}\nKimyoviy: ${d.treatment.chemical}\nOrganik: ${d.treatment.organic}",
                        Icons.coronavirus_outlined,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Eslatma",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Har ${_currentPlant.reminders.wateringDays} kunda sug'orish haqida eslatish",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<NotificationProvider>(
                          builder: (context, notifProvider, child) {
                            return Switch(
                              value: notifProvider.isNotificationOn(
                                _currentPlant.id,
                              ),
                              activeColor: Colors.green,
                              onChanged: (value) => notifProvider
                                  .toggleNotification(_currentPlant, value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.green.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.eco_outlined, size: 100, color: Colors.green),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCareDetail(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    Color iconColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(
    String label,
    IconData icon,
    bool isDark, {
    Color? color,
  }) {
    final themeColor = color ?? Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        border: Border.all(color: themeColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: themeColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningChip(String text, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSunlightText(SunlightType type) {
    switch (type) {
      case SunlightType.direct:
        return "To'g'ridan-to'g'ri";
      case SunlightType.partial:
        return "Qisman soya";
      case SunlightType.lowLight:
        return "Kam yorug'lik";
      default:
        return "Noma'lum";
    }
  }

  String _getGrowthRateText(GrowthRate rate) {
    switch (rate) {
      case GrowthRate.slow:
        return "Sekin";
      case GrowthRate.medium:
        return "O'rtacha";
      case GrowthRate.fast:
        return "Tez";
      default:
        return "Noma'lum";
    }
  }

  String _getLocationText(PlantLocation location) {
    switch (location) {
      case PlantLocation.indoor:
        return "Ichkarida (Uyda)";
      case PlantLocation.outdoor:
        return "Tashqarida (Hovlida)";
      case PlantLocation.both:
        return "Ikkala joyda ham";
      default:
        return "Noma'lum";
    }
  }
}
