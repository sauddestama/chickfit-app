class ResepDetailResponse {
  ResepDetailResponse({
    required this.prescription,
  });

  final PrescriptionData? prescription;

  factory ResepDetailResponse.fromJson(Map<String, dynamic> json) {
    return ResepDetailResponse(
      prescription: json["prescription"] == null
          ? null
          : PrescriptionData.fromJson(json["prescription"]),
    );
  }
}

class PrescriptionData {
  PrescriptionData({
    required this.id,
    required this.medicine,
    required this.usageInstructions,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.diagnosis,
    required this.doctorName,
    required this.farmerName,
    required this.image,
  });

  final int? id;
  final String? medicine;
  final String? usageInstructions;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final Diagnosis? diagnosis;
  final String? doctorName;
  final String? farmerName;
  final Image? image;

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      id: json["id"],
      medicine: json["medicine"],
      usageInstructions: json["usage_instructions"],
      notes: json["notes"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      diagnosis: json["diagnosis"] == null
          ? null
          : Diagnosis.fromJson(json["diagnosis"]),
      doctorName: json["doctor_name"],
      farmerName: json["farmer_name"],
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
    );
  }
}

class Diagnosis {
  Diagnosis({
    required this.label,
    required this.confidence,
  });

  final String? label;
  final double? confidence;

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      label: json["label"],
      confidence: json["confidence"],
    );
  }
}

class Image {
  Image({
    required this.filename,
    required this.url,
  });

  final String? filename;
  final String? url;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      filename: json["filename"],
      url: json["url"],
    );
  }
}
