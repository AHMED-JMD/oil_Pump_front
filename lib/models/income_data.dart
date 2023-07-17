class Receipt {
  late final String recieptId;
  late final String driver;
  late final String carPlate;
  late final String fuelType;
  late final int amount;
  late final String date;
  late final String createdAt;
  late final String updatedAt;
  late final Null gaGasId;

  Receipt({
        required this.recieptId,
        required this.driver,
        required this.carPlate,
        required this.fuelType,
        required this.amount,
        required this.date,
        required this.createdAt,
        required this.updatedAt,
        required this.gaGasId});

  Receipt.fromJson(Map<String, dynamic> json) {
    recieptId = json['reciept_id'];
    driver = json['driver'];
    carPlate = json['car_plate'];
    fuelType = json['fuel_type'];
    amount = json['amount'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gaGasId = json['gaGasId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reciept_id'] = this.recieptId;
    data['driver'] = this.driver;
    data['car_plate'] = this.carPlate;
    data['fuel_type'] = this.fuelType;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['gaGasId'] = this.gaGasId;
    return data;
  }
}
