import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'PlantModel.g.dart';

/// =============================================================
/// ENUM'LAR
/// =============================================================

@HiveType(typeId: 1)
enum PlantLocation {
  @HiveField(0)
  indoor,
  @HiveField(1)
  outdoor,
  @HiveField(2)
  both,
}

@HiveType(typeId: 2)
enum DifficultyLevel {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
}

@HiveType(typeId: 3)
enum GrowthRate {
  @HiveField(0)
  slow,
  @HiveField(1)
  medium,
  @HiveField(2)
  fast,
}

@HiveType(typeId: 4)
enum SunlightType {
  @HiveField(0)
  direct,
  @HiveField(1)
  partial,
  @HiveField(2)
  lowLight,
}

/// =============================================================
/// ASOSIY MODEL
/// =============================================================

@HiveType(typeId: 0)
class PlantModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String latinName;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String thumbnailImage;
  @HiveField(6)
  final List<String> galleryImages;
  @HiveField(7)
  final PlantLocation location;
  @HiveField(8)
  final CareModel care;
  @HiveField(9)
  final DifficultyLevel difficulty;
  @HiveField(10)
  final GrowthRate growthRate;
  @HiveField(11)
  final List<String> benefits;
  @HiveField(12)
  final List<String> tips;
  @HiveField(13)
  final List<DiseaseModel> diseases;
  @HiveField(14)
  final List<PestModel> pests;
  @HiveField(15)
  final List<String> propagationMethods;
  @HiveField(16)
  final bool isToxicForPets;
  @HiveField(17)
  final bool isToxicForChildren;
  @HiveField(18)
  final String bloomingSeason;
  @HiveField(19)
  final String flowerColor;
  @HiveField(20)
  final bool isFavorite;
  @HiveField(21)
  final ReminderModel reminders;
  @HiveField(22)
  final DateTime lastWateredAt;
  @HiveField(23)
  final DateTime createdAt;
  @HiveField(24)
  final bool isUserCreated;

  PlantModel({
    required this.id,
    required this.name,
    required this.latinName,
    required this.category,
    required this.description,
    required this.thumbnailImage,
    required this.galleryImages,
    required this.location,
    required this.care,
    required this.difficulty,
    required this.growthRate,
    required this.benefits,
    required this.tips,
    required this.diseases,
    required this.pests,
    required this.propagationMethods,
    required this.isToxicForPets,
    required this.isToxicForChildren,
    required this.bloomingSeason,
    required this.flowerColor,
    required this.isFavorite,
    required this.reminders,
    required this.lastWateredAt,
    required this.createdAt,
    this.isUserCreated = false,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      latinName: json['latin_name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      galleryImages: json['gallery_images'] != null ? List<String>.from(json['gallery_images']) : [],
      location: PlantLocation.values.firstWhere((e) => e.name == json['location'], orElse: () => PlantLocation.indoor),
      care: CareModel.fromJson(json['care'] ?? {}),
      difficulty: DifficultyLevel.values.firstWhere((e) => e.name == json['difficulty'], orElse: () => DifficultyLevel.easy),
      growthRate: GrowthRate.values.firstWhere((e) => e.name == json['growth_rate'], orElse: () => GrowthRate.medium),
      benefits: json['benefits'] != null ? List<String>.from(json['benefits']) : [],
      tips: json['tips'] != null ? List<String>.from(json['tips']) : [],
      diseases: json['diseases'] != null ? (json['diseases'] as List).map((e) => DiseaseModel.fromJson(e)).toList() : [],
      pests: json['pests'] != null ? (json['pests'] as List).map((e) => PestModel.fromJson(e)).toList() : [],
      propagationMethods: json['propagation_methods'] != null ? List<String>.from(json['propagation_methods']) : [],
      isToxicForPets: json['is_toxic_for_pets'] ?? false,
      isToxicForChildren: json['is_toxic_for_children'] ?? false,
      bloomingSeason: json['blooming_season'] ?? '',
      flowerColor: json['flower_color'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      reminders: ReminderModel.fromJson(json['reminders'] ?? {}),
      lastWateredAt: DateTime.tryParse(json['last_water_at'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isUserCreated: json['is_user_created'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latin_name': latinName,
      'category': category,
      'description': description,
      'thumbnail_image': thumbnailImage,
      'gallery_images': galleryImages,
      'location': location.name,
      'care': care.toJson(),
      'difficulty': difficulty.name,
      'growth_rate': growthRate.name,
      'benefits': benefits,
      'tips': tips,
      'diseases': diseases.map((e) => e.toJson()).toList(),
      'pests': pests.map((e) => e.toJson()).toList(),
      'propagation_methods': propagationMethods,
      'is_toxic_for_pets': isToxicForPets,
      'is_toxic_for_children': isToxicForChildren,
      'blooming_season': bloomingSeason,
      'flower_color': flowerColor,
      'is_favorite': isFavorite,
      'reminders': reminders.toJson(),
      'last_water_at': lastWateredAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_user_created': isUserCreated,
    };
  }
}

@HiveType(typeId: 5)
class CareModel {
  @HiveField(0)
  final WateringModel watering;
  @HiveField(1)
  final SunlightModel sunlight;
  @HiveField(2)
  final TemperatureModel temperature;
  @HiveField(3)
  final HumidityModel humidity;
  @HiveField(4)
  final String soilType;
  @HiveField(5)
  final FertilizerModel fertilizer;
  @HiveField(6)
  final RepottingModel repotting;

  const CareModel({
    required this.watering,
    required this.sunlight,
    required this.temperature,
    required this.humidity,
    required this.soilType,
    required this.fertilizer,
    required this.repotting,
  });

  factory CareModel.fromJson(Map<String, dynamic> json) {
    return CareModel(
      watering: WateringModel.fromJson(json['watering'] ?? {}),
      sunlight: SunlightModel.fromJson(json['sunlight'] ?? {}),
      temperature: TemperatureModel.fromJson(json['temperature'] ?? {}),
      humidity: HumidityModel.fromJson(json['humidity'] ?? {}),
      soilType: json['soil_type'] ?? '',
      fertilizer: FertilizerModel.fromJson(json['fertilizer'] ?? {}),
      repotting: RepottingModel.fromJson(json['repotting'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watering': watering.toJson(),
      'sunlight': sunlight.toJson(),
      'temperature': temperature.toJson(),
      'humidity': humidity.toJson(),
      'soil_type': soilType,
      'fertilizer': fertilizer.toJson(),
      'repotting': repotting.toJson(),
    };
  }
}

@HiveType(typeId: 6)
class WateringModel {
  @HiveField(0)
  final int days;
  @HiveField(1)
  final String amount;

  const WateringModel({required this.days, required this.amount});

  factory WateringModel.fromJson(Map<String, dynamic> json) {
    return WateringModel(days: json['days'] ?? 0, amount: json['amount'] ?? '');
  }

  Map<String, dynamic> toJson() => {'days': days, 'amount': amount};
}

@HiveType(typeId: 7)
class SunlightModel {
  @HiveField(0)
  final SunlightType type;
  @HiveField(1)
  final int hours;

  const SunlightModel({required this.type, required this.hours});

  factory SunlightModel.fromJson(Map<String, dynamic> json) {
    return SunlightModel(
      type: SunlightType.values.firstWhere((e) => e.name == json['type'], orElse: () => SunlightType.partial),
      hours: json['hours'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'type': type.name, 'hours': hours};
}

@HiveType(typeId: 8)
class TemperatureModel {
  @HiveField(0)
  final int min;
  @HiveField(1)
  final int max;
  @HiveField(2)
  final int ideal;

  const TemperatureModel({required this.min, required this.max, required this.ideal});

  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(min: json['min'] ?? 0, max: json['max'] ?? 0, ideal: json['ideal'] ?? 0);
  }

  Map<String, dynamic> toJson() => {'min': min, 'max': max, 'ideal': ideal};
}

@HiveType(typeId: 9)
class HumidityModel {
  @HiveField(0)
  final int percent;
  const HumidityModel({required this.percent});
  factory HumidityModel.fromJson(Map<String, dynamic> json) => HumidityModel(percent: json['percent'] ?? 0);
  Map<String, dynamic> toJson() => {'percent': percent};
}

@HiveType(typeId: 10)
class FertilizerModel {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String frequency;
  @HiveField(2)
  final String usage;

  const FertilizerModel({required this.type, required this.frequency, required this.usage});

  factory FertilizerModel.fromJson(Map<String, dynamic> json) {
    return FertilizerModel(
      type: json['type'] ?? '',
      frequency: json['frequency'] ?? '',
      usage: json['usage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'frequency': frequency, 'usage': usage};
}

@HiveType(typeId: 11)
class RepottingModel {
  @HiveField(0)
  final int everyMonths;
  @HiveField(1)
  final String season;
  const RepottingModel({required this.everyMonths, required this.season});
  factory RepottingModel.fromJson(Map<String, dynamic> json) => RepottingModel(everyMonths: json['every_months'] ?? 0, season: json['season'] ?? '');
  Map<String, dynamic> toJson() => {'every_months': everyMonths, 'season': season};
}

@HiveType(typeId: 15)
class TreatmentModel {
  @HiveField(0)
  final String chemical;
  @HiveField(1)
  final String organic;

  const TreatmentModel({required this.chemical, required this.organic});

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      chemical: json['chemical'] ?? '',
      organic: json['organic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'chemical': chemical, 'organic': organic};
}

@HiveType(typeId: 12)
class DiseaseModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String cause;
  @HiveField(2)
  final List<String> symptoms;
  @HiveField(3)
  final TreatmentModel treatment;

  const DiseaseModel({
    required this.name,
    required this.cause,
    required this.symptoms,
    required this.treatment,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      name: json['name'] ?? '',
      cause: json['cause'] ?? '',
      symptoms: json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
      treatment: TreatmentModel.fromJson(json['treatment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'cause': cause,
    'symptoms': symptoms,
    'treatment': treatment.toJson(),
  };
}

@HiveType(typeId: 13)
class PestModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final TreatmentModel treatment;

  const PestModel({required this.name, required this.treatment});

  factory PestModel.fromJson(Map<String, dynamic> json) {
    return PestModel(
      name: json['name'] ?? '',
      treatment: TreatmentModel.fromJson(json['treatment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'treatment': treatment.toJson()};
}

@HiveType(typeId: 14)
class ReminderModel {
  @HiveField(0)
  final int wateringDays;
  @HiveField(1)
  final int fertilizerDays;
  @HiveField(2)
  final int pruningDays;
  const ReminderModel({required this.wateringDays, required this.fertilizerDays, required this.pruningDays});
  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(wateringDays: json['watering_days'] ?? 0, fertilizerDays: json['fertilizer_days'] ?? 0, pruningDays: json['pruning_days'] ?? 0);
  Map<String, dynamic> toJson() => {'watering_days': wateringDays, 'fertilizer_days': fertilizerDays, 'pruning_days': pruningDays};
}
