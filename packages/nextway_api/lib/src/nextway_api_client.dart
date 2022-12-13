import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nextway_api/nextway_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Exception thrown when orderSearch fails.
class OrderRequestFailure implements Exception {}

// Exposes two methods
// orderSearch which returns a Future<Order>

/// {@template nextway_api_client}
/// Dart API Client for [Nextway ERP API](https://github.com/next-way/nextway-erp-api).
/// {@endtemplate}
class NextwayApiClient {
  /// {@macro nextway_api_client}
  NextwayApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api-stage42.next-way.org';

  final http.Client _httpClient;
  late SharedPreferences prefs;
  String _accessToken = '';
  String get accessToken => _accessToken;
  set accessToken(String _value) {
    _accessToken = _value;
    prefs.setString('ff_accessToken', _value);
  }

  Future<String> getAccessToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('ff_accessToken') ?? _accessToken;
  }

  /// Finds a set of [Order] `/orders/?state={query}`
  Stream<List<Order>> orderSearch(String query) async* {
    var accessToken = await getAccessToken();
    final request = Uri.https(_baseUrl, '/orders',
        {'state': 'assigned,unassigned,waiting,confirmed,done,cancelled'}
        // TODO Count, pagination?
        );

    final response = await _httpClient.get(request,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});

    if (response.statusCode != 200) {
      throw OrderRequestFailure();
    }

    final ordersJson = jsonDecode(response.body);

    List<Order> orders =
        List<Order>.from(ordersJson.map((model) => Order.fromJson(model)));
    // for (final order in orders) {
    //   yield order;
    // }
    yield* Stream.value(orders);
  }
}
