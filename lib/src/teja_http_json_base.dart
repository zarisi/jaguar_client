// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart' as http;
import 'dart:convert';

/// Response of the JSON request
class JsonResponse {
  /// The status code of the response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String reasonPhrase;

  /// Response headers
  final Map<String, String> headers;

  /// JSON decoded body
  final body;

  const JsonResponse(this.statusCode, this.reasonPhrase, this.headers, this.body);
}

class JsonClient {
  /// The underlying http client used to make the requests
  final http.Client client;

  JsonClient(this.client);

  void _addJSONHeaders(Map<String, String> headers) {
    headers['Content-type'] = 'application/json';
    headers['Accept'] = 'application/json';
    headers["X-Requested-With"] = "XMLHttpRequest";
  }

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> getJson(url,
      {Map<String, String> headers: const {}, Encoding encoding}) async {
    _addJSONHeaders(headers);

    http.Response resp = await client.get(url, headers: headers);

    final String contentType = headers['Content-type'];
    if (contentType != 'application/json' && contentType != 'text/json') {
      throw new Exception(
          "Invalid mimetype $contentType returned for JSON request!");
    }

    final jsonBody = JSON.decode(resp.body);
    return new JsonResponse(
        resp.statusCode, resp.reasonPhrase, resp.headers, jsonBody);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> postJson(url,
      {Map<String, String> headers: const {},
      dynamic body,
      Encoding encoding}) async {
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      JSON.encode(body);
    }

    http.Response resp =
    await client.post(url, headers: headers, body: bodyStr);

    final String contentType = headers['Content-type'];
    if (contentType != 'application/json' && contentType != 'text/json') {
      throw new Exception(
          "Invalid mimetype $contentType returned for JSON request!");
    }

    final jsonBody = JSON.decode(resp.body);
    return new JsonResponse(
        resp.statusCode, resp.reasonPhrase, resp.headers, jsonBody);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> putJson(url,
      {Map<String, String> headers: const {},
      dynamic body,
      Encoding encoding}) async {
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      JSON.encode(body);
    }

    http.Response resp = await client.put(url, headers: headers, body: bodyStr);

    final String contentType = headers['Content-type'];
    if (contentType != 'application/json' && contentType != 'text/json') {
      throw new Exception(
          "Invalid mimetype $contentType returned for JSON request!");
    }

    final jsonBody = JSON.decode(resp.body);
    return new JsonResponse(
        resp.statusCode, resp.reasonPhrase, resp.headers, jsonBody);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> deleteJson(url,
      {Map<String, String> headers: const {}, Encoding encoding}) async {
    _addJSONHeaders(headers);

    http.Response resp = await client.delete(url, headers: headers);

    final String contentType = headers['Content-type'];
    if (contentType != 'application/json' && contentType != 'text/json') {
      throw new Exception(
          "Invalid mimetype $contentType returned for JSON request!");
    }

    final jsonBody = JSON.decode(resp.body);
    return new JsonResponse(
        resp.statusCode, resp.reasonPhrase, resp.headers, jsonBody);
  }
}
