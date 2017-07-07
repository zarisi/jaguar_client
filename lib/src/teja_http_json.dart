// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library http.json;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jaguar_serializer/serializer.dart';

part 'response.dart';

class JsonClient {
  /// The underlying http client used to make the requests
  final http.Client client;

  final JsonRepo repo;

  JsonClient(this.client, {this.repo});

  void _addJSONHeaders(Map<String, String> headers) {
    headers['content-type'] = 'application/json';
    headers['Accept'] = 'application/json';
    headers["X-Requested-With"] = "XMLHttpRequest";
  }

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> get(url,
      {Map<String, String> headers, Encoding encoding}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    http.Response resp = await client.get(url, headers: headers);

//    String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> post(url,
      {Map<String, String> headers,
      dynamic body,
      Encoding encoding,
      bool serialize: false}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      if (!serialize) {
        bodyStr = JSON.encode(body);
      } else {
        if(repo == null) throw new Exception('Repo not provided!');
        bodyStr = repo.serialize(body);
      }
    }

    http.Response resp =
        await client.post(url, headers: headers, body: bodyStr);

//    final String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> put(url,
      {Map<String, String> headers,
      dynamic body,
      Encoding encoding,
      bool serialize: false}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      if (!serialize) {
        bodyStr = JSON.encode(body);
      } else {
        if(repo == null) throw new Exception('Repo not provided!');
        bodyStr = repo.serialize(body);
      }
    }

    http.Response resp = await client.put(url, headers: headers, body: bodyStr);

//    final String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> delete(url,
      {Map<String, String> headers, Encoding encoding}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    http.Response resp = await client.delete(url, headers: headers);

//    final String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }

    return new JsonResponse(resp, repo);
  }
}
