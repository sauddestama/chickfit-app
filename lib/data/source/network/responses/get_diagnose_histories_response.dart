class GetDiagnoseHistoriesResponse {
  GetDiagnoseHistoriesResponse({
    required this.diagnoses,
  });

  final List<DiagnoseHistoryItem> diagnoses;

  factory GetDiagnoseHistoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetDiagnoseHistoriesResponse(
      diagnoses: json["diagnoses"] == null
          ? []
          : List<DiagnoseHistoryItem>.from(
              json["diagnoses"]!.map((x) => DiagnoseHistoryItem.fromJson(x))),
    );
  }
}

class DiagnoseHistoryItem {
  DiagnoseHistoryItem({
    required this.id,
    required this.label,
    required this.confidence,
    required this.verified,
    required this.verifiedBy,
    required this.verifiedAt,
    required this.createdAt,
    required this.image,
  });

  final int? id;
  final String? label;
  final double? confidence;
  final bool? verified;
  final dynamic verifiedBy;
  final dynamic verifiedAt;
  final DateTime? createdAt;
  final DiagnoseImage? image;

  factory DiagnoseHistoryItem.fromJson(Map<String, dynamic> json) {
    num? confidenceResp = json["confidence"];
    return DiagnoseHistoryItem(
      id: json["id"],
      label: json["label"],
      confidence: confidenceResp?.toDouble() ?? 0,
      verified: json["verified"],
      verifiedBy: json["verified_by"],
      verifiedAt: json["verified_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      image:
          json["image"] == null ? null : DiagnoseImage.fromJson(json["image"]),
    );
  }
}

class DiagnoseImage {
  DiagnoseImage({
    required this.filename,
    required this.url,
  });

  final String? filename;
  final String? url;

  factory DiagnoseImage.fromJson(Map<String, dynamic> json) {
    return DiagnoseImage(
      filename: json["filename"],
      url: json["url"],
    );
  }
}
