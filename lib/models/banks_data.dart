class Banks {
  Banks({
    required this.banks_id,
    required this.bank_name,
    required this.amount,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String banks_id;
  late final String bank_name;
  late final int amount;
  late final String date;
  late final String createdAt;
  late final String updatedAt;

  Banks.fromJson(Map<String, dynamic> json){
    banks_id = json['banks_id'];
    bank_name = json['bank_name'];
    amount = json['amount'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['banks_id'] = banks_id;
    _data['bank_name'] = bank_name;
    _data['amount'] = amount;
    _data['date'] = date;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}