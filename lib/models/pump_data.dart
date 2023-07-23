import 'dart:convert';

Pump PumpResponseJson (String str) =>
    Pump.fromJson(json.decode(str));

class Pump {
  Pump({
    required this.pumpId,
    required this.type,
    required this.name,
    required this.reading,
    required this.createdAt,
    required this.updatedAt,
    this.dailyDailyId,
    this.gaGasId,
  });
  late final String pumpId;
  late final String type;
  late final String name;
  late final int reading;
  late final String createdAt;
  late final String updatedAt;
  late final Null dailyDailyId;
  late final Null gaGasId;

  Pump.fromJson(Map<String, dynamic> json){
    pumpId = json['pump_id'];
    type = json['type'];
    name = json['name'];
    reading = json['reading'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    dailyDailyId = null;
    gaGasId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pump_id'] = pumpId;
    _data['type'] = type;
    _data['name'] = name;
    _data['reading'] = reading;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['dailyDailyId'] = dailyDailyId;
    _data['gaGasId'] = gaGasId;
    return _data;
  }
}