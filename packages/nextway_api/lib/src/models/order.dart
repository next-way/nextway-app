import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nextway_api/src/helpers/custom_datetime.dart';

part 'order.g.dart';

@JsonSerializable()
class DeliveryAddress {
  const DeliveryAddress({
    required this.name,
    required this.displayName,
    this.phone,
    this.mobile,
    this.companyName,
    this.street,
    this.street2,
    this.city,
    this.country,
    this.state,
    this.partnerLatitude,
    this.partnerLongitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  final String name;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String? phone;
  final String? mobile;
  @JsonKey(name: 'company_name')
  final String? companyName;
  final String? street;
  final String? street2;
  final String? city;
  final String? country;
  final String? state;
  @JsonKey(name: 'partner_latitude')
  final double? partnerLatitude;
  @JsonKey(name: 'partner_longitude')
  final double? partnerLongitude;
}

@JsonSerializable()
@CustomDateTimeConverter()
class Order {
  const Order({
    required this.id,
    required this.displayName,
    required this.dateOrder,
    required this.state,
    required this.deliveryAddress,
    required this.amountTotal,
    required this.scheduledDate,
    required this.deadlineDate,
    required this.expectedDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  @JsonKey(name: 'date_order')
  final DateTime dateOrder;
  final String state;
  final DeliveryAddress deliveryAddress;
  @JsonKey(name: 'amount_total')
  final double amountTotal;
  @JsonKey(name: 'scheduled_date')
  final DateTime? scheduledDate;
  @JsonKey(name: 'date_deadline')
  final DateTime? deadlineDate;
  @JsonKey(name: 'expected_date')
  final DateTime? expectedDate;

  DateTime? get schedule {
    if (expectedDate != null) {
      return expectedDate!;
    } else if (scheduledDate != null) {
      return scheduledDate!;
    }
    return deadlineDate;
  }

  String get scheduleVerbose {
    if (schedule == null) {
      return "Unscheduled";
    }
    String formattedYMD = DateFormat('yMd').format(schedule!);
    if (formattedYMD == DateFormat.yMd().format(DateTime.now())) {
      return "Today";
    }
    return DateFormat.yMMMMd('en_US').format(schedule!);
  }

  String get amountInPesos {
    var currencyFormat = NumberFormat.currency(
      locale: 'en_PH',
      // symbol: '\₱',
      symbol: '\u{20B1}',
      decimalDigits: 2,
    );
    return currencyFormat.format(amountTotal);
  }
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
