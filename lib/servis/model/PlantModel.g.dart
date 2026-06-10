// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlantModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantModelAdapter extends TypeAdapter<PlantModel> {
  @override
  final int typeId = 0;

  @override
  PlantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantModel(
      id: fields[0] as String,
      name: fields[1] as String,
      latinName: fields[2] as String,
      family: fields[25] as String,
      category: fields[3] as String,
      origin: (fields[26] as List).cast<String>(),
      description: fields[4] as String,
      thumbnailImage: fields[5] as String,
      galleryImages: (fields[6] as List).cast<String>(),
      location: fields[7] as PlantLocation,
      difficulty: fields[9] as DifficultyLevel,
      growthRate: fields[10] as GrowthRate,
      matureSize: fields[27] as MatureSizeModel,
      lifespan: fields[28] as String,
      care: fields[8] as CareModel,
      seasonalCare: fields[29] as SeasonalCareModel,
      benefits: (fields[11] as List).cast<String>(),
      tips: (fields[12] as List).cast<String>(),
      commonProblems: (fields[30] as List).cast<CommonProblemModel>(),
      diseases: (fields[13] as List).cast<DiseaseModel>(),
      pests: (fields[14] as List).cast<PestModel>(),
      propagationMethods: (fields[15] as List).cast<String>(),
      companionPlants: (fields[31] as List).cast<String>(),
      isToxicForPets: fields[16] as bool,
      isToxicForChildren: fields[17] as bool,
      flowering: fields[32] as FloweringModel,
      smartNotifications: fields[21] as SmartNotificationsModel,
      aiContext: fields[33] as AiContextModel,
      isFavorite: fields[20] as bool,
      lastWateredAt: fields[22] as DateTime,
      createdAt: fields[23] as DateTime,
      isUserCreated: fields[24] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantModel obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latinName)
      ..writeByte(25)
      ..write(obj.family)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(26)
      ..write(obj.origin)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.thumbnailImage)
      ..writeByte(6)
      ..write(obj.galleryImages)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.difficulty)
      ..writeByte(10)
      ..write(obj.growthRate)
      ..writeByte(27)
      ..write(obj.matureSize)
      ..writeByte(28)
      ..write(obj.lifespan)
      ..writeByte(8)
      ..write(obj.care)
      ..writeByte(29)
      ..write(obj.seasonalCare)
      ..writeByte(11)
      ..write(obj.benefits)
      ..writeByte(12)
      ..write(obj.tips)
      ..writeByte(30)
      ..write(obj.commonProblems)
      ..writeByte(13)
      ..write(obj.diseases)
      ..writeByte(14)
      ..write(obj.pests)
      ..writeByte(15)
      ..write(obj.propagationMethods)
      ..writeByte(31)
      ..write(obj.companionPlants)
      ..writeByte(16)
      ..write(obj.isToxicForPets)
      ..writeByte(17)
      ..write(obj.isToxicForChildren)
      ..writeByte(32)
      ..write(obj.flowering)
      ..writeByte(21)
      ..write(obj.smartNotifications)
      ..writeByte(33)
      ..write(obj.aiContext)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(22)
      ..write(obj.lastWateredAt)
      ..writeByte(23)
      ..write(obj.createdAt)
      ..writeByte(24)
      ..write(obj.isUserCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MatureSizeModelAdapter extends TypeAdapter<MatureSizeModel> {
  @override
  final int typeId = 16;

  @override
  MatureSizeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatureSizeModel(
      heightCm: fields[0] as int,
      widthCm: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MatureSizeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.heightCm)
      ..writeByte(1)
      ..write(obj.widthCm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatureSizeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CareModelAdapter extends TypeAdapter<CareModel> {
  @override
  final int typeId = 5;

  @override
  CareModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CareModel(
      watering: fields[0] as WateringModel,
      sunlight: fields[1] as SunlightModel,
      temperature: fields[2] as TemperatureModel,
      humidity: fields[3] as HumidityModel,
      soil: fields[4] as SoilModel,
      fertilizer: fields[5] as FertilizerModel,
    );
  }

  @override
  void write(BinaryWriter writer, CareModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.watering)
      ..writeByte(1)
      ..write(obj.sunlight)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.soil)
      ..writeByte(5)
      ..write(obj.fertilizer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WateringModelAdapter extends TypeAdapter<WateringModel> {
  @override
  final int typeId = 6;

  @override
  WateringModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WateringModel(
      days: fields[0] as int,
      summerDays: fields[1] as int,
      winterDays: fields[2] as int,
      amountMl: fields[3] as int,
      method: fields[4] as String,
      overwateringRisk: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WateringModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.summerDays)
      ..writeByte(2)
      ..write(obj.winterDays)
      ..writeByte(3)
      ..write(obj.amountMl)
      ..writeByte(4)
      ..write(obj.method)
      ..writeByte(5)
      ..write(obj.overwateringRisk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WateringModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SunlightModelAdapter extends TypeAdapter<SunlightModel> {
  @override
  final int typeId = 7;

  @override
  SunlightModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SunlightModel(
      type: fields[0] as SunlightType,
      hours: fields[1] as int,
      luxMin: fields[2] as int,
      luxMax: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SunlightModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.hours)
      ..writeByte(2)
      ..write(obj.luxMin)
      ..writeByte(3)
      ..write(obj.luxMax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SunlightModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TemperatureModelAdapter extends TypeAdapter<TemperatureModel> {
  @override
  final int typeId = 8;

  @override
  TemperatureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemperatureModel(
      min: fields[0] as int,
      ideal: fields[1] as int,
      max: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TemperatureModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.ideal)
      ..writeByte(2)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemperatureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HumidityModelAdapter extends TypeAdapter<HumidityModel> {
  @override
  final int typeId = 9;

  @override
  HumidityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HumidityModel(
      min: fields[0] as int,
      ideal: fields[1] as int,
      max: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HumidityModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.ideal)
      ..writeByte(2)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HumidityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SoilModelAdapter extends TypeAdapter<SoilModel> {
  @override
  final int typeId = 17;

  @override
  SoilModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoilModel(
      type: fields[0] as String,
      phMin: fields[1] as double,
      phMax: fields[2] as double,
      drainage: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoilModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.phMin)
      ..writeByte(2)
      ..write(obj.phMax)
      ..writeByte(3)
      ..write(obj.drainage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoilModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FertilizerModelAdapter extends TypeAdapter<FertilizerModel> {
  @override
  final int typeId = 10;

  @override
  FertilizerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FertilizerModel(
      type: fields[0] as String,
      npk: fields[1] as String,
      frequencyDays: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FertilizerModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.npk)
      ..writeByte(2)
      ..write(obj.frequencyDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FertilizerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SeasonalCareModelAdapter extends TypeAdapter<SeasonalCareModel> {
  @override
  final int typeId = 18;

  @override
  SeasonalCareModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeasonalCareModel(
      spring: (fields[0] as List).cast<String>(),
      summer: (fields[1] as List).cast<String>(),
      autumn: (fields[2] as List).cast<String>(),
      winter: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SeasonalCareModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.spring)
      ..writeByte(1)
      ..write(obj.summer)
      ..writeByte(2)
      ..write(obj.autumn)
      ..writeByte(3)
      ..write(obj.winter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonalCareModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommonProblemModelAdapter extends TypeAdapter<CommonProblemModel> {
  @override
  final int typeId = 19;

  @override
  CommonProblemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommonProblemModel(
      problem: fields[0] as String,
      cause: fields[1] as String,
      solution: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CommonProblemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.problem)
      ..writeByte(1)
      ..write(obj.cause)
      ..writeByte(2)
      ..write(obj.solution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonProblemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TreatmentModelAdapter extends TypeAdapter<TreatmentModel> {
  @override
  final int typeId = 15;

  @override
  TreatmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreatmentModel(
      chemical: (fields[0] as List).cast<String>(),
      organic: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TreatmentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chemical)
      ..writeByte(1)
      ..write(obj.organic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreatmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiseaseModelAdapter extends TypeAdapter<DiseaseModel> {
  @override
  final int typeId = 12;

  @override
  DiseaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiseaseModel(
      id: fields[0] as String,
      name: fields[1] as String,
      severity: fields[2] as String,
      cause: fields[3] as String,
      symptoms: (fields[4] as List).cast<String>(),
      prevention: (fields[5] as List).cast<String>(),
      treatment: fields[6] as TreatmentModel,
    );
  }

  @override
  void write(BinaryWriter writer, DiseaseModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.cause)
      ..writeByte(4)
      ..write(obj.symptoms)
      ..writeByte(5)
      ..write(obj.prevention)
      ..writeByte(6)
      ..write(obj.treatment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiseaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PestModelAdapter extends TypeAdapter<PestModel> {
  @override
  final int typeId = 13;

  @override
  PestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PestModel(
      id: fields[0] as String,
      name: fields[1] as String,
      severity: fields[2] as String,
      symptoms: (fields[3] as List).cast<String>(),
      treatment: fields[4] as TreatmentModel,
    );
  }

  @override
  void write(BinaryWriter writer, PestModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.symptoms)
      ..writeByte(4)
      ..write(obj.treatment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FloweringModelAdapter extends TypeAdapter<FloweringModel> {
  @override
  final int typeId = 20;

  @override
  FloweringModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FloweringModel(
      season: fields[0] as String,
      flowerColor: fields[1] as String,
      floweringAgeYears: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FloweringModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.season)
      ..writeByte(1)
      ..write(obj.flowerColor)
      ..writeByte(2)
      ..write(obj.floweringAgeYears);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloweringModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SmartNotificationsModelAdapter
    extends TypeAdapter<SmartNotificationsModel> {
  @override
  final int typeId = 21;

  @override
  SmartNotificationsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmartNotificationsModel(
      wateringDays: fields[0] as int,
      fertilizerDays: fields[1] as int,
      repottingDays: fields[2] as int,
      pruningDays: fields[3] as int,
      temperatureAlerts: fields[4] as TemperatureAlertsModel,
      humidityAlerts: fields[5] as HumidityAlertsModel,
    );
  }

  @override
  void write(BinaryWriter writer, SmartNotificationsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.wateringDays)
      ..writeByte(1)
      ..write(obj.fertilizerDays)
      ..writeByte(2)
      ..write(obj.repottingDays)
      ..writeByte(3)
      ..write(obj.pruningDays)
      ..writeByte(4)
      ..write(obj.temperatureAlerts)
      ..writeByte(5)
      ..write(obj.humidityAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartNotificationsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TemperatureAlertsModelAdapter
    extends TypeAdapter<TemperatureAlertsModel> {
  @override
  final int typeId = 22;

  @override
  TemperatureAlertsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemperatureAlertsModel(
      low: fields[0] as int,
      high: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TemperatureAlertsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.low)
      ..writeByte(1)
      ..write(obj.high);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemperatureAlertsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HumidityAlertsModelAdapter extends TypeAdapter<HumidityAlertsModel> {
  @override
  final int typeId = 23;

  @override
  HumidityAlertsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HumidityAlertsModel(
      low: fields[0] as int,
      high: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HumidityAlertsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.low)
      ..writeByte(1)
      ..write(obj.high);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HumidityAlertsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AiContextModelAdapter extends TypeAdapter<AiContextModel> {
  @override
  final int typeId = 24;

  @override
  AiContextModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiContextModel(
      plantType: fields[0] as String,
      wateringSensitivity: fields[1] as String,
      droughtTolerance: fields[2] as String,
      diseaseRisk: fields[3] as String,
      petFriendly: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AiContextModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.plantType)
      ..writeByte(1)
      ..write(obj.wateringSensitivity)
      ..writeByte(2)
      ..write(obj.droughtTolerance)
      ..writeByte(3)
      ..write(obj.diseaseRisk)
      ..writeByte(4)
      ..write(obj.petFriendly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiContextModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantLocationAdapter extends TypeAdapter<PlantLocation> {
  @override
  final int typeId = 1;

  @override
  PlantLocation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlantLocation.indoor;
      case 1:
        return PlantLocation.outdoor;
      case 2:
        return PlantLocation.both;
      default:
        return PlantLocation.indoor;
    }
  }

  @override
  void write(BinaryWriter writer, PlantLocation obj) {
    switch (obj) {
      case PlantLocation.indoor:
        writer.writeByte(0);
        break;
      case PlantLocation.outdoor:
        writer.writeByte(1);
        break;
      case PlantLocation.both:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 2;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.easy;
      case 1:
        return DifficultyLevel.medium;
      case 2:
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.easy;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.easy:
        writer.writeByte(0);
        break;
      case DifficultyLevel.medium:
        writer.writeByte(1);
        break;
      case DifficultyLevel.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrowthRateAdapter extends TypeAdapter<GrowthRate> {
  @override
  final int typeId = 3;

  @override
  GrowthRate read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GrowthRate.slow;
      case 1:
        return GrowthRate.medium;
      case 2:
        return GrowthRate.fast;
      default:
        return GrowthRate.slow;
    }
  }

  @override
  void write(BinaryWriter writer, GrowthRate obj) {
    switch (obj) {
      case GrowthRate.slow:
        writer.writeByte(0);
        break;
      case GrowthRate.medium:
        writer.writeByte(1);
        break;
      case GrowthRate.fast:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrowthRateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SunlightTypeAdapter extends TypeAdapter<SunlightType> {
  @override
  final int typeId = 4;

  @override
  SunlightType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SunlightType.direct;
      case 1:
        return SunlightType.partial;
      case 2:
        return SunlightType.lowLight;
      case 3:
        return SunlightType.bright_indirect;
      default:
        return SunlightType.direct;
    }
  }

  @override
  void write(BinaryWriter writer, SunlightType obj) {
    switch (obj) {
      case SunlightType.direct:
        writer.writeByte(0);
        break;
      case SunlightType.partial:
        writer.writeByte(1);
        break;
      case SunlightType.lowLight:
        writer.writeByte(2);
        break;
      case SunlightType.bright_indirect:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SunlightTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
