class Employee {
  Employee({
    required this.empId,
    required this.name,
    required this.address,
    required this.Ssn,
    required this.phoneNum,
    required this.salary,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String empId;
  late final String name;
  late final String address;
  late final String Ssn;
  late final int phoneNum;
  late final String salary;
  late final String comment;
  late final String createdAt;
  late final String updatedAt;

  Employee.fromJson(Map<String, dynamic> json){
    empId = json['emp_id'];
    name = json['name'];
    address = json['address'];
    Ssn = json['Ssn'];
    phoneNum = json['phoneNum'];
    salary = json['salary'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['emp_id'] = empId;
    _data['name'] = name;
    _data['address'] = address;
    _data['Ssn'] = Ssn;
    _data['phoneNum'] = phoneNum;
    _data['salary'] = salary;
    _data['comment'] = comment;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}