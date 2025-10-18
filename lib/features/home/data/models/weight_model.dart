import 'package:json_annotation/json_annotation.dart';

part 'weight_model.g.dart';

@JsonSerializable()
class WeightModel {
  final String imperial;
  final String metric;

  WeightModel({required this.imperial, required this.metric});

  factory WeightModel.fromJson(Map<String, dynamic> json) =>
      _$WeightModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeightModelToJson(this);
}
