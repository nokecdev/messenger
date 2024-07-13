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
        email: this.email,
        password: this.password,
        token: this.token,
        guid: this.guid);
  }
}
