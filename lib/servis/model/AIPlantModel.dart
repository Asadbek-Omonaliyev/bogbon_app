import 'PlantModel.dart';

class AIPlantModel {
  final String name;
  final String latinName;
  final String category;
  final String description;
  final AIPlantCare care;
  final List<String> tips;
  final double confidence;
  final List<String> benefits;
  final List<String> propagationMethods;
  final List<DiseaseModel> diseases;

  AIPlantModel({
    required this.name,
    required this.latinName,
    required this.category,
    required this.description,
    required this.care,
    required this.tips,
    required this.confidence,
    required this.benefits,
    required this.propagationMethods,
    required this.diseases,
  });

  factory AIPlantModel.fromJson(Map<String, dynamic> json) {
    return AIPlantModel(
      name: json['name'] ?? 'Noma\'lum',
      latinName: json['latin_name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      care: AIPlantCare.fromJson(json['care'] ?? {}),
      tips: List<String>.from(json['tips'] ?? []),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      benefits: List<String>.from(json['benefits'] ?? []),
      propagationMethods: List<String>.from(json['propagation_methods'] ?? []),
      diseases: json['diseases'] != null 
          ? (json['diseases'] as List).map((e) => DiseaseModel.fromJson(e)).toList() 
          : [],
    );
  }
}

class AIPlantCare {
  final String wateringDays;
  final String sunlight;
  final String temperature;
  final FertilizerModel? fertilizer;

  AIPlantCare({
    required this.wateringDays,
    required this.sunlight,
    required this.temperature,
    this.fertilizer,
  });

  factory AIPlantCare.fromJson(Map<String, dynamic> json) {
    return AIPlantCare(
      wateringDays: json['watering_days']?.toString() ?? '',
      sunlight: json['sunlight']?.toString() ?? '',
      temperature: json['temperature']?.toString() ?? '',
      fertilizer: json['fertilizer'] != null ? FertilizerModel.fromJson(json['fertilizer']) : null,
    );
  }
}
