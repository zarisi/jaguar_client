part of http.json;

class AuthPayload {
  final String username;

  final String password;

  final Map<String, dynamic> payload;

  AuthPayload(this.username, this.password, {this.payload});

  Map<String, dynamic> toMap() {
    final ret = {
      'username': username,
      'password': password,
    };
    if (payload is Map) ret.addAll(payload);
    return ret;
  }
}
