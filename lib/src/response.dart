part of http.json;

/// Response of the JSON request
class JsonResponse {
  /// The status code of the response.
  int get statusCode => inner.statusCode;

  /// The reason phrase associated with the status code.
  String get reasonPhrase => inner.reasonPhrase;

  /// Response headers
  Map<String, String> get headers => inner.headers;

  /// Body as [String]
  String get bodyStr => inner.body;

  /// JSON decoded body
  dynamic _body;

  /// Body decoded into Dart built-in object
  dynamic get body => _body;

  /// Underlying [http.Response] object
  final http.Response inner;

  /// Json serializer repository
  final JsonRepo repo;

  JsonResponse(this.inner, this.repo) {
    try {
      _body = JSON.decode(inner.body);
    } on FormatException catch (e) {
      // Do nothing!
    }
  }

  T withSerializer<T>(Serializer<T> serializer) => serializer.fromMap(body);

  T withRepo<T>(JsonRepo repo, {Type type}) {
    if (repo == null) throw new Exception('Repo not provided!');
    return repo.deserialize(body, type: type);
  }

  dynamic deserialize({Type type}) => repo.deserialize(inner.body, type: type);
}
