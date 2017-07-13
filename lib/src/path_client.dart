part of http.json;

/// Json client with a path endpoint
class PathJsonClient {
  /// host:port
  final String authority;

  final String path;

  /// The underlying http client used to make the requests
  final JsonClient jClient;

  JsonRepo get repo => jClient.repo;

  http.Client get client => jClient.client;

  PathJsonClient(this.jClient, {this.authority, this.path});

  String get fullBasePath => '$authority$path';

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> get(String url, {Map<String, String> headers}) =>
      jClient.get(fullBasePath, headers: headers);

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> post(String url,
          {Map<String, String> headers, dynamic body}) =>
      jClient.post(fullBasePath, headers: headers, body: body);

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> put(url, {Map<String, String> headers, dynamic body}) =>
      jClient.put(fullBasePath, headers: headers, body: body);

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> delete(url, {Map<String, String> headers, body}) =>
      jClient.delete(fullBasePath, headers: headers);

  ResourceClient<IdType, ModelType>
      resource<IdType, ModelType extends Idied<IdType>>(
          Serializer<ModelType> serializer,
          {StringToId<IdType> stringToId}) {
    return new ResourceClient(client, serializer,
        authority: authority, path: path, stringToId: stringToId);
  }

  ResourceClient<IdType, ModelType>
      resourceFromRepo<IdType, ModelType extends Idied<IdType>>(
          {StringToId<IdType> stringToId}) {
    return new ResourceClient(client, repo.getByType(ModelType),
        authority: authority, path: path, stringToId: stringToId);
  }
}
