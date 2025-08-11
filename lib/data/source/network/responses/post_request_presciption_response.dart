class PostRequestPrescriptionResponse {
  PostRequestPrescriptionResponse({
    required this.diagnosisId,
  });

  final int? diagnosisId;

  factory PostRequestPrescriptionResponse.fromJson(Map<String, dynamic> json) {
    return PostRequestPrescriptionResponse(
      diagnosisId: json["diagnosis_id"],
    );
  }
}
