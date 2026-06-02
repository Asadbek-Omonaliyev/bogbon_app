import 'dart:io';
import 'dart:typed_data';
import 'package:bogbon/servis/AIService.dart';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/FileService.dart';
import 'package:bogbon/servis/model/AIPlantModel.dart';
import 'package:bogbon/servis/model/AIDiseaseModel.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum ScanMode { identify, disease }

class PlantScanScreen extends StatefulWidget {
  const PlantScanScreen({super.key});

  @override
  State<PlantScanScreen> createState() => _PlantScanScreenState();
}

class _PlantScanScreenState extends State<PlantScanScreen> {
  final List<File> _selectedImages = [];
  bool _isAnalyzing = false;
  ScanMode _currentMode = ScanMode.identify;
  AIPlantModel? _result;
  AIDiseaseModel? _diseaseResult;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 3) {
      _showError("Maksimal 3 ta rasm yuklash mumkin");
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
        _result = null;
        _diseaseResult = null;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedImages.isEmpty) {
      _showError("Iltimos, kamida bitta rasm yuklang");
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      List<Uint8List> imagesBytes = [];
      for (var file in _selectedImages) {
        imagesBytes.add(await file.readAsBytes());
      }
      
      if (_currentMode == ScanMode.identify) {
        final result = await AIService.identifyPlant(imagesBytes);
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });

        if (result == null || result.name == "Noma'lum") {
          _showError("O'simlikni aniqlab bo'lmadi. Iltimos, boshqa rasm yuklang.");
          setState(() => _result = null);
        } else {
          final permanentPath = await FileService.saveImagePermanently(_selectedImages.first.path);
          final historyPlant = _convertToPlantModel(result, permanentPath, isFavorite: false);
          await DatabaseService.addToHistory(historyPlant);
        }
      } else {
        final result = await AIService.identifyDisease(imagesBytes);
        setState(() {
          _diseaseResult = result;
          _isAnalyzing = false;
        });

        if (result == null || result.plantName == "Noma'lum") {
          _showError("Kasallikni aniqlab bo'lmadi. Iltimos, boshqa rasm yuklang.");
          setState(() => _diseaseResult = null);
        }
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      _showError("Xatolik yuz berdi.");
    }
  }

  PlantModel _convertToPlantModel(AIPlantModel result, String imagePath, {bool isFavorite = false}) {
    return PlantModel(
      id: const Uuid().v4(),
      name: result.name,
      latinName: result.latinName,
      category: result.category,
      description: result.description,
      thumbnailImage: imagePath,
      galleryImages: [],
      location: PlantLocation.indoor,
      care: CareModel(
        watering: WateringModel(
          days: int.tryParse(result.care.wateringDays) ?? 7,
          amount: "O'rtacha",
        ),
        sunlight: SunlightModel(
          type: _parseSunlight(result.care.sunlight),
          hours: 4,
        ),
        temperature: TemperatureModel(
          min: 15,
          max: 30,
          ideal: 22,
        ),
        humidity: const HumidityModel(percent: 50),
        soilType: "Universal",
        fertilizer: result.care.fertilizer ?? const FertilizerModel(type: "Universal", frequency: "Har oy", usage: "O'rtacha"),
        repotting: const RepottingModel(everyMonths: 12, season: "Bahor"),
      ),
      difficulty: DifficultyLevel.medium,
      growthRate: GrowthRate.medium,
      benefits: result.benefits,
      tips: result.tips,
      diseases: result.diseases,
      pests: [],
      propagationMethods: result.propagationMethods,
      isToxicForPets: false,
      isToxicForChildren: false,
      bloomingSeason: "",
      flowerColor: "",
      isFavorite: isFavorite,
      reminders: ReminderModel(
        wateringDays: int.tryParse(result.care.wateringDays) ?? 7,
        fertilizerDays: 30,
        pruningDays: 90,
      ),
      lastWateredAt: DateTime.now(),
      createdAt: DateTime.now(),
      isUserCreated: true,
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galereya'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToMyPlants() async {
    if (_result == null || _selectedImages.isEmpty) return;

    final permanentPath = await FileService.saveImagePermanently(_selectedImages.first.path);
    final plant = _convertToPlantModel(_result!, permanentPath, isFavorite: true);

    await context.read<PlantProvider>().addPlant(plant);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O'simlik kolleksiyangizga qo'shildi!")),
      );
      Navigator.pop(context);
    }
  }

  SunlightType _parseSunlight(String text) {
    text = text.toLowerCase();
    if (text.contains("tik") || text.contains("quyosh") || text.contains("direct")) {
      return SunlightType.direct;
    }
    if (text.contains("kam") || text.contains("yorug'lik") || text.contains("low")) {
      return SunlightType.lowLight;
    }
    return SunlightType.partial;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Mode Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildModeButton(ScanMode.identify, "O'simlikni aniqlash", Icons.eco)),
                  Expanded(child: _buildModeButton(ScanMode.disease, "Kasallikni aniqlash", Icons.bug_report)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Image Preview Area
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: _selectedImages.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            child: Image.file(_selectedImages.first, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        if (_selectedImages.length > 1)
                          Container(
                            height: 80,
                            padding: const EdgeInsets.all(8),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(_selectedImages[index], width: 64, height: 64, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close, size: 12, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentMode == ScanMode.identify ? Icons.camera_alt_outlined : Icons.health_and_safety_outlined,
                          size: 60,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _currentMode == ScanMode.identify 
                            ? "O'simlikni rasmga oling (Maks: 3 ta)" 
                            : "Kasal barglarni rasmga oling (Maks: 3 ta)",
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Controls
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add_a_photo,
                    label: "Rasm qo'shish",
                    onTap: () => _showImageSourceActionSheet(context),
                  ),
                ),
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.analytics,
                      label: "Tahlil qilish",
                      onTap: _analyzeImage,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 30),

            // Results Section
            if (_isAnalyzing)
              Column(
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 15),
                  Text("AI tahlil qilmoqda...", style: GoogleFonts.poppins()),
                ],
              )
            else if (_result != null && _currentMode == ScanMode.identify)
              Column(
                children: [
                  _buildResultCard(isDark),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _saveToMyPlants,
                      icon: const Icon(Icons.add_task),
                      label: const Text("Mening o'simliklarimga qo'shish"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              )
            else if (_diseaseResult != null && _currentMode == ScanMode.disease)
              Column(
                children: [
                  _buildDiseaseResultCard(isDark),
                  const SizedBox(height: 50),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(ScanMode mode, String label, IconData icon) {
    bool isActive = _currentMode == mode;
    return GestureDetector(
      onTap: () => setState(() {
        _currentMode = mode;
        _result = null;
        _diseaseResult = null;
        _selectedImages.clear();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isActive ? Colors.white : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseResultCard(bool isDark) {
    final d = _diseaseResult!;
    return FadeIn(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
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
                      Text(d.diseaseName, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      Text(d.plantName, style: GoogleFonts.poppins(fontSize: 14, color: Colors.green)),
                    ],
                  ),
                ),
                _buildConfidenceBadge(d.confidence),
              ],
            ),
            const Divider(height: 30),
            _buildInfoRow(Icons.coronavirus_outlined, "Alomatlar:", d.symptoms),
            _buildInfoRow(Icons.help_outline, "Sababi:", d.causes),
            const SizedBox(height: 20),
            if (d.treatmentMedicine.isNotEmpty) ...[
              Text("Tavsiya etilgan dori:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue)),
              _buildInfoRow(Icons.medication_liquid_outlined, "Dori:", d.treatmentMedicine),
              const SizedBox(height: 10),
              Text("Tayyorlash va qo'llash:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue)),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 10),
                child: Text(d.medicinePreparation, style: GoogleFonts.poppins(fontSize: 13, height: 1.5)),
              ),
              const SizedBox(height: 20),
            ],
            Text("Davolash usullari:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ...d.solutions.map((s) => _buildListTile(s)),
            const SizedBox(height: 20),
            Text("Oldini olish:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ...d.prevention.map((p) => _buildListTile(p)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    final plant = _result!;
    return FadeIn(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
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
                        plant.name,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        plant.latinName,
                        style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                _buildConfidenceBadge(plant.confidence),
              ],
            ),
            const Divider(height: 30),
            _buildInfoRow(Icons.category, "Tur:", plant.category),
            _buildInfoRow(Icons.description, "Tavsif:", plant.description),
            const SizedBox(height: 20),
            Text("Parvarish qilish:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildCareStat(Icons.water_drop, "Sug'orish", plant.care.wateringDays),
            _buildCareStat(Icons.wb_sunny, "Quyosh", plant.care.sunlight),
            _buildCareStat(Icons.thermostat, "Harorat", plant.care.temperature),
            const SizedBox(height: 20),
            if (plant.tips.isNotEmpty) ...[
              Text("Maslahatlar:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ...plant.tips.map((tip) => _buildListTile(tip)),
            ],
            if (plant.benefits.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text("Foydalari:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ...plant.benefits.map((benefit) => _buildListTile(benefit)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "${(score * 100).toInt()}% aniqlik",
        style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                children: [
                  TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareStat(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green.shade700),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}

// Oddiy FadeIn animatsiyasi
class FadeIn extends StatefulWidget {
  final Widget child;
  const FadeIn({super.key, required this.child});
  @override
  State<FadeIn> createState() => _FadeInState();
}
class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _animation, child: widget.child);
}
