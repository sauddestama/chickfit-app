class PostRequestPrescription {
  PostRequestPrescription({
    required this.diagnosisId,
  });

  final int? diagnosisId;

  Map<String, dynamic> toJson() {
    return {
      'diagnosis_id': this.diagnosisId,
    };
  }
}
