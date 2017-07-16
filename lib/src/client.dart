part of http.json;

class JsonClient {
  /// The underlying http client used to make the requests
  final http.Client client;

  final JsonRepo repo;

  final String basePath;

  final bool manageCookie;

  final CookieStore cookieStore = new CookieStore();

  final Map<String, String> defaultHeaders = {};

  String bearerAuthHeader;

  JsonClient(this.client,
      {JsonRepo repo, this.manageCookie: false, this.basePath})
      : repo = repo ?? new JsonRepo();

  void _addHeaders(final Map<String, String> headers,
      {bool isReqJson: true, bool isRespJson: true}) {
    if (isReqJson) headers['content-type'] = 'application/json';
    if (isRespJson) headers['Accept'] = 'application/json';
    headers["X-Requested-With"] = "XMLHttpRequest";
    if (manageCookie) headers['Cookie'] = cookieStore.header;

    headers.addAll(defaultHeaders);

    if(bearerAuthHeader is String) {
      final item = new AuthHeaderItem('Bearer', bearerAuthHeader);
      final authHeader = new AuthHeaders.fromHeaderStr(headers['authorization']);
      authHeader.addItem(item);
      headers['authorization'] = authHeader.toString();
    }
  }

  void _processResp(http.Response resp) {
    if (manageCookie) {
      cookieStore.addResponse(resp);
    }
    //    String contentType = resp.headers['content-type'];
//    if (contentType != 'application/json' && contentType != 'text/json') {
//      throw new Exception(
//          "Invalid mimetype $contentType returned for JSON request!");
//    }
  }

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> get(url, {final Map<String, String> headers}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders);

    http.Response resp = await client.get(url, headers: reqHeaders);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> post(url,
      {final Map<String, String> headers, body}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders);

    String bodyStr;
    if (body != null) {
      bodyStr = repo.serialize(body, withType: true);
    }

    http.Response resp =
        await client.post(url, headers: reqHeaders, body: bodyStr);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> put(url,
      {final Map<String, String> headers, body}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders);

    String bodyStr;
    if (body != null) {
      bodyStr = repo.serialize(body, withType: true);
    }

    http.Response resp =
        await client.put(url, headers: reqHeaders, body: bodyStr);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> delete(url, {final Map<String, String> headers}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders);

    http.Response resp = await client.delete(url, headers: reqHeaders);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  Future<JsonResponse> postForm(url,
      {final Map<String, String> headers, body}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders, isReqJson: false);

    Map<String, dynamic> bodyMap;
    if (body != null) {
      bodyMap = repo.to(body, withType: true);
    }

    http.Response resp =
        await client.post(url, headers: reqHeaders, body: bodyMap);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  /// Issues a JSON PUT request with url-encoded-form body and returns decoded
  /// JSON response as [JsonResponse]
  ///
  /// [url] can be [String] or [Uri]
  /// [headers] parameters can be used to add HTTP headers
  /// [body] can be a Dart built-in type or any PODO object. If it is PODO, [repo]
  /// is used to serialize the object
  Future<JsonResponse> putForm(url,
      {final Map<String, String> headers, body}) async {
    if (url is String && basePath is String) url = basePath + url;
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    _addHeaders(reqHeaders);

    Map<String, dynamic> bodyMap;
    if (body != null) {
      bodyMap = repo.to(body, withType: true);
    }

    http.Response resp =
        await client.put(url, headers: reqHeaders, body: bodyMap);
    _processResp(resp);

    return new JsonResponse(resp, repo);
  }

  static const String recapHeader = 'jaguar-recaptcha';

  /// Authenticates using JSON body
  ///
  /// \param[in] username Username for authentication
  /// \param[in] password Password for authentication
  /// \param[in] payload Extra payload
  Future<JsonResponse> authenticate(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool authHeader: false,
      String reCaptchaResp}) async {
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    if (reCaptchaResp is String) reqHeaders[recapHeader] = reCaptchaResp;

    if (url is String && basePath is String) url = basePath + url;
    Map<String, dynamic> body = payload.toMap();
    final JsonResponse resp = await post(url, body: body, headers: reqHeaders);
    if (authHeader) {
      _captureBearerHeader(resp);
    }
    return resp;
  }

  /// Authenticates using url-encoded-form
  ///
  /// \param[in] payload Authentication payload
  Future<JsonResponse> authenticateForm(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool authHeader: false,
      String reCaptchaResp}) async {
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    if (reCaptchaResp is String) reqHeaders[recapHeader] = reCaptchaResp;
    if (url is String && basePath is String) url = basePath + url;

    Map<String, dynamic> body = payload.toMap();
    final JsonResponse resp =
        await postForm(url, body: body, headers: reqHeaders);
    if (authHeader) {
      _captureBearerHeader(resp);
    }
    return resp;
  }

  /// Authenticates using Basic Authentication
  ///
  /// \param[in] payload Authentication payload
  Future<JsonResponse> authenticateBasic(AuthPayload payload,
      {url: '/api/login',
      final Map<String, String> headers,
      bool authHeader: false,
      String reCaptchaResp}) async {
    final reqHeaders = new Map<String, String>.from(headers ?? {});
    if (reCaptchaResp is String) reqHeaders[recapHeader] = reCaptchaResp;

    Map<String, dynamic> body = payload.toMap();

    {
      final auth = new AuthHeaders.fromHeaderStr(reqHeaders['authorization']);
      String credentials = const Base64Codec.urlSafe()
          .encode('${payload.username}:${payload.password}'.codeUnits);
      auth.addItem(new AuthHeaderItem('Basic', credentials));

      reqHeaders["authorization"] = auth.toString();
    }

    final JsonResponse resp = await post(url, body: body, headers: reqHeaders);
    if (authHeader) {
      _captureBearerHeader(resp);
    }
    return resp;
  }

  void _captureBearerHeader(JsonResponse resp) {
    final authHeader = new AuthHeaders.fromHeaderStr(resp.headers['authorization']);
    bearerAuthHeader = authHeader.items['Bearer']?.credentials;
  }

  Future<JsonResponse> logout(
      {url: '/api/logout',
      body,
      final Map<String, String> headers,
      bool authHeader: false}) async {
    final JsonResponse resp = await post(url, body: body, headers: headers);
    if (authHeader) bearerAuthHeader = null;
    return resp;
  }

  ResourceClient<IdType, ModelType>
      resource<IdType, ModelType extends Idied<IdType>>(
          Serializer<ModelType> serializer,
          {String basePath,
          StringToId<IdType> stringToId}) {
    return new ResourceClient(client, serializer,
        basePath: basePath, stringToId: stringToId);
  }

  ResourceClient<IdType, ModelType>
      resourceFromRepo<IdType, ModelType extends Idied<IdType>>(
          {String basePath, StringToId<IdType> stringToId}) {
    return new ResourceClient(client, repo.getByType(ModelType),
        basePath: basePath, stringToId: stringToId);
  }

  SerializedJsonClient serialized() =>
      new SerializedJsonClient(this, basePath: basePath);
}
