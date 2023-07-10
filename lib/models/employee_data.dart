class Employee {
  Employee({
    required this.ID,
    required this.name,
    required this.amount,
    required this.status,
    required this.comment,
    required this.date
  });
  late final String ID;
  late final String name;
  late final String amount;
  late final String status;
  late final String comment;
  late final String date;

  Employee.fromJson(Map<String, dynamic> json){
    ID = json['ID'];
    name = json['name'];
    amount = json['amount'];
    status = json['status'];
    comment = json['comment'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    _data['name'] = name;
    _data['amount'] = amount;
    _data['status'] = status;
    _data['comment'] = comment;
    _data['date'] = date;
    return _data;
  }
}

List<Employee> DailyData = [
  Employee(ID: "ID", name: "شركة نبتة للبترول", amount: "1798500", status: "دائن", comment: "لصالح شركة نبتة", date: "7-5-2023")
];