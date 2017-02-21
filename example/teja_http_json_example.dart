// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:teja_http_json/teja_http_json.dart';

@Api(path: '/api')
class ExampleApi {
  @Get(path: '/map')
  @WrapEncodeMapToJson()
  Map getMap() => {
        'jaguar': 'awesome',
      };

  @Get(path: '/list')
  @WrapEncodeListToJson()
  List getList() => ['Hello', 'World'];

  @Get(path: '/string')
  @WrapEncodeToJson()
  String getString() => "Jaguar";

  @Get(path: '/header')
  @WrapEncodeMapToJson()
  Map getHeader(@InputHeader('jaguar-testing') String header) =>
      {'testing': header};

  @Post(path: '/map')
  @WrapDecodeJsonMap()
  @WrapEncodeMapToJson()
  Map postMap(@Input(DecodeJsonMap) Map body) => body;

  @Put(path: '/map')
  @WrapDecodeJsonMap()
  @WrapEncodeMapToJson()
  Map putMap(@Input(DecodeJsonMap) Map body) => body;

  @Delete(path: '/map/:id')
  @WrapEncodeMapToJson()
  Map deleteMap(String id, {String query}) => {
    'id': id,
    'query': query
  };
}

Future serve() async {
  Jaguar server = new Jaguar();
  server.addApi(reflectJaguar(new ExampleApi()));
  await server.serve();
}

Future client() async {
  final http.Client baseClient = new http.Client();
  final JsonClient client = new JsonClient(baseClient);

  {
    final JsonResponse resp =
        await client.getJson('http://localhost:8080/api/map');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.getJson('http://localhost:8080/api/list');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.getJson('http://localhost:8080/api/string');
    print(resp.body);
  }

  {
    final JsonResponse resp = await client.getJson(
        'http://localhost:8080/api/header',
        headers: {'jaguar-testing': 'testing 1 2 3'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .postJson('http://localhost:8080/api/map', body: {'posting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .putJson('http://localhost:8080/api/map', body: {'putting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .deleteJson('http://localhost:8080/api/map/123?query=why');
    print(resp.body);
  }
}

main() async {
  await serve();
  await client();

  exit(0);
}
