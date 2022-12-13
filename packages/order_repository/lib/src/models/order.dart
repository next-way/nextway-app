import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order extends Equatable {
  const Order({
    required this.id,
    required this.displayName,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;

  @override
  List<Object> get props => [id, displayName];
}
