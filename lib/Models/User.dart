// ignore_for_file: file_names
class User {
  String email;
  String password;
  String? token;
  String? guid;

  User({required this.email, required this.password, this.token, this.guid});

  setUser(String password, String email) {
    this.email = email;
    this.password = password;
  }

  getUser() {
    return User(
        email: email,
        password: password,
        token: token,
        guid: guid);
  }
}
