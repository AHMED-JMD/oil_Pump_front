class DailyData {
  DailyData({
    required this.dailyId,
    required this.date,
    required this.amount,
    required this.safe,
    required this.createdAt,
    required this.updatedAt,
    this.bankBanksId,
  });
  late final String dailyId;
  late final String date;
  late final int amount;
  late final int safe;
  late final String createdAt;
  late final String updatedAt;
  late final Null bankBanksId;

  DailyData.fromJson(Map<String, dynamic> json){
    dailyId = json['daily_id'];
    date = json['date'];
    amount = json['amount'];
    safe = json['safe'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    bankBanksId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['daily_id'] = dailyId;
    _data['date'] = date;
    _data['amount'] = amount;
    _data['safe'] = safe;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['bankBanksId'] = bankBanksId;
    return _data;
  }
}