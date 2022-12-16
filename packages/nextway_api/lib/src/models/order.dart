import 'package:json_annotation/json_annotation.dart';

/**
 *
    [
      {
        "id": 26,
        "display_name": "S00026",
        "date_order": "2022-11-12T14:22:22",
        "state": "assigned",
        "delivery_address": {
          "street": null,
          "street2": null,
          "zip": "6000",
          "city": "Cebu City",
          "state_id": 1411,
          "country_id": 176
        }
      }
    ]
 */
part 'order.g.dart';

@JsonSerializable()
class Order {
  const Order({
    required this.id,
    required this.displayName,
    // required this.date_order, ???
    required this.state,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String state;
}

@JsonSerializable()
class OrderResponse {
  final List<Order> items;
  final int total;
  final int page;
  final int size;

  const OrderResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
