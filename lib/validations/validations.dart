String? validateEmail(String? text) {
  if (text == null || text.isEmpty || !text.contains("@")) {
    return "Invalid email address.";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 8 || value.isEmpty) {
    return "Password should be minimum 8 characters.";
  } 
  return null;
}
