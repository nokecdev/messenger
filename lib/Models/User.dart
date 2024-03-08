class User {
  String email;
  String password;

  User({required this.email, required this.password});

  Future<bool> loginUser() async {
    print("Logging in user.... with email: " + email + "\nPassword: " + password);
    //Todo: Send request to server and handle login
    return true;
  }

  setUser(String password, String email) {
    this.email = email;
    this.password = password;
  }

  getUser() {
    return User(email: this.email, password: this.password);
  }
}