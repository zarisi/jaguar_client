# teja_http_json

Write concise JSON API clients

# Usage

## Get request

```dart
final JsonResponse resp =
    await client.get('http://localhost:8080/api/list');
print(resp.body);
```

## Post request

```dart
final JsonResponse resp = await client
    .post('http://localhost:8080/api/map', body: {'posting': 'hello'});
print(resp.body);
```

## Put request

```dart
final JsonResponse resp = await client
    .put('http://localhost:8080/api/map', body: {'putting': 'hello'});
print(resp.body);
```

## Delete request

```dart
final JsonResponse resp =
    await client.delete('http://localhost:8080/api/map/123?query=why');
print(resp.body);
```
