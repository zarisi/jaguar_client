part of http.json;

/// Response of the JSON request
class JsonResponse {
  /// The status code of the response.
  int get statusCode => inner.statusCode;

  /// The reason phrase associated with the status code.
  String get reasonPhrase => inner.reasonPhrase;

  /// Response headers
  Map<String, String> get headers => inner.headers;

  /// JSON decoded body
  dynamic _body;

  dynamic get body => _body;

  final http.Response inner;

  final JsonRepo repo;

  JsonResponse(this.inner, this.repo) {
    try {
      _body = JSON.decode(inner.body);
    } on FormatException catch (e) {
      // Do nothing!
    }
  }

  T withSerializer<T>(Serializer<T> serializer) => serializer.fromMap(body);

  T withRepo<T>(JsonRepo repo) {
    if(repo == null) throw new Exception('Repo not provided!');
    return repo.deserialize(body);
  }

  dynamic deserialize() => repo.deserialize(inner.body);
}
