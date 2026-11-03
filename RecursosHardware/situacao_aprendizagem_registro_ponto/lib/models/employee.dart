class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.nif,
  });

  final String id;
  final String name;
  final String email;
  final String nif;

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nif: json['nif']?.toString() ?? '',
    );
  }
}
