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

  Future<bool> cancelJobOrder(int orderId, String? message) async {
    String messageSubject =
        'Cancellation invoked on ${DateTime.now().toIso8601String()}';
    message = "$messageSubject<br/>$message";

    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();
    final makeRequest =
        apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;
    // NOTE Weird that appending slash on this url results to a 307 temporary redirect
    // However for the list items url above, append slash is necessary so temporary redirect won't happen
    // ¯\_(ツ)_/¯
    final request =
        makeRequest(baseUrl, '/orders/${orderId.toString()}/cancel-job');
    final response = await _httpClient.post(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        "Content-Type": "application/json",
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> acceptJobOrder(int orderId) async {
    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();
    final makeRequest =
        apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;
    final request =
        makeRequest(baseUrl, '/orders/${orderId.toString()}/accept');
    final response = await _httpClient.post(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> dropOffOrder(int orderId, DateTime dropOffDT,
      DateTime collectionDT, String? message) async {
    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();
    final makeRequest =
        apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;
    final request =
        makeRequest(baseUrl, '/orders/${orderId.toString()}/drop-off');
    final response = await _httpClient.post(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'drop_off_datetime': dropOffDT.toIso8601String(),
        'collection_datetime': collectionDT.toIso8601String(),
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Profile?> getProfile() async {
    /// TODO Cache?
    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();
    final makeRequest =
        apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;
    final request = makeRequest(baseUrl, '/users/me/');
    final response = await _httpClient.get(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<Statistics?> getStatistics() async {
    /// TODO Cache?
    var accessToken = await getAccessToken();
    String baseUrl = getBaseUrl();
    final makeRequest =
        apiConfig["flavorId"] == "development" ? Uri.http : Uri.https;
    final request = makeRequest(baseUrl, '/users/stats/');
    final response = await _httpClient.get(
      request,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        'Cache-Control': 'max-age=180', // 3 minutes
      },
    );

    if (response.statusCode == 200) {
      return Statistics.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
