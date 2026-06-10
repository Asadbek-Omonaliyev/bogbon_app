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
  @HiveField(3)
  bright_indirect,
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
  @HiveField(25) // Yangi maydon
  final String family;
  @HiveField(3)
  final String category;
  @HiveField(26) // Yangi maydon (List<String> ga o'zgardi)
  final List<String> origin;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String thumbnailImage;
  @HiveField(6)
  final List<String> galleryImages;
  @HiveField(7)
  final PlantLocation location;
  @HiveField(9)
  final DifficultyLevel difficulty;
  @HiveField(10)
  final GrowthRate growthRate;
  @HiveField(27) // Yangi maydon
  final MatureSizeModel matureSize;
  @HiveField(28) // Yangi maydon
  final String lifespan;
  @HiveField(8)
  final CareModel care;
  @HiveField(29) // Yangi maydon
  final SeasonalCareModel seasonalCare;
  @HiveField(11)
  final List<String> benefits;
  @HiveField(12)
  final List<String> tips;
  @HiveField(30) // Yangi maydon
  final List<CommonProblemModel> commonProblems;
  @HiveField(13)
  final List<DiseaseModel> diseases;
  @HiveField(14)
  final List<PestModel> pests;
  @HiveField(15)
  final List<String> propagationMethods;
  @HiveField(31) // Yangi maydon
  final List<String> companionPlants;
  @HiveField(16)
  final bool isToxicForPets;
  @HiveField(17)
  final bool isToxicForChildren;
  @HiveField(32) // Yangi maydon
  final FloweringModel flowering;
  @HiveField(21) // smartNotifications ga o'zgartirildi
  final SmartNotificationsModel smartNotifications;
  @HiveField(33) // Yangi maydon
  final AiContextModel aiContext;
  
  @HiveField(20)
  final bool isFavorite;
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
    required this.family,
    required this.category,
    required this.origin,
    required this.description,
    required this.thumbnailImage,
    required this.galleryImages,
    required this.location,
    required this.difficulty,
    required this.growthRate,
    required this.matureSize,
    required this.lifespan,
    required this.care,
    required this.seasonalCare,
    required this.benefits,
    required this.tips,
    required this.commonProblems,
    required this.diseases,
    required this.pests,
    required this.propagationMethods,
    required this.companionPlants,
    required this.isToxicForPets,
    required this.isToxicForChildren,
    required this.flowering,
    required this.smartNotifications,
    required this.aiContext,
    required this.isFavorite,
    required this.lastWateredAt,
    required this.createdAt,
    this.isUserCreated = false,
  });

  PlantModel copyWith({
    String? id,
    String? name,
    String? latinName,
    String? family,
    String? category,
    List<String>? origin,
    String? description,
    String? thumbnailImage,
    List<String>? galleryImages,
    PlantLocation? location,
    DifficultyLevel? difficulty,
    GrowthRate? growthRate,
    MatureSizeModel? matureSize,
    String? lifespan,
    CareModel? care,
    SeasonalCareModel? seasonalCare,
    List<String>? benefits,
    List<String>? tips,
    List<CommonProblemModel>? commonProblems,
    List<DiseaseModel>? diseases,
    List<PestModel>? pests,
    List<String>? propagationMethods,
    List<String>? companionPlants,
    bool? isToxicForPets,
    bool? isToxicForChildren,
    FloweringModel? flowering,
    SmartNotificationsModel? smartNotifications,
    AiContextModel? aiContext,
    bool? isFavorite,
    DateTime? lastWateredAt,
    DateTime? createdAt,
    bool? isUserCreated,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latinName: latinName ?? this.latinName,
      family: family ?? this.family,
      category: category ?? this.category,
      origin: origin ?? this.origin,
      description: description ?? this.description,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
      galleryImages: galleryImages ?? this.galleryImages,
      location: location ?? this.location,
      difficulty: difficulty ?? this.difficulty,
      growthRate: growthRate ?? this.growthRate,
      matureSize: matureSize ?? this.matureSize,
      lifespan: lifespan ?? this.lifespan,
      care: care ?? this.care,
      seasonalCare: seasonalCare ?? this.seasonalCare,
      benefits: benefits ?? this.benefits,
      tips: tips ?? this.tips,
      commonProblems: commonProblems ?? this.commonProblems,
      diseases: diseases ?? this.diseases,
      pests: pests ?? this.pests,
      propagationMethods: propagationMethods ?? this.propagationMethods,
      companionPlants: companionPlants ?? this.companionPlants,
      isToxicForPets: isToxicForPets ?? this.isToxicForPets,
      isToxicForChildren: isToxicForChildren ?? this.isToxicForChildren,
      flowering: flowering ?? this.flowering,
      smartNotifications: smartNotifications ?? this.smartNotifications,
      aiContext: aiContext ?? this.aiContext,
      isFavorite: isFavorite ?? this.isFavorite,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
      createdAt: createdAt ?? this.createdAt,
      isUserCreated: isUserCreated ?? this.isUserCreated,
    );
  }

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      latinName: json['latin_name'] ?? '',
      family: json['family'] ?? '',
      category: json['category'] ?? '',
      origin: json['origin'] != null ? List<String>.from(json['origin']) : [],
      description: json['description'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      galleryImages: json['gallery_images'] != null ? List<String>.from(json['gallery_images']) : [],
      location: PlantLocation.values.firstWhere((e) => e.name == json['location'], orElse: () => PlantLocation.indoor),
      difficulty: DifficultyLevel.values.firstWhere((e) => e.name == json['difficulty'], orElse: () => DifficultyLevel.easy),
      growthRate: GrowthRate.values.firstWhere((e) => e.name == json['growth_rate'], orElse: () => GrowthRate.medium),
      matureSize: MatureSizeModel.fromJson(json['mature_size'] ?? {}),
      lifespan: json['lifespan'] ?? '',
      care: CareModel.fromJson(json['care'] ?? {}),
      seasonalCare: SeasonalCareModel.fromJson(json['seasonal_care'] ?? {}),
      benefits: json['benefits'] != null ? List<String>.from(json['benefits']) : [],
      tips: json['tips'] != null ? List<String>.from(json['tips']) : [],
      commonProblems: json['common_problems'] != null ? (json['common_problems'] as List).map((e) => CommonProblemModel.fromJson(e)).toList() : [],
      diseases: json['diseases'] != null ? (json['diseases'] as List).map((e) => DiseaseModel.fromJson(e)).toList() : [],
      pests: json['pests'] != null ? (json['pests'] as List).map((e) => PestModel.fromJson(e)).toList() : [],
      propagationMethods: json['propagation_methods'] != null ? List<String>.from(json['propagation_methods']) : [],
      companionPlants: json['companion_plants'] != null ? List<String>.from(json['companion_plants']) : [],
      isToxicForPets: json['is_toxic_for_pets'] ?? false,
      isToxicForChildren: json['is_toxic_for_children'] ?? false,
      flowering: FloweringModel.fromJson(json['flowering'] ?? {}),
      smartNotifications: SmartNotificationsModel.fromJson(json['smart_notifications'] ?? {}),
      aiContext: AiContextModel.fromJson(json['ai_context'] ?? {}),
      isFavorite: json['is_favorite'] ?? false,
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
      'family': family,
      'category': category,
      'origin': origin,
      'description': description,
      'thumbnail_image': thumbnailImage,
      'gallery_images': galleryImages,
      'location': location.name,
      'difficulty': difficulty.name,
      'growth_rate': growthRate.name,
      'mature_size': matureSize.toJson(),
      'lifespan': lifespan,
      'care': care.toJson(),
      'seasonal_care': seasonalCare.toJson(),
      'benefits': benefits,
      'tips': tips,
      'common_problems': commonProblems.map((e) => e.toJson()).toList(),
      'diseases': diseases.map((e) => e.toJson()).toList(),
      'pests': pests.map((e) => e.toJson()).toList(),
      'propagation_methods': propagationMethods,
      'companion_plants': companionPlants,
      'is_toxic_for_pets': isToxicForPets,
      'is_toxic_for_children': isToxicForChildren,
      'flowering': flowering.toJson(),
      'smart_notifications': smartNotifications.toJson(),
      'ai_context': aiContext.toJson(),
      'is_favorite': isFavorite,
      'last_water_at': lastWateredAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_user_created': isUserCreated,
    };
  }
}

