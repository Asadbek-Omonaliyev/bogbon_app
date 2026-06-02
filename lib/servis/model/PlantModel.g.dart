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
      category: fields[3] as String,
      description: fields[4] as String,
      thumbnailImage: fields[5] as String,
      galleryImages: (fields[6] as List).cast<String>(),
      location: fields[7] as PlantLocation,
      care: fields[8] as CareModel,
      difficulty: fields[9] as DifficultyLevel,
      growthRate: fields[10] as GrowthRate,
      benefits: (fields[11] as List).cast<String>(),
      tips: (fields[12] as List).cast<String>(),
      diseases: (fields[13] as List).cast<DiseaseModel>(),
      pests: (fields[14] as List).cast<PestModel>(),
      propagationMethods: (fields[15] as List).cast<String>(),
      isToxicForPets: fields[16] as bool,
      isToxicForChildren: fields[17] as bool,
      bloomingSeason: fields[18] as String,
      flowerColor: fields[19] as String,
      isFavorite: fields[20] as bool,
      reminders: fields[21] as ReminderModel,
      lastWateredAt: fields[22] as DateTime,
      createdAt: fields[23] as DateTime,
      isUserCreated: fields[24] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latinName)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.thumbnailImage)
      ..writeByte(6)
      ..write(obj.galleryImages)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.care)
      ..writeByte(9)
      ..write(obj.difficulty)
      ..writeByte(10)
      ..write(obj.growthRate)
      ..writeByte(11)
      ..write(obj.benefits)
      ..writeByte(12)
      ..write(obj.tips)
      ..writeByte(13)
      ..write(obj.diseases)
      ..writeByte(14)
      ..write(obj.pests)
      ..writeByte(15)
      ..write(obj.propagationMethods)
      ..writeByte(16)
      ..write(obj.isToxicForPets)
      ..writeByte(17)
      ..write(obj.isToxicForChildren)
      ..writeByte(18)
      ..write(obj.bloomingSeason)
      ..writeByte(19)
      ..write(obj.flowerColor)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(21)
      ..write(obj.reminders)
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
      soilType: fields[4] as String,
      fertilizer: fields[5] as FertilizerModel,
      repotting: fields[6] as RepottingModel,
    );
  }

  @override
  void write(BinaryWriter writer, CareModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.watering)
      ..writeByte(1)
      ..write(obj.sunlight)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.soilType)
      ..writeByte(5)
      ..write(obj.fertilizer)
      ..writeByte(6)
      ..write(obj.repotting);
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
      amount: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WateringModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.amount);
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
    );
  }

  @override
  void write(BinaryWriter writer, SunlightModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.hours);
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
      max: fields[1] as int,
      ideal: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TemperatureModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.max)
      ..writeByte(2)
      ..write(obj.ideal);
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
      percent: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HumidityModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.percent);
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
      frequency: fields[1] as String,
      usage: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FertilizerModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.usage);
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

class RepottingModelAdapter extends TypeAdapter<RepottingModel> {
  @override
  final int typeId = 11;

  @override
  RepottingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepottingModel(
      everyMonths: fields[0] as int,
      season: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RepottingModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.everyMonths)
      ..writeByte(1)
      ..write(obj.season);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepottingModelAdapter &&
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
      chemical: fields[0] as String,
      organic: fields[1] as String,
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
      name: fields[0] as String,
      cause: fields[1] as String,
      symptoms: (fields[2] as List).cast<String>(),
      treatment: fields[3] as TreatmentModel,
    );
  }

  @override
  void write(BinaryWriter writer, DiseaseModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.cause)
      ..writeByte(2)
      ..write(obj.symptoms)
      ..writeByte(3)
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
      name: fields[0] as String,
      treatment: fields[1] as TreatmentModel,
    );
  }

  @override
  void write(BinaryWriter writer, PestModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
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

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 14;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      wateringDays: fields[0] as int,
      fertilizerDays: fields[1] as int,
      pruningDays: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.wateringDays)
      ..writeByte(1)
      ..write(obj.fertilizerDays)
      ..writeByte(2)
      ..write(obj.pruningDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
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
