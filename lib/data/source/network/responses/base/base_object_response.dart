import 'package:json_annotation/json_annotation.dart';
part 'base_object_response.g.dart';


@JsonSerializable(genericArgumentFactories: true)
class BaseObjectResponse<T> {

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  T? data;

  BaseObjectResponse({
     this.message = "" ,
    required this.success,
    this.data,
  });

  factory BaseObjectResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseObjectResponseFromJson<T>(json, fromJsonT);

}