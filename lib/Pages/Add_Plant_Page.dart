import 'dart:io';
import 'package:bogbon/servis/DatabaseService.dart';
import 'package:bogbon/servis/FileService.dart';
import 'package:bogbon/servis/WeatherService.dart';
import 'package:bogbon/servis/model/PlantModel.dart';
import 'package:bogbon/servis/provider/FavoritesProvider.dart';
import 'package:bogbon/servis/provider/PlantProvider.dart';
import 'package:bogbon/servis/shared_preferences/Shared_preferens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPlantPage extends StatefulWidget {
  final PlantModel? editPlant;
  const AddPlantPage({super.key, this.editPlant});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descController;
  late TextEditingController _wateringController;
  late TextEditingController _minTempController;
  late TextEditingController _maxTempController;
  late TextEditingController _idealTempController;
  
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late DifficultyLevel _difficulty;
  late PlantLocation _location;

  @override
  void initState() {
    super.initState();
    final p = widget.editPlant;
    _nameController = TextEditingController(text: p?.name ?? "");
    _categoryController = TextEditingController(text: p?.category ?? "");
    _descController = TextEditingController(text: p?.description ?? "");
    _wateringController = TextEditingController(text: p?.care.watering.days.toString() ?? '7');
    _minTempController = TextEditingController(text: p?.care.temperature.min.toString() ?? '15');
    _maxTempController = TextEditingController(text: p?.care.temperature.max.toString() ?? '30');
    _idealTempController = TextEditingController(text: p?.care.temperature.ideal.toString() ?? '22');
    _difficulty = p?.difficulty ?? DifficultyLevel.easy;
    _location = p?.location ?? PlantLocation.indoor;
    if (p?.thumbnailImage != null && !p!.thumbnailImage.startsWith('assets/')) {
      _image = File(p.thumbnailImage);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  Future<void> _savePlant() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.editPlant != null;
      final plantId = isEdit ? widget.editPlant!.id : const Uuid().v4();
      
      // Rasmni doimiy xotiraga saqlash
      String finalImagePath = widget.editPlant?.thumbnailImage ?? "";
      if (_image != null) {
        // Agar rasm o'zgargan bo'lsa (yoki yangi bo'lsa)
        if (!isEdit || _image!.path != widget.editPlant!.thumbnailImage) {
          finalImagePath = await FileService.saveImagePermanently(_image!.path);
        }
      }

      final plant = PlantModel(
        id: plantId,
        name: _nameController.text.trim(),
        latinName: widget.editPlant?.latinName ?? "",
        category: _categoryController.text.trim(),
        description: _descController.text.trim(),
        thumbnailImage: finalImagePath,
        galleryImages: widget.editPlant?.galleryImages ?? [],
        location: _location,
        care: CareModel(
          watering: WateringModel(days: int.tryParse(_wateringController.text) ?? 7, amount: "O'rtacha"),
          sunlight: widget.editPlant?.care.sunlight ?? const SunlightModel(type: SunlightType.partial, hours: 4),
          temperature: TemperatureModel(
            min: int.tryParse(_minTempController.text) ?? 15,
            max: int.tryParse(_maxTempController.text) ?? 35,
            ideal: int.tryParse(_idealTempController.text) ?? 22,
          ),
          humidity: widget.editPlant?.care.humidity ?? const HumidityModel(percent: 50),
          soilType: widget.editPlant?.care.soilType ?? "Universal",
          fertilizer: widget.editPlant?.care.fertilizer ?? const FertilizerModel(type: "Universal", frequency: "Har oy", usage: "O'rtacha"),
          repotting: widget.editPlant?.care.repotting ?? const RepottingModel(everyMonths: 12, season: "Bahor"),
        ),
        difficulty: _difficulty,
        growthRate: widget.editPlant?.growthRate ?? GrowthRate.medium,
        benefits: widget.editPlant?.benefits ?? [],
        tips: widget.editPlant?.tips ?? [],
        diseases: widget.editPlant?.diseases ?? [],
        pests: widget.editPlant?.pests ?? [],
        propagationMethods: widget.editPlant?.propagationMethods ?? [],
        isToxicForPets: widget.editPlant?.isToxicForPets ?? false,
        isToxicForChildren: widget.editPlant?.isToxicForChildren ?? false,
        bloomingSeason: widget.editPlant?.bloomingSeason ?? "",
        flowerColor: widget.editPlant?.flowerColor ?? "",
        isFavorite: widget.editPlant?.isFavorite ?? true,
        reminders: ReminderModel(
          wateringDays: int.tryParse(_wateringController.text) ?? 7,
          fertilizerDays: 30,
          pruningDays: 90,
        ),
        lastWateredAt: widget.editPlant?.lastWateredAt ?? DateTime.now(),
        createdAt: widget.editPlant?.createdAt ?? DateTime.now(),
        isUserCreated: true,
      );

      await context.read<PlantProvider>().addPlant(plant);

      // Yangi o'simlik uchun eslatmalarni avtomatik yoqish (agar tahrirlash bo'lmasa)
      if (!isEdit) {
        await SharedPreferens.setNotification(plantId, true);
      }

      // Haroratni darhol tekshirish
      WeatherService.checkTemperatureAndNotify();
      
      if (mounted) {
        if (!isEdit) {
           await Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(plantId);
        }
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? "O'simlik tahrirlandi!" : "O'simlik qo'shildi!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editPlant == null ? "Yangi o'simlik" : "Tahrirlash", style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _buildLabel("O'simlik nomi"),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Masalan: Aloe Vera"),
                validator: (v) => v!.isEmpty ? "Nomini kiriting" : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Toifasi"),
              TextFormField(
                controller: _categoryController,
                decoration: _inputDecoration("Masalan: Uy o'simligi"),
                validator: (v) => v!.isEmpty ? "Toifasini kiriting" : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Tavsif"),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputDecoration("O'simlik haqida qisqacha..."),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Sug'orish (kunda)"),
                        TextFormField(
                          controller: _wateringController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("7"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Ideal Harorat (°C)"),
                        TextFormField(
                          controller: _idealTempController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("22"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Min Harorat (°C)"),
                        TextFormField(
                          controller: _minTempController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("15"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Max Harorat (°C)"),
                        TextFormField(
                          controller: _maxTempController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("35"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildLabel("Qiyinchilik darajasi"),
              DropdownButtonFormField<DifficultyLevel>(
                value: _difficulty,
                items: DifficultyLevel.values.map((l) => DropdownMenuItem(
                  value: l,
                  child: Text(l.name.toUpperCase()),
                )).toList(),
                onChanged: (v) => setState(() => _difficulty = v!),
                decoration: _inputDecoration(""),
              ),
              const SizedBox(height: 20),

              _buildLabel("Joylashuv"),
              SegmentedButton<PlantLocation>(
                segments: const [
                  ButtonSegment(value: PlantLocation.indoor, label: Text("Ichkarida"), icon: Icon(Icons.home)),
                  ButtonSegment(value: PlantLocation.outdoor, label: Text("Tashqarida"), icon: Icon(Icons.wb_sunny)),
                ],
                selected: {_location},
                onSelectionChanged: (val) => setState(() => _location = val.first),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _savePlant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(widget.editPlant == null ? "Saqlash" : "Yangilash", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
