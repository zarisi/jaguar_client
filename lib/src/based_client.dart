part of http.json;

/// Json client with a base path
class BasedJsonClient {
  /// The underlying http client used to make the requests
  final JsonClient jClient;

  JsonRepo get repo => jClient.repo;

  final String basePath;

  http.Client get client => jClient.client;

  BasedJsonClient(this.jClient, {this.basePath});

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> get(String url, {Map<String, String> headers}) =>
      jClient.get(basePath + url, headers: headers);

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> post(String url,
          {Map<String, String> headers, dynamic body}) =>
      jClient.post(basePath + url, headers: headers, body: body);

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> put(url, {Map<String, String> headers, dynamic body}) =>
      jClient.put(basePath + url, headers: headers, body: body);

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<JsonResponse> delete(url, {Map<String, String> headers, body}) =>
      jClient.delete(basePath + url, headers: headers);

  ResourceClient<IdType, ModelType>
      resource<IdType, ModelType extends Idied<IdType>>(
          Serializer<ModelType> serializer,
          {String path,
          StringToId<IdType> stringToId}) {
    return new ResourceClient(client, serializer,
        authority: basePath, path: path, stringToId: stringToId);
  }

  ResourceClient<IdType, ModelType>
      resourceFromRepo<IdType, ModelType extends Idied<IdType>>(
          {String path, StringToId<IdType> stringToId}) {
    return new ResourceClient(client, repo.getByType(ModelType),
        authority: basePath, path: path, stringToId: stringToId);
  }
}
