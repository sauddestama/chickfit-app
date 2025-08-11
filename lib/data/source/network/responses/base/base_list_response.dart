import 'package:json_annotation/json_annotation.dart';
part 'base_list_response.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class BaseListResponse<T> {

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'success')
  final bool success;


  @JsonKey(name: 'data')
  final List<T>? datas;

  BaseListResponse({
    this.message = "",
    required this.success,
    this.datas,
  });

  factory BaseListResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseListResponseFromJson<T>(json, fromJsonT);


}