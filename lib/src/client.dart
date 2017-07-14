part of http.json;

class JsonClient {
  /// The underlying http client used to make the requests
  final http.Client client;

  final JsonRepo repo;

  JsonClient(this.client, {JsonRepo repo}) : repo = repo ?? new JsonRepo();

  void _addJSONHeaders(Map<String, String> headers) {
    headers['content-type'] = 'application/json';
    headers['Accept'] = 'application/json';
    headers["X-Requested-With"] = "XMLHttpRequest";
  }

  void _isRespJson(http.Response resp) {
    //    String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }
  }

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> get(url, {Map<String, String> headers}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    http.Response resp = await client.get(url, headers: headers);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> post(url, {Map<String, String> headers, body}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      bodyStr = repo.serialize(body, withType: true);
    }

    http.Response resp =
        await client.post(url, headers: headers, body: bodyStr);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> put(url, {Map<String, String> headers, body}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      bodyStr = repo.serialize(body, withType: true);
    }

    http.Response resp = await client.put(url, headers: headers, body: bodyStr);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> delete(url, {Map<String, String> headers}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    http.Response resp = await client.delete(url, headers: headers);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  Future<JsonResponse> postForm(url,
      {Map<String, String> headers, body}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    Map<String, dynamic> bodyMap;
    if (body != null) {
      bodyMap = repo.to(body, withType: true);
    }

    http.Response resp =
        await client.post(url, headers: headers, body: bodyMap);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON PUT request with url-encoded-form body and returns decoded
  /// JSON response as [JsonResponse]
  ///
  /// [url] can be [String] or [Uri]
  /// [headers] parameters can be used to add HTTP headers
  /// [body] can be a Dart built-in type or any PODO object. If it is PODO, [repo]
  /// is used to serialize the object
  /// []
  Future<JsonResponse> putForm(url, {Map<String, String> headers, body}) async {
    if (headers is! Map) headers = <String, String>{};
    _addJSONHeaders(headers);

    String bodyStr;
    if (body != null) {
      bodyStr = repo.serialize(body, withType: true);
    }

    http.Response resp = await client.put(url, headers: headers, body: bodyStr);
    _isRespJson(resp);

    return new JsonResponse(resp, repo);
  }

  /// Authenticates using JSON body
  ///
  /// \param[in] username Username for authentication
  /// \param[in] password Password for authentication
  /// \param[in] payload Extra payload
  Future<JsonResponse> authenticate(AuthPayload payload,
      {url: '/api/login', Map<String, String> headers}) async {
    Map<String, dynamic> body = payload.toMap();
    final JsonResponse resp = await post(url, body: body, headers: headers);
    //TODO
    return resp;
  }

  /// Authenticates using url-encoded-form
  ///
  /// \param[in] payload Authentication payload
  Future<JsonResponse> authenticateForm(AuthPayload payload,
      {url: '/api/login', Map<String, String> headers}) async {
    Map<String, dynamic> body = payload.toMap();
    final JsonResponse resp = await postForm(url, body: body, headers: headers);
    //TODO
    return resp;
  }

  /// Authenticates using Basic Authentication
  ///
  /// \param[in] payload Authentication payload
  Future<JsonResponse> authenticateBasic(AuthPayload payload,
      {url: '/api/login', Map<String, String> headers}) async {
    Map<String, dynamic> body = payload.toMap();

    final auth = new AuthHeaders();
    String credentials = const Base64Codec.urlSafe()
        .encode('${payload.username}:${payload.password}'.codeUnits);
    auth.addItem(new AuthHeaderItem('Basic', credentials));

    if (headers == null) headers = {};

    headers[HttpHeaders.AUTHORIZATION] = auth.toString();

    final JsonResponse resp = await post(url, body: body, headers: headers);
    //TODO
    return resp;
  }

  ResourceClient<IdType, ModelType>
      resource<IdType, ModelType extends Idied<IdType>>(
          Serializer<ModelType> serializer, String authority,
          {String path, StringToId<IdType> stringToId}) {
    return new ResourceClient(client, serializer,
        authority: authority, path: path, stringToId: stringToId);
  }

  ResourceClient<IdType, ModelType>
      resourceFromRepo<IdType, ModelType extends Idied<IdType>>(
          String authority,
          {String path,
          StringToId<IdType> stringToId}) {
    return new ResourceClient(client, repo.getByType(ModelType),
        authority: authority, path: path, stringToId: stringToId);
  }

  BasedJsonClient based(String basePath) =>
      new BasedJsonClient(this, basePath: basePath);

  PathJsonClient pathed(String authority, [String path]) =>
      new PathJsonClient(this, authority: authority, path: path);
}
