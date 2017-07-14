// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_client/jaguar_client.dart';

@Api(path: '/api')
class ExampleApi {
  @Get(path: '/map')
  Response<String> getMap(Context ctx) => Response.json({
        'jaguar': 'awesome',
      });

  @Get(path: '/list')
  Response<String> getList(Context ctx) => Response.json(['Hello', 'World']);

  @Get(path: '/string')
  Response<String> getString(Context ctx) => Response.json("Jaguar");

  @Get(path: '/header')
  Response<String> getHeader(Context ctx) =>
      Response.json({'testing': ctx.req.headers.value('jaguar-testing')});

  @Post(path: '/map')
  Future<Response<String>> postMap(Context ctx) async =>
      Response.json(await ctx.req.bodyAsJsonMap());

  @Put(path: '/map')
  Future<Response<String>> putMap(Context ctx) async =>
      Response.json(await ctx.req.bodyAsJsonMap());

  @Delete(path: '/map/:id')
  Response<String> deleteMap(Context ctx) =>
      Response.json({'id': ctx.pathParams.id, 'query': ctx.queryParams.query});
}

Future serve() async {
  Jaguar server = new Jaguar();
  server.addApiReflected(new ExampleApi());
  await server.serve();
}

Future client() async {
  final http.Client baseClient = new http.Client();
  final JsonClient client = new JsonClient(baseClient);

  {
    final JsonResponse resp = await client.get('http://localhost:8080/api/map');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.get('http://localhost:8080/api/list');
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.get('http://localhost:8080/api/string');
    print(resp.body);
  }

  {
    final JsonResponse resp = await client.get(
        'http://localhost:8080/api/header',
        headers: {'jaguar-testing': 'testing 1 2 3'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .post('http://localhost:8080/api/map', body: {'posting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp = await client
        .put('http://localhost:8080/api/map', body: {'putting': 'hello'});
    print(resp.body);
  }

  {
    final JsonResponse resp =
        await client.delete('http://localhost:8080/api/map/123?query=why');
    print(resp.body);
  }
}

main() async {
  await serve();
  await client();

  exit(0);
}
