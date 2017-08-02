import 'package:matcher/matcher.dart';
import 'package:jaguar_client/jaguar_client.dart';

/// Validates that [JsonResponse] has the expected HTTP status code
///
///     final JsonResponse resp = await client.get(url);
///     expect(resp, hasStatus(200));
Matcher hasStatus(int statusCode) => new _HasStatus(statusCode);

class _HasStatus extends Matcher {
  final int statusCode;

  _HasStatus(this.statusCode);

  @override
  bool matches(item, Map matchState) {
    if (item is! JsonResponse) {
      matchState["runtimeType"] = item.runtimeType;
      return false;
    }

    final response = item as JsonResponse;
    if (response.statusCode != statusCode) {
      matchState["actual"] = response.statusCode;
      return false;
    }

    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('StatusCode of JsonResponse must be $statusCode');

  @override
  Description describeMismatch(
      dynamic item, Description descriptions, Map matchState, bool verbose) {
    final Type typeMismatch = matchState["runtimeType"];
    if (typeMismatch != null) {
      descriptions.add("Is not an instance of JsonResponse");
      return descriptions;
    }

    final int actual = matchState["actual"];
    descriptions.add(
        "StatusCodes are different. Expected: $statusCode. Actual: $actual");
    return descriptions;
  }
}

/// Validates that [JsonResponse] has the expected body string
///
///     final JsonResponse resp = await client.get(url);
///     expect(resp, hasStatus(200));
Matcher hasBodyStr(String bodyStr) => new _HasBodyStr(bodyStr);

class _HasBodyStr extends Matcher {
  final String bodyStr;

  _HasBodyStr(this.bodyStr);

  @override
  bool matches(item, Map matchState) {
    if (item is! JsonResponse) {
      matchState["runtimeType"] = item.runtimeType;
      return false;
    }

    final response = item as JsonResponse;
    if (response.bodyStr != bodyStr) {
      matchState["actual"] = response.bodyStr;
      return false;
    }

    return true;
  }

  @override
  Description describe(Description description) =>
      description.add('Body string of JsonResponse must be $bodyStr');

  @override
  Description describeMismatch(
      dynamic item, Description descriptions, Map matchState, bool verbose) {
    final Type typeMismatch = matchState["runtimeType"];
    if (typeMismatch != null) {
      descriptions.add("Is not an instance of JsonResponse");
      return descriptions;
    }

    final String actual = matchState["actual"];
    descriptions.add(
        "BodyStrings are different. Expected: $bodyStr. Actual: $actual");
    return descriptions;
  }
}

//TODO add hasHeader matcher

//TODO add hasCookie matcher