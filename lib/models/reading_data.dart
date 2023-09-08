class Reading {
  Reading({
    required this.readingId,
    required this.fReading,
    required this.lastReading,
    required this.date,
    required this.type,
    required this.pump_name,
    required this.amount,
    required this.returned,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.pumpPumpId,
  });
  late final String readingId;
  late final int fReading;
  late final int lastReading;
  late final String date;
  late final String type;
  late final String pump_name;
  late final int amount;
  late final int returned;
  late final int value;
  late final String createdAt;
  late final String updatedAt;
  late final Null pumpPumpId;

  Reading.fromJson(Map<String, dynamic> json){
    readingId = json['reading_id'];
    fReading = json['f_reading'];
    lastReading = json['last_reading'];
    date = json['date'];
    type = json['type'];
    pump_name = json['pump_name'];
    amount = json['amount'];
    returned = json['returned'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    pumpPumpId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['reading_id'] = readingId;
    _data['f_reading'] = fReading;
    _data['last_reading'] = lastReading;
    _data['date'] = date;
    _data['type'] = type;
    _data['pump_name'] = pump_name;
    _data['amount'] = amount;
    _data['returned'] = returned;
    _data['value'] = value;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['pumpPumpId'] = pumpPumpId;
    return _data;
  }
}