@HiveType(typeId: 16)
class MatureSizeModel {
  @HiveField(0)
  final int heightCm;
  @HiveField(1)
  final int widthCm;

  const MatureSizeModel({required this.heightCm, required this.widthCm});

  factory MatureSizeModel.fromJson(Map<String, dynamic> json) {
    return MatureSizeModel(
      heightCm: json['height_cm'] ?? 0,
      widthCm: json['width_cm'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'height_cm': heightCm, 'width_cm': widthCm};
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
  final SoilModel soil;
  @HiveField(5)
  final FertilizerModel fertilizer;

  const CareModel({
    required this.watering,
    required this.sunlight,
    required this.temperature,
    required this.humidity,
    required this.soil,
    required this.fertilizer,
  });

  factory CareModel.fromJson(Map<String, dynamic> json) {
    return CareModel(
      watering: WateringModel.fromJson(json['watering'] ?? {}),
      sunlight: SunlightModel.fromJson(json['sunlight'] ?? {}),
      temperature: TemperatureModel.fromJson(json['temperature'] ?? {}),
      humidity: HumidityModel.fromJson(json['humidity'] ?? {}),
      soil: SoilModel.fromJson(json['soil'] ?? {}),
      fertilizer: FertilizerModel.fromJson(json['fertilizer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watering': watering.toJson(),
      'sunlight': sunlight.toJson(),
      'temperature': temperature.toJson(),
      'humidity': humidity.toJson(),
      'soil': soil.toJson(),
      'fertilizer': fertilizer.toJson(),
    };
  }
}

@HiveType(typeId: 6)
class WateringModel {
  @HiveField(0)
  final int days;
  @HiveField(1)
  final int summerDays;
  @HiveField(2)
  final int winterDays;
  @HiveField(3)
  final int amountMl;
  @HiveField(4)
  final String method;
  @HiveField(5)
  final String overwateringRisk;

  const WateringModel({
    required this.days,
    required this.summerDays,
    required this.winterDays,
    required this.amountMl,
    required this.method,
    required this.overwateringRisk,
  });

  factory WateringModel.fromJson(Map<String, dynamic> json) {
    return WateringModel(
      days: json['days'] ?? 0,
      summerDays: json['summer_days'] ?? 0,
      winterDays: json['winter_days'] ?? 0,
      amountMl: json['amount_ml'] ?? 0,
      method: json['method'] ?? '',
      overwateringRisk: json['overwatering_risk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'days': days,
    'summer_days': summerDays,
    'winter_days': winterDays,
    'amount_ml': amountMl,
    'method': method,
    'overwatering_risk': overwateringRisk,
  };
}

@HiveType(typeId: 7)
class SunlightModel {
  @HiveField(0)
  final SunlightType type;
  @HiveField(1)
  final int hours;
  @HiveField(2)
  final int luxMin;
  @HiveField(3)
  final int luxMax;

  const SunlightModel({
    required this.type,
    required this.hours,
    required this.luxMin,
    required this.luxMax,
  });

  factory SunlightModel.fromJson(Map<String, dynamic> json) {
    return SunlightModel(
      type: SunlightType.values.firstWhere((e) => e.name == json['type'], orElse: () => SunlightType.partial),
      hours: json['hours'] ?? 0,
      luxMin: json['lux_min'] ?? 0,
      luxMax: json['lux_max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'hours': hours,
    'lux_min': luxMin,
    'lux_max': luxMax,
  };
}

@HiveType(typeId: 8)
class TemperatureModel {
  @HiveField(0)
  final int min;
  @HiveField(1)
  final int ideal;
  @HiveField(2)
  final int max;

  const TemperatureModel({required this.min, required this.ideal, required this.max});

  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(
      min: json['min'] ?? 0,
      ideal: json['ideal'] ?? 0,
      max: json['max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'min': min, 'ideal': ideal, 'max': max};
}

@HiveType(typeId: 9)
class HumidityModel {
  @HiveField(0)
  final int min;
  @HiveField(1)
  final int ideal;
  @HiveField(2)
  final int max;

  const HumidityModel({required this.min, required this.ideal, required this.max});

  factory HumidityModel.fromJson(Map<String, dynamic> json) {
    return HumidityModel(
      min: json['min'] ?? 0,
      ideal: json['ideal'] ?? 0,
      max: json['max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'min': min, 'ideal': ideal, 'max': max};
}

@HiveType(typeId: 17)
class SoilModel {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final double phMin;
  @HiveField(2)
  final double phMax;
  @HiveField(3)
  final String drainage;

  const SoilModel({
    required this.type,
    required this.phMin,
    required this.phMax,
    required this.drainage,
  });

  factory SoilModel.fromJson(Map<String, dynamic> json) {
    return SoilModel(
      type: json['type'] ?? '',
      phMin: (json['ph_min'] ?? 0).toDouble(),
      phMax: (json['ph_max'] ?? 0).toDouble(),
      drainage: json['drainage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'ph_min': phMin,
    'ph_max': phMax,
    'drainage': drainage,
  };
}

@HiveType(typeId: 10)
class FertilizerModel {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String npk;
  @HiveField(2)
  final int frequencyDays;

  const FertilizerModel({required this.type, required this.npk, required this.frequencyDays});

  factory FertilizerModel.fromJson(Map<String, dynamic> json) {
    return FertilizerModel(
      type: json['type'] ?? '',
      npk: json['npk'] ?? '',
      frequencyDays: json['frequency_days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'npk': npk,
    'frequency_days': frequencyDays,
  };
}

@HiveType(typeId: 18)
class SeasonalCareModel {
  @HiveField(0)
  final List<String> spring;
  @HiveField(1)
  final List<String> summer;
  @HiveField(2)
  final List<String> autumn;
  @HiveField(3)
  final List<String> winter;

  const SeasonalCareModel({
    required this.spring,
    required this.summer,
    required this.autumn,
    required this.winter,
  });

  factory SeasonalCareModel.fromJson(Map<String, dynamic> json) {
    return SeasonalCareModel(
      spring: json['spring'] != null ? List<String>.from(json['spring']) : [],
      summer: json['summer'] != null ? List<String>.from(json['summer']) : [],
      autumn: json['autumn'] != null ? List<String>.from(json['autumn']) : [],
      winter: json['winter'] != null ? List<String>.from(json['winter']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'spring': spring,
    'summer': summer,
    'autumn': autumn,
    'winter': winter,
  };
}

@HiveType(typeId: 19)
class CommonProblemModel {
  @HiveField(0)
  final String problem;
  @HiveField(1)
  final String cause;
  @HiveField(2)
  final String solution;

  const CommonProblemModel({required this.problem, required this.cause, required this.solution});

  factory CommonProblemModel.fromJson(Map<String, dynamic> json) {
    return CommonProblemModel(
      problem: json['problem'] ?? '',
      cause: json['cause'] ?? '',
      solution: json['solution'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'problem': problem, 'cause': cause, 'solution': solution};
}

@HiveType(typeId: 15)
class TreatmentModel {
  @HiveField(0)
  final List<String> chemical;
  @HiveField(1)
  final List<String> organic;

  const TreatmentModel({required this.chemical, required this.organic});

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      chemical: json['chemical'] != null ? List<String>.from(json['chemical']) : [],
      organic: json['organic'] != null ? List<String>.from(json['organic']) : [],
    );
  }

  Map<String, dynamic> toJson() => {'chemical': chemical, 'organic': organic};
}

@HiveType(typeId: 12)
class DiseaseModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String severity;
  @HiveField(3)
  final String cause;
  @HiveField(4)
  final List<String> symptoms;
  @HiveField(5)
  final List<String> prevention;
  @HiveField(6)
  final TreatmentModel treatment;

  const DiseaseModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.cause,
    required this.symptoms,
    required this.prevention,
    required this.treatment,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
      cause: json['cause'] ?? '',
      symptoms: json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
      prevention: json['prevention'] != null ? List<String>.from(json['prevention']) : [],
      treatment: TreatmentModel.fromJson(json['treatment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'severity': severity,
    'cause': cause,
    'symptoms': symptoms,
    'prevention': prevention,
    'treatment': treatment.toJson(),
  };
}

@HiveType(typeId: 13)
class PestModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String severity;
  @HiveField(3)
  final List<String> symptoms;
  @HiveField(4)
  final TreatmentModel treatment;

  const PestModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.symptoms,
    required this.treatment,
  });

  factory PestModel.fromJson(Map<String, dynamic> json) {
    return PestModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
      symptoms: json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
      treatment: TreatmentModel.fromJson(json['treatment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'severity': severity,
    'symptoms': symptoms,
    'treatment': treatment.toJson(),
  };
}

@HiveType(typeId: 20)
class FloweringModel {
  @HiveField(0)
  final String season;
  @HiveField(1)
  final String flowerColor;
  @HiveField(2)
  final int floweringAgeYears;

  const FloweringModel({
    required this.season,
    required this.flowerColor,
    required this.floweringAgeYears,
  });

  factory FloweringModel.fromJson(Map<String, dynamic> json) {
    return FloweringModel(
      season: json['season'] ?? '',
      flowerColor: json['flower_color'] ?? '',
      floweringAgeYears: json['flowering_age_years'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'season': season,
    'flower_color': flowerColor,
    'flowering_age_years': floweringAgeYears,
  };
}

@HiveType(typeId: 21)
class SmartNotificationsModel {
  @HiveField(0)
  final int wateringDays;
  @HiveField(1)
  final int fertilizerDays;
  @HiveField(2)
  final int repottingDays;
  @HiveField(3)
  final int pruningDays;
  @HiveField(4)
  final TemperatureAlertsModel temperatureAlerts;
  @HiveField(5)
  final HumidityAlertsModel humidityAlerts;

  const SmartNotificationsModel({
    required this.wateringDays,
    required this.fertilizerDays,
    required this.repottingDays,
    required this.pruningDays,
    required this.temperatureAlerts,
    required this.humidityAlerts,
  });

  factory SmartNotificationsModel.fromJson(Map<String, dynamic> json) {
    return SmartNotificationsModel(
      wateringDays: json['watering_days'] ?? 0,
      fertilizerDays: json['fertilizer_days'] ?? 0,
      repottingDays: json['repotting_days'] ?? 0,
      pruningDays: json['pruning_days'] ?? 0,
      temperatureAlerts: TemperatureAlertsModel.fromJson(json['temperature_alerts'] ?? {}),
      humidityAlerts: HumidityAlertsModel.fromJson(json['humidity_alerts'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'watering_days': wateringDays,
    'fertilizer_days': fertilizerDays,
    'repotting_days': repottingDays,
    'pruning_days': pruningDays,
    'temperature_alerts': temperatureAlerts.toJson(),
    'humidity_alerts': humidityAlerts.toJson(),
  };
}

@HiveType(typeId: 22)
class TemperatureAlertsModel {
  @HiveField(0)
  final int low;
  @HiveField(1)
  final int high;

  const TemperatureAlertsModel({required this.low, required this.high});

  factory TemperatureAlertsModel.fromJson(Map<String, dynamic> json) {
    return TemperatureAlertsModel(
      low: json['low'] ?? 0,
      high: json['high'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'low': low, 'high': high};
}

@HiveType(typeId: 23)
class HumidityAlertsModel {
  @HiveField(0)
  final int low;
  @HiveField(1)
  final int high;

  const HumidityAlertsModel({required this.low, required this.high});

  factory HumidityAlertsModel.fromJson(Map<String, dynamic> json) {
    return HumidityAlertsModel(
      low: json['low'] ?? 0,
      high: json['high'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'low': low, 'high': high};
}

@HiveType(typeId: 24)
class AiContextModel {
  @HiveField(0)
  final String plantType;
  @HiveField(1)
  final String wateringSensitivity;
  @HiveField(2)
  final String droughtTolerance;
  @HiveField(3)
  final String diseaseRisk;
  @HiveField(4)
  final bool petFriendly;

  const AiContextModel({
    required this.plantType,
    required this.wateringSensitivity,
    required this.droughtTolerance,
    required this.diseaseRisk,
    required this.petFriendly,
  });

  factory AiContextModel.fromJson(Map<String, dynamic> json) {
    return AiContextModel(
      plantType: json['plant_type'] ?? '',
      wateringSensitivity: json['watering_sensitivity'] ?? '',
      droughtTolerance: json['drought_tolerance'] ?? '',
      diseaseRisk: json['disease_risk'] ?? '',
      petFriendly: json['pet_friendly'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'plant_type': plantType,
    'watering_sensitivity': wateringSensitivity,
    'drought_tolerance': droughtTolerance,
    'disease_risk': diseaseRisk,
    'pet_friendly': petFriendly,
  };
}
