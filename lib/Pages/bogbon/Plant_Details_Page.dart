import 'dart:io';
import 'package:bogbon/Pages/bogbon/Add_Plant_Page.dart';
import 'package:bogbon/Pages/bogbon/Watering_Stats_Page.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/servis/provider/NotificationProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  Future<DateTime?> _showLastWateredDialog(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();

    return showDialog<DateTime>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Sug'orish ma'lumoti", textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.water_drop, size: 50, color: Colors.blue),
              const SizedBox(height: 15),
              const Text(
                  "Ushbu o'simlikni oxirgi marta qachon sug'organsiz?",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                    "Sana: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}"),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate!,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Bekor qilish")),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedDate),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Davom etish"),
            ),
          ],
        ),
      ),
    );
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
                            if (_currentPlant.family.isNotEmpty)
                              Text(
                                "Oila: ${_currentPlant.family}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: isDark ? Colors.white54 : Colors.black54,
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

                  if (_currentPlant.origin.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      children: _currentPlant.origin.map((o) => Chip(
                        label: Text(o, style: const TextStyle(fontSize: 12)),
                        backgroundColor: primaryColor.withOpacity(0.1),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                    const SizedBox(height: 10),
                  ],

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.8,
                    children: [
                      _buildStatCard(
                        Icons.wb_sunny_outlined,
                        "Quyosh",
                        "${_getSunlightText(_currentPlant.care.sunlight.type)} (${_currentPlant.care.sunlight.hours} s)",
                        isDark,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WateringStatsPage(specificPlant: _currentPlant),
                            ),
                          );
                        },
                        child: _buildStatCard(
                          Icons.water_drop_outlined,
                          "Suv",
                          "${_currentPlant.care.watering.days} kunda (${_currentPlant.care.watering.amountMl}ml)",
                          isDark,
                        ),
                      ),
                      _buildStatCard(
                        Icons.thermostat_outlined,
                        "Harorat",
                        "${_currentPlant.care.temperature.ideal}°C (Min: ${_currentPlant.care.temperature.min}°)",
                        isDark,
                      ),
                      _buildStatCard(
                        Icons.height,
                        "O'lchami",
                        "${_currentPlant.matureSize.heightCm}x${_currentPlant.matureSize.widthCm} cm",
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

                  _buildSectionTitle("Parvarish qilish tafsilotlari", isDark),
                  _buildCareDetail(
                    "Sug'orish usuli",
                    "${_currentPlant.care.watering.method}\nMe'yor: ${_currentPlant.care.watering.amountMl} ml\nRisk: ${_currentPlant.care.watering.overwateringRisk}",
                    Icons.water,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Mavsumiy sug'orish",
                    "Yozda: Har ${_currentPlant.care.watering.summerDays} kunda\nQishda: Har ${_currentPlant.care.watering.winterDays} kunda",
                    Icons.calendar_month,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Yorug'lik (Lux)",
                    "Min: ${_currentPlant.care.sunlight.luxMin} lx\nMax: ${_currentPlant.care.sunlight.luxMax} lx",
                    Icons.light_mode,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Tuproq va Drenaj",
                    "Turi: ${_currentPlant.care.soil.type}\npH: ${_currentPlant.care.soil.phMin} - ${_currentPlant.care.soil.phMax}\nDrenaj: ${_currentPlant.care.soil.drainage}",
                    Icons.landscape,
                    isDark,
                  ),
                  _buildCareDetail(
                    "O'g'it (NPK)",
                    "Turi: ${_currentPlant.care.fertilizer.type}\nNPK: ${_currentPlant.care.fertilizer.npk}\nHar ${_currentPlant.care.fertilizer.frequencyDays} kunda",
                    Icons.auto_awesome,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Namlik",
                    "Ideal: ${_currentPlant.care.humidity.ideal}% (Oraliq: ${_currentPlant.care.humidity.min}-${_currentPlant.care.humidity.max}%)",
                    Icons.cloud_queue,
                    isDark,
                  ),
                  _buildCareDetail(
                    "Joylashuv",
                    _getLocationText(_currentPlant.location),
                    Icons.location_on_outlined,
                    isDark,
                  ),
                  if (_currentPlant.lifespan.isNotEmpty)
                    _buildCareDetail(
                      "Umr ko'rish davomiyligi",
                      _currentPlant.lifespan,
                      Icons.hourglass_empty,
                      isDark,
                    ),
                  const SizedBox(height: 30),

                  if (_currentPlant.flowering.season.isNotEmpty) ...[
                    _buildSectionTitle("Gullash", isDark),
                    _buildCareDetail(
                      "Mavsum",
                      _currentPlant.flowering.season,
                      Icons.wb_twilight,
                      isDark,
                    ),
                    _buildCareDetail(
                      "Gul rangi",
                      _currentPlant.flowering.flowerColor,
                      Icons.palette_outlined,
                      isDark,
                    ),
                    _buildCareDetail(
                      "Gullash yoshi",
                      "${_currentPlant.flowering.floweringAgeYears} yoshdan",
                      Icons.cake,
                      isDark,
                    ),
                    const SizedBox(height: 30),
                  ],

                  _buildSectionTitle("Mavsumiy parvarish", isDark),
                  _buildSeasonalExpansion("Bahor", _currentPlant.seasonalCare.spring, Icons.local_florist, Colors.green),
                  _buildSeasonalExpansion("Yoz", _currentPlant.seasonalCare.summer, Icons.sunny, Colors.orange),
                  _buildSeasonalExpansion("Kuz", _currentPlant.seasonalCare.autumn, Icons. whatshot, Colors.brown),
                  _buildSeasonalExpansion("Qish", _currentPlant.seasonalCare.winter, Icons.ac_unit, Colors.blue),
                  const SizedBox(height: 30),

                  if (_currentPlant.commonProblems.isNotEmpty) ...[
                    _buildSectionTitle("Umumiy muammolar", isDark),
                    ..._currentPlant.commonProblems.map((p) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ExpansionTile(
                        leading: const Icon(Icons.report_problem, color: Colors.amber),
                        title: Text(p.problem, style: const TextStyle(fontWeight: FontWeight.bold)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sabab: ${p.cause}", style: const TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                Text("Yechim: ${p.solution}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(height: 30),
                  ],

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

                  if (_currentPlant.companionPlants.isNotEmpty) ...[
                    _buildSectionTitle("Birga ekish tavsiya etiladi", isDark),
                    Wrap(
                      spacing: 8,
                      children: _currentPlant.companionPlants.map((cp) => _buildFeatureChip(cp, Icons.group_work, isDark, color: Colors.purple)).toList(),
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
                        "${p.name} (${p.severity})",
                        "Alomatlar: ${p.symptoms.join(', ')}\nKimyoviy: ${p.treatment.chemical.join(', ')}\nOrganik: ${p.treatment.organic.join(', ')}",
                        Icons.bug_report_outlined,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (_currentPlant.diseases.isNotEmpty) ...[
                    _buildSectionTitle("Kasalliklar", isDark),
                    ..._currentPlant.diseases.map(
                      (d) => _buildCareDetail(
                        "${d.name} (${d.severity})",
                        "Sababi: ${d.cause}\nAlomatlar: ${d.symptoms.join(', ')}\nProfilaktika: ${d.prevention.join(', ')}\nKimyoviy: ${d.treatment.chemical.join(', ')}\nOrganik: ${d.treatment.organic.join(', ')}",
                        Icons.coronavirus_outlined,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  _buildSectionTitle("Aqlli Insight (AI)", isDark),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildAiRow("Turi", _currentPlant.aiContext.plantType, Icons.category),
                        _buildAiRow("Suvga sezgirlik", _currentPlant.aiContext.wateringSensitivity, Icons.opacity),
                        _buildAiRow("Qurg'oqchilikka chidamlilik", _currentPlant.aiContext.droughtTolerance, Icons.wb_sunny),
                        _buildAiRow("Kasallik xavfi", _currentPlant.aiContext.diseaseRisk, Icons.warning),
                        _buildAiRow("Hayvonlar uchun xavfsiz", _currentPlant.aiContext.petFriendly ? "Ha" : "Yo'q", Icons.pets),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

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
                                "Eslatmalar",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Sug'orish: ${_currentPlant.smartNotifications.wateringDays} kun | O'g'it: ${_currentPlant.smartNotifications.fertilizerDays} kun",
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
                              onChanged: (value) async {
                                if (value) {
                                  // Eslatmani yoqishdan oldin oxirgi sug'orilgan vaqtni so'raymiz
                                  final selectedDate = await _showLastWateredDialog(context);
                                  if (selectedDate != null && mounted) {
                                    // O'simlikning oxirgi sug'orilgan vaqtini yangilaymiz
                                    final updatedPlant = _currentPlant.copyWith(lastWateredAt: selectedDate);
                                    await context.read<PlantProvider>().addPlant(updatedPlant);
                                    setState(() {
                                      _currentPlant = updatedPlant;
                                    });
                                    await notifProvider.toggleNotification(updatedPlant, true, lastWateredAt: selectedDate);
                                  }
                                } else {
                                  await notifProvider.toggleNotification(_currentPlant, false);
                                }
                              },
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

  Widget _buildAiRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildSeasonalExpansion(String title, List<String> tasks, IconData icon, Color color) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        children: tasks.map((t) => ListTile(
          dense: true,
          leading: const Icon(Icons.check, size: 16, color: Colors.green),
          title: Text(t, style: const TextStyle(fontSize: 13)),
        )).toList(),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
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
      case SunlightType.bright_indirect:
        return "Yorug' (bilvosita)";
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
