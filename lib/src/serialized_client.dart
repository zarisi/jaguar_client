part of http.json;

/// Json client with a base path
class SerializedJsonClient {
  /// The underlying http client used to make the requests
  final JsonClient jClient;

  JsonRepo get repo => jClient.repo;

  final String basePath;

  http.Client get client => jClient.client;

  SerializedJsonClient(this.jClient, {this.basePath});

  /// Issues a JSON GET request and returns decoded JSON response as [JsonResponse]
  Future<T> get<T>(String url, {Map<String, String> headers}) async {
    final JsonResponse resp =
        await jClient.get(basePath + url, headers: headers);
    return resp.deserialize(type: T);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<T> post<T>(String url,
      {Map<String, String> headers, dynamic body}) async {
    final JsonResponse resp =
        await jClient.post(basePath + url, headers: headers, body: body);
    return resp.deserialize(type: T);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<T> put<T>(url, {Map<String, String> headers, dynamic body}) async {
    final JsonResponse resp =
        await jClient.put(basePath + url, headers: headers, body: body);
    return resp.deserialize(type: T);
  }

  /// Issues a JSON DELETE request and returns decoded JSON response as [JsonResponse]
  Future<T> delete<T>(url, {Map<String, String> headers, body}) async {
    final JsonResponse resp =
        await jClient.delete(basePath + url, headers: headers);
    return resp.deserialize(type: T);
  }

  /// Issues a JSON POST request and returns decoded JSON response as [JsonResponse]
  Future<T> postForm<T>(String url,
      {Map<String, String> headers, dynamic body}) async {
    final JsonResponse resp =
        await jClient.postForm(basePath + url, headers: headers, body: body);
    return resp.deserialize(type: T);
  }

  /// Issues a JSON PUT request and returns decoded JSON response as [JsonResponse]
  Future<T> putForm<T>(url, {Map<String, String> headers, dynamic body}) async {
    final JsonResponse resp =
        await jClient.putForm(basePath + url, headers: headers, body: body);
    return resp.deserialize(type: T);
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
}
