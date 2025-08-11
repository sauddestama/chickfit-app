class StartConsultRequest {
  final int veterinarianId;

  const StartConsultRequest({
    required this.veterinarianId,
  });

  Map<String, dynamic> toJson() {
    return {
      'veterinarian_id': veterinarianId,
    };
  }
}
