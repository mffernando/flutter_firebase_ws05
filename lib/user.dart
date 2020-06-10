
class User{
  int id;
  String email;
  String password;

  User({this.id, this.email, this.password});

  //get user
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      email: map["email"],
      password: map["password"]);
  }

  //update, delete, insert products
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "password": password
    };
  }
}
