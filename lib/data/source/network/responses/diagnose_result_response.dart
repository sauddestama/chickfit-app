class DiagnoseResultResponse {
  DiagnoseResultResponse({
    required this.image,
    required this.prediction,
  });

  final DiagnoseResultImage? image;
  final DiagnoseResultPrediction? prediction;

  factory DiagnoseResultResponse.fromJson(Map<String, dynamic> json) {
    return DiagnoseResultResponse(
      image: json["image"] == null
          ? null
          : DiagnoseResultImage.fromJson(json["image"]),
      prediction: json["prediction"] == null
          ? null
          : DiagnoseResultPrediction.fromJson(json["prediction"]),
    );
  }
}

class DiagnoseResultImage {
  DiagnoseResultImage({
    required this.id,
    required this.filename,
    required this.url,
    required this.size,
    required this.dimensions,
  });

  final int? id;
  final String? filename;
  final String? url;
  final int? size;
  final Dimensions? dimensions;

  factory DiagnoseResultImage.fromJson(Map<String, dynamic> json) {
    return DiagnoseResultImage(
      id: json["id"],
      filename: json["filename"],
      url: json["url"],
      size: json["size"],
      dimensions: json["dimensions"] == null
          ? null
          : Dimensions.fromJson(json["dimensions"]),
    );
  }
}

class Dimensions {
  Dimensions({
    required this.width,
    required this.height,
  });

  final int? width;
  final int? height;

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json["width"],
      height: json["height"],
    );
  }
}

class DiagnoseResultPrediction {
  DiagnoseResultPrediction({
    required this.id,
    required this.label,
    required this.confidence,
    required this.isConfident,
    required this.allPredictions,
    required this.modelInfo,
    required this.symptomsDetected,
    required this.recommendations,
  });

  final int? id;
  final String? label;
  final double? confidence;
  final bool? isConfident;
  final DiagnoseResultAllPredictions? allPredictions;
  final DiagnoseResultModelInfo? modelInfo;
  final List<String> symptomsDetected;
  final List<String> recommendations;

  factory DiagnoseResultPrediction.fromJson(Map<String, dynamic> json) {
    return DiagnoseResultPrediction(
      id: json["id"],
      label: json["label"],
      confidence: json["confidence"],
      isConfident: json["is_confident"],
      allPredictions: json["all_predictions"] == null
          ? null
          : DiagnoseResultAllPredictions.fromJson(json["all_predictions"]),
      modelInfo: json["model_info"] == null
          ? null
          : DiagnoseResultModelInfo.fromJson(json["model_info"]),
      symptomsDetected: json["symptoms_detected"] == null
          ? []
          : List<String>.from(json["symptoms_detected"]!.map((x) => x)),
      recommendations: json["recommendations"] == null
          ? []
          : List<String>.from(json["recommendations"]!.map((x) => x)),
    );
  }
}

class DiagnoseResultAllPredictions {
  DiagnoseResultAllPredictions({
    required this.coccidiosis,
    required this.nd,
    required this.sehat,
  });

  final double? coccidiosis;
  final double? nd;
  final double? sehat;

  factory DiagnoseResultAllPredictions.fromJson(Map<String, dynamic> json) {
    return DiagnoseResultAllPredictions(
      coccidiosis: json["Coccidiosis"],
      nd: json["ND"],
      sehat: json["Sehat"],
    );
  }
}

class DiagnoseResultModelInfo {
  DiagnoseResultModelInfo({
    required this.name,
    required this.version,
    required this.accuracy,
    required this.classes,
    required this.inputShape,
    required this.trainedAt,
    required this.modelSize,
  });

  final String? name;
  final String? version;
  final double? accuracy;
  final List<String> classes;
  final List<int> inputShape;
  final DateTime? trainedAt;
  final int? modelSize;

  factory DiagnoseResultModelInfo.fromJson(Map<String, dynamic> json) {
    return DiagnoseResultModelInfo(
      name: json["name"],
      version: json["version"],
      accuracy: json["accuracy"],
      classes: json["classes"] == null
          ? []
          : List<String>.from(json["classes"]!.map((x) => x)),
      inputShape: json["input_shape"] == null
          ? []
          : List<int>.from(json["input_shape"]!.map((x) => x)),
      trainedAt: DateTime.tryParse(json["trained_at"] ?? ""),
      modelSize: json["model_size"],
    );
  }
}
