class Gas {
  late final String gasId;
  late final String status;
  late final String fuelType;
  late final int total;
  late final String date;
  late final Null comment;
  late final String createdAt;
  late final String updatedAt;

  Gas(
      {required this.gasId,
        required this.status,
        required this.fuelType,
        required this.total,
        required this.date,
        this.comment,
        required this.createdAt,
        required this.updatedAt});

  Gas.fromJson(Map<String, dynamic> json) {
    gasId = json['gas_id'];
    status = json['status'];
    fuelType = json['fuel_type'];
    total = json['total'];
    date = json['date'];
    comment = json['Comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gas_id'] = this.gasId;
    data['status'] = this.status;
    data['fuel_type'] = this.fuelType;
    data['total'] = this.total;
    data['date'] = this.date;
    data['Comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
