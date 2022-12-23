import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  const Statistics({
    required this.orders,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);

  final OrderStats orders;
}

@JsonSerializable()
class OrderStats {
  const OrderStats({
    required this.assigned,
    required this.completed,
    required this.completedInMonth,
    required this.period,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) =>
      _$OrderStatsFromJson(json);

  final int assigned;
  final int completed;
  @JsonKey(name: "completed_in_month")
  final int completedInMonth;
  @JsonKey(name: "current_period")
  final String period;
}
