class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.phoneNum,
    required this.Ssn,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int phoneNum;
  late final String Ssn;
  late final int salary;
  late final String createdAt;
  late final String updatedAt;

  Employee.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phoneNum = json['phoneNum'];
    Ssn = json['Ssn'];
    salary = json['salary'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phoneNum'] = phoneNum;
    _data['Ssn'] = Ssn;
    _data['salary'] = salary;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}