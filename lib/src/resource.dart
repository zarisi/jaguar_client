part of http.json;

typedef IdType StringToId<IdType>(String idStr);

class ResourceClient<IdType, ModelType extends Idied<IdType>> {
  final http.Client client;

  final JsonClient _jC;

  /// host:port
  final String authority;

  final String path;

  final Serializer<ModelType> serializer;

  final StringToId<IdType> stringToId;

  ResourceClient(this.client, this.serializer,
      {this.authority, this.path, this.stringToId})
      : _jC = new JsonClient(client) {}

  String get fullBasePath => '$authority$path';

  String fullBasePathId(IdType id) => '$authority$path/$id';

  Future<List<ModelType>> getAll() async {
    final url = Uri.parse(fullBasePath);
    final JsonResponse resp = await _jC.get(url);
    return (resp.body as List<Map>)
        .map((Map map) => serializer.fromMap(map))
        .toList();
  }

  Future<ModelType> getById(IdType id) async {
    final url = Uri.parse(fullBasePathId(id));
    final JsonResponse resp = await _jC.get(url);
    return serializer.fromMap(resp.body);
  }

  Future<IdType> insert(ModelType model) async {
    final url = Uri.parse(fullBasePath);
    final JsonResponse resp =
        await _jC.post(url, body: serializer.toMap(model));
    if (stringToId == null) {
      if (IdType == String) return resp.body;
      throw new Exception("stringToId converter must be specified!");
    }
    return stringToId(resp.body);
  }

  Future<int> update(ModelType model) async {
    final url = Uri.parse(fullBasePath);
    final JsonResponse resp = await _jC.put(url, body: serializer.toMap(model));
    return resp.body;
  }

  Future<int> removeById(IdType id) async {
    final url = Uri.parse(fullBasePathId(id));
    final JsonResponse resp = await _jC.delete(url);
    return resp.body;
  }

  Future<int> removeAll() async {
    final url = Uri.parse(fullBasePath);
    final JsonResponse resp = await _jC.delete(url);
    return resp.body;
  }
}
