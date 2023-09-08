class Receipt {
  late final String recieptId;
  late final String company;
  late final String source;
  late final String driver;
  late final String carPlate;
  late final String fuelType;
  late final int shortage;
  late final int amount;
  late final String arrive_date;
  late final String ship_date;
  late final String createdAt;
  late final String updatedAt;
  late final String? gaGasId;

  Receipt({
        required this.recieptId,
        required this.company,
        required this.source,
        required this.driver,
        required this.carPlate,
        required this.fuelType,
        required this.shortage,
        required this.amount,
        required this.arrive_date,
        required this.ship_date,
        required this.createdAt,
        required this.updatedAt,
        required this.gaGasId
  });

  Receipt.fromJson(Map<String, dynamic> json) {
    recieptId = json['reciept_id'];
    company = json['company'];
    source = json['source'];
    driver = json['driver'];
    carPlate = json['car_plate'];
    fuelType = json['fuel_type'];
    shortage = json['shortage'];
    amount = json['amount'];
    arrive_date = json['arrive_date'];
    ship_date = json['ship_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gaGasId = json['gaGasId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reciept_id'] = this.recieptId;
    data['company'] = this.company;
    data['source'] = this.source;
    data['driver'] = this.driver;
    data['car_plate'] = this.carPlate;
    data['fuel_type'] = this.fuelType;
    data['shortage'] = this.shortage;
    data['amount'] = this.amount;
    data['arrive_date'] = this.arrive_date;
    data['ship_date'] = this.ship_date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['gaGasId'] = this.gaGasId;
    return data;
  }
}
