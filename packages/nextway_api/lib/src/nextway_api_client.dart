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
  NextwayApiClient(this.apiConfig, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api-stage42.next-way.org';

  late Map apiConfig;
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

  String getBaseUrl() {
    return apiConfig["apiBaseUrl"] ?? _baseUrl;
  }

  /// Finds a set of [Order] `/orders/?state={query}`
  Stream<OrderResponse> orderSearch(String query,
      {int size = 10, int page = 1}) async* {
    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();

    // When making HTTPS call to HTTP endpoint, this happens https://stackoverflow.com/a/64422336
    // Server side: WARNING:  Invalid HTTP request received.
    final makeRequest =
        this.apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;

    // If query is provided
    List<String> states = [
      'assigned',
      'unassigned',
      'waiting',
      'confirmed',
      'done',
      'cancelled'
    ];
    if (query.isNotEmpty) {
      if (query == "scheduled") {
        states = ['assigned'];
      } else if (query == 'unassigned') {
        states = ['unassigned', 'waiting'];
      }
    }
    final request = makeRequest(baseUrl, '/orders/', {
      'state': states,
      'size': size.toString(),
      'page': page.toString(),
    }
        // TODO Count, pagination?
        );

    final response = await _httpClient.get(request,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'});

    if (response.statusCode != 200) {
      throw OrderRequestFailure();
    }

    final ordersJson = jsonDecode(response.body);

    // List<Order> orders = List<Order>.from(
    //     ordersJson["items"].map<Order>((model) => Order.fromJson(model)));
    // // for (final order in orders) {
    // //   yield order;
    // // }
    OrderResponse orderResponse = OrderResponse.fromJson(ordersJson);

    yield* Stream.value(orderResponse);
  }
}
