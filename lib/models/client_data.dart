class Clients {
  late final String empId;
  late final String name;
  late final String address;
  late final int phoneNum;
  late final int account;
  late final int gas_amount;
  late final int benz_amount;
  late final String comment;
  late final String createdAt;
  late final String updatedAt;

  Clients(
      { required this.empId,
        required this.name,
        required this.address,
        required this.phoneNum,
        required this.account,
        required this.gas_amount,
        required this.benz_amount,
        required this.comment,
        required this.createdAt,
        required this.updatedAt});

  Clients.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    name = json['name'];
    address = json['address'];
    phoneNum = json['phoneNum'];
    account = json['account'];
    gas_amount = json['gas_amount'];
    benz_amount = json['benz_amount'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phoneNum'] = this.phoneNum;
    data['account'] = this.account;
    data['gas_amount'] = this.gas_amount;
    data['benz_amount'] = this.benz_amount;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
