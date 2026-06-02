class AIDiseaseModel {
  final String plantName;
  final String diseaseName;
  final String symptoms;
  final String causes;
  final List<String> solutions;
  final List<String> prevention;
  final String treatmentMedicine;
  final String medicinePreparation;
  final double confidence;

  AIDiseaseModel({
    required this.plantName,
    required this.diseaseName,
    required this.symptoms,
    required this.causes,
    required this.solutions,
    required this.prevention,
    required this.treatmentMedicine,
    required this.medicinePreparation,
    required this.confidence,
  });

  factory AIDiseaseModel.fromJson(Map<String, dynamic> json) {
    return AIDiseaseModel(
      plantName: json['plant_name'] ?? 'Noma\'lum',
      diseaseName: json['disease_name'] ?? 'Noma\'lum',
      symptoms: json['symptoms'] ?? '',
      causes: json['causes'] ?? '',
      solutions: List<String>.from(json['solutions'] ?? []),
      prevention: List<String>.from(json['prevention'] ?? []),
      treatmentMedicine: json['treatment_medicine'] ?? '',
      medicinePreparation: json['medicine_preparation'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}
