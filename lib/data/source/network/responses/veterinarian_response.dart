import 'package:chickfit/data/source/network/responses/veterinarian_item_response.dart';

class GetVeterinarianResponse {
  GetVeterinarianResponse({
    required this.veterinarians,
  });

  final List<VeterinarianItemResponse> veterinarians;

  factory GetVeterinarianResponse.fromJson(Map<String, dynamic> json) {
    return GetVeterinarianResponse(
      veterinarians: json["veterinarians"] == null
          ? []
          : List<VeterinarianItemResponse>.from(json["veterinarians"]!
              .map((x) => VeterinarianItemResponse.fromJson(x))),
    );
  }
}
