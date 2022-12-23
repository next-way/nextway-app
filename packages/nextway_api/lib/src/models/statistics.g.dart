// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Statistics',
      json,
      ($checkedConvert) {
        final val = Statistics(
          orders: $checkedConvert(
              'orders', (v) => OrderStats.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

OrderStats _$OrderStatsFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderStats',
      json,
      ($checkedConvert) {
        final val = OrderStats(
          assigned: $checkedConvert('assigned', (v) => v as int),
          completed: $checkedConvert('completed', (v) => v as int),
          completedInMonth:
              $checkedConvert('completed_in_month', (v) => v as int),
          period: $checkedConvert('current_period', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'completedInMonth': 'completed_in_month',
        'period': 'current_period'
      },
    );
