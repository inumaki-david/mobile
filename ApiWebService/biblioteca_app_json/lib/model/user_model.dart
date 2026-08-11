class UserModel {
  //atributos
  final String? id;
  final String name;
  final String email;

  //construtor
  UserModel({this.id, required this.name, required this.email});

  // métodos
  //toMAp => OBJ => MAP
  Map<String, dynamic> toMap() => {"id": id, "name": name, "email": email};

  //fromMap => MAP -> OBJ
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map["id"].toString(),
    name: map["name"].toString(),
    email: map["email"].toString(),
  );
}

// class UserModel {
//   String? id;
//   String name;
//   String email;

//   UserModel({
//     this.id,
//     required this.name,
//     required this.email,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//     };
//   }
// }