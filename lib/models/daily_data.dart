class Daily {
  Daily({
    required this.tranId,
    required this.name,
    required this.type,
    required this.gas_type,
    required this.amount,
    required this.gas_amount,
    required this.comment,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.dailyDailyId,
    this.gaGasId,
  });
  late final String tranId;
  late final String name;
  late final String type;
  late final String gas_type;
  late final int amount;
  late final int gas_amount;
  late final String comment;
  late final String date;
  late final String createdAt;
  late final String updatedAt;
  late final Null dailyDailyId;
  late final Null gaGasId;

  Daily.fromJson(Map<String, dynamic> json){
    tranId = json['tran_id'];
    name = json['name'];
    type = json['type'];
    gas_type = json['gas_type'];
    amount = json['amount'];
    gas_amount = json['gas_amount'];
    comment = json['comment'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    dailyDailyId = null;
    gaGasId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tran_id'] = tranId;
    _data['name'] = name;
    _data['type'] = type;
    _data['gas_type'] = gas_type;
    _data['amount'] = amount;
    _data['gas_amount'] = gas_amount;
    _data['comment'] = comment;
    _data['date'] = date;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['dailyDailyId'] = dailyDailyId;
    _data['gaGasId'] = gaGasId;
    return _data;
  }
}