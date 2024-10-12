class MyUserData {
  final String image, username, email, phone, id;
  List<dynamic>? ids;

  MyUserData(
      {required this.image,
      required this.username,
      required this.email,
      required this.phone,
      required this.id,
      required this.ids});
  factory MyUserData.fromJson(Map<String, dynamic> json) {
    return MyUserData(
      image: json['image'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      id: json['id'],
      ids: json['ids'],
    );
  }
}
