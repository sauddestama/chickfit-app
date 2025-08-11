class StartConsultResponse {
  final int consultationId;

  const StartConsultResponse({
    required this.consultationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'consultationId': this.consultationId,
    };
  }

  factory StartConsultResponse.fromJson(Map<String, dynamic> map) {
    return StartConsultResponse(
      consultationId: map['consultation_id'] as int,
    );
  }
}
