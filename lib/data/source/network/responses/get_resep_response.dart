class GetResepsResponse {
  GetResepsResponse({
    required this.prescriptions,
  });

  final List<PrescriptionItemResponse> prescriptions;

  factory GetResepsResponse.fromJson(Map<String, dynamic> json) {
    return GetResepsResponse(
      prescriptions: json["prescriptions"] == null
          ? []
          : List<PrescriptionItemResponse>.from(json["prescriptions"]!
              .map((x) => PrescriptionItemResponse.fromJson(x))),
    );
  }
}

class PrescriptionItemResponse {
  PrescriptionItemResponse({
    required this.id,
    required this.medicine,
    required this.usageInstructions,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.diagnosisLabel,
    required this.doctorName,
  });

  final int? id;
  final String? medicine;
  final String? usageInstructions;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final String? diagnosisLabel;
  final String? doctorName;

  factory PrescriptionItemResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemResponse(
      id: json["id"],
      medicine: json["medicine"],
      usageInstructions: json["usage_instructions"],
      notes: json["notes"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      diagnosisLabel: json["diagnosis_label"],
      doctorName: json["doctor_name"],
    );
  }
}
