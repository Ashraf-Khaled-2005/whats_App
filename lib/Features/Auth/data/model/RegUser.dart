class ReguserModel {
  final String email, pass, username, phone, imagefile, id;
  final List<String> Chatsids;

  const ReguserModel(
      {required this.id,
      required this.Chatsids,
      required this.phone,
      required this.email,
      required this.pass,
      required this.username,
      required this.imagefile});
}